# UDDF Swift Implementation Notes

## Parser vs Validator Philosophy

- **Parser**: Permissive - parse whatever valid XML exists, don't enforce UDDF rules
- **Validator**: Two modes
  - Default (strictMode: false): Allow real-world deviations with warnings
  - Strict (strictMode: true): Warnings become errors, full spec compliance

Use `addWarning()` for recommended fields (like generator.name), `addError()` for truly required data.

### Real-World First

The library prioritizes working with actual dive computer exports over strict spec compliance. When real-world files don't conform to spec recommendations (not requirements), the library should handle them gracefully with warnings, not errors.

## UDDF Extensions

Some dive computer exporters include fields that are not part of the UDDF 3.2.3 specification. We support a limited set of these extensions when they are widely used in practice.

- **Salinity (`<salinity>`)**: Stored under `<informationbeforedive>` as `<salinity density="...">fresh|salt</salinity>`. This is an extension based on libdivecomputer's de-facto UDDF export behavior. Treat it as optional and preserve it on round-trip.

    ```xml
    <salinity density="1025.0">salt</salinity>
    ```

- **`<tts>` on `<waypoint>`**: Time-to-surface in seconds. Emitted by Shearwater Cloud Desktop. Not part of UDDF 3.2.3 — preserved on round-trip but tagged in `Waypoint` under a `// MARK: - Non-spec extensions` block.

The previously-extension `<heartrate>` element became a spec element in UDDF 3.2.3 (in beats per second / SI 1/s). It is no longer listed here.

## UDDF 3.2.2 / 3.2.3 changes

Cumulative additions across UDDF 3.2.2 and 3.2.3, all modeled in this library:

- `<waypoint>` gained `<bodytemperature>` (Kelvin), `<pulserate>` (1/s), `<setmarker>` (text, multiple) in 3.2.2.
- `<waypoint>` gained `<heartrate>` (1/s) in 3.2.3.
- `<certification>` gained `<certificatenumber>` in 3.2.2.
- `<divemode>/@type=apnoe` was renamed to `@type=apnea` in 3.2.2; both forms are accepted on parse, but the writer emits `"apnea"`.
- `<setdcgasdefinitionsdata>` gained `<setdcallgasdefinitions/>` and `<setdcgasdata ref="…"/>` children in 3.2.2.
- The `<divecomputercontrol>` section is now fully modeled, including its three children — `<divecomputerdump>`, `<getdcdata>`, and `<setdcdata>` — and every documented grandchild.

### Parent-placement resolution in 3.2.3

UDDF 3.2.3 resolved three of the five previously-contradictory placement issues (see the Spec Inconsistencies section below). For the library, this meant:

- `equipmentused` and `program` moved from `InformationBeforeDive` to `InformationAfterDive` (BREAKING for the Swift API).
- Parser tolerates the legacy location: when an `<equipmentused>` or `<program>` element appears under `<informationbeforedive>`, the decoder routes it into `informationafterdive` so files written by older versions of this library (or other emitters following the old placement) keep parsing cleanly.
- Writer always emits at the UDDF 3.2.3 location.

## Attributed Intrinsic Scalars

Some UDDF elements combine an XML attribute with scalar text content, for example `<price currency="EUR">499.99</price>` or `<measuredpo2 ref="sensor-1">120000</measuredpo2>`.

When XML is pretty-printed, XMLCoder may expose the intrinsic text as multiple whitespace-padded fragments during decode. For machine-valued scalar content such as `Double`, decode through the shared `decodeTrimmedIntrinsicValue(forKey:)` helper so formatting whitespace is ignored while preserving the parser's global `trimValueWhitespaces = false` behavior for free-form text fields.

## UDDF Specification Inconsistencies

The UDDF 3.2.3 specification still contains a few internal inconsistencies where the prose/schema and the examples disagree. This section documents the cases we've encountered and the decisions we've made.

### `tankpressure`: `ref` vs `tankref`

Persists through UDDF 3.2.3 (verified). The [`tankpressure` spec page](https://www.streit.cc/resources/UDDF/v3.2.3/en/tankpressure.html) defines the attribute as `ref`, but the XML example on the same page uses `tankref`:

```xml
<!-- From the spec example -->
<tankpressure tankref="tank_air">20000000.0</tankpressure>
<tankpressure tankref="tank_o2">18000000.0</tankpressure>
```

**Decision:** We use `ref` to stay consistent with `measuredpo2`, which also uses `ref` as a cross-reference attribute on an intrinsic scalar element. Real-world exporters should be tested to determine which attribute name they actually use; if `tankref` appears in practice, we may need to support both during parsing.

### Parent Element Disagreements

UDDF 3.2.3 resolved three of the five parent-placement contradictions catalogued under 3.2.1. The current state:

| Element | Spec status in 3.2.3 | Our placement |
|---------|----------------------|---------------|
| `equipmentused` | Resolved — `informationafterdive` (both element page and parent's child list agree) | `informationafterdive` |
| `purpose` | Resolved — `informationbeforedive` | `informationbeforedive` |
| `program` | Resolved — `informationafterdive` | `informationafterdive` |
| `exercisebeforedive` | Still contradictory — element page says parent is `<dive>`, but `<dive>`'s child list omits it (orphaned) | `informationbeforedive` (backwards-compatible) |
| `hyperbaricfacilitytreatment` | Still contradictory — same orphan condition as `exercisebeforedive` | `informationafterdive` (backwards-compatible) |

For the two still-orphaned elements, the spec's element-page parent claims are unreachable from the parent-side child lists; we keep the previous placement so existing fixtures and consumers do not break, and we document the residual issue inline.

For `equipmentused` and `program`, the migration to `informationafterdive` is supported by a parser fallback that re-routes the legacy location on input (see "UDDF 3.2.2 / 3.2.3 changes" above).

## Handling Enumerated Values in UDDF

The UDDF specification defines many attributes with fixed, enumerated values (e.g., `divemode type="closedcircuit"`). This document describes the three approaches for implementing these in Swift and when to use each.

**TL;DR**: Use **Option 2 (Hybrid Enum)** for robustness in real-world scenarios.

### Option 2: Hybrid Enum with Unknown Case (PREFERRED)

Use for attributes with fixed UDDF values that need resilience for real-world usage.

**When to use:**

- The UDDF spec defines fixed values (compulsory or recommended)
- Need to parse files from various sources without failure
- Future UDDF versions might add new values
- Need type safety for known values while handling unknowns gracefully

**Why this is preferred:**

- ✓ **Parsing never fails** - Unknown values don't crash the parser
- ✓ **Forward compatible** - New UDDF spec values handled automatically
- ✓ **Type safety** for known standard values
- ✓ **String conversion** always succeeds (database, user input, etc.)
- ✓ **Pattern matching** still exhaustive
- ✓ **Detect non-standard** values with `.isStandard` property

**Implementation:**

```swift
public struct DiveMode: Codable, Equatable {
    public enum ModeType: Equatable {
        case apnoe
        case closedCircuit
        case openCircuit
        case semiClosedCircuit
        case unknown(String)  // Handles any non-standard value

        public var rawValue: String {
            switch self {
            case .apnoe: return "apnoe"
            case .closedCircuit: return "closedcircuit"
            case .openCircuit: return "opencircuit"
            case .semiClosedCircuit: return "semiclosedcircuit"
            case .unknown(let value): return value
            }
        }

        public init(rawValue: String) {
            switch rawValue {
            case "apnoe": self = .apnoe
            case "closedcircuit": self = .closedCircuit
            case "opencircuit": self = .openCircuit
            case "semiclosedcircuit": self = .semiClosedCircuit
            default: self = .unknown(rawValue)
            }
        }

        public var isStandard: Bool {
            if case .unknown = self {
                return false
            }
            return true
        }
    }

    public var type: ModeType?
}

extension DiveMode.ModeType: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(rawValue: value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
```

**Benefits:**

- ✓ Type safety for known values with exhaustive pattern matching
- ✓ Graceful degradation for unknown values
- ✓ Can detect and log non-standard values
- ✓ Database/string conversion via `init(rawValue:)` never fails

**Usage:**

```swift
// 1. Parsing files with unknown values - NO FAILURE!
// XML: <divemode type="gauge" />  (not in standard)
let doc = try UDDFSerialization.parse(data)  // ✓ Succeeds!

if let mode = waypoint.divemode?.type {
    if !mode.isStandard {
        print("⚠️  Non-standard mode: \(mode.rawValue)")
        // Log to analytics, warn user, etc.
    }
}

// 2. String conversion from database - ALWAYS SUCCEEDS!
let dbValue = "gauge"
let mode = DiveMode.ModeType(rawValue: dbValue)  // ✓ Creates .unknown("gauge")

// 3. Pattern matching with exhaustive checking
switch waypoint.divemode?.type {
case .closedCircuit:
    print("CCR dive")
case .openCircuit:
    print("OC dive")
case .apnoe:
    print("Freediving")
case .semiClosedCircuit:
    print("SCR dive")
case .unknown(let value):
    print("Non-standard mode: \(value)")
case .none:
    print("No mode specified")
}

// 4. Creating values - Type-safe for standard, flexible for unknown
waypoint.divemode = DiveMode(type: .closedCircuit)  // ✓ Type-safe
waypoint.divemode = DiveMode(type: .unknown("gauge"))  // ✓ Also works
```

### Option 1: Simple Type-Safe Enum (FALLBACK)

Use only when you control all data sources and know they're strictly UDDF-compliant.

**When to use:**

- You control all UDDF file generation
- Data is guaranteed to only use standard values
- Want simpler code without `.unknown` case

**Warning:** ⚠️ Parsing will **fail completely** if file contains unknown values!

**Implementation:**

```swift
public enum ModeType: String, Codable {
    case apnoe = "apnoe"
    case closedCircuit = "closedcircuit"
    case openCircuit = "opencircuit"
    case semiClosedCircuit = "semiclosedcircuit"
}
```

**Problems:**

- ❌ Parsing fails on unknown values (throws `DecodingError`)
- ❌ String conversion returns `nil` for unknown values
- ❌ No forward compatibility with future UDDF specs

### Option 3: String Constants (SPECIAL CASES)

Use only for **recommended but not compulsory values** where users need arbitrary strings.

**When to use:**

- Values are recommended guidelines, not requirements
- Users legitimately need custom values
- The attribute accepts free-form text

**Implementation:**

```swift
public struct SomeElement: Codable, Equatable {
    public struct CommonValues {
        public static let recommended1 = "value1"
        public static let recommended2 = "value2"
    }

    public var attribute: String?  // Any string allowed
}
```

**Usage:**

```swift
element.attribute = SomeElement.CommonValues.recommended1
element.attribute = "my-custom-value"  // Also valid
```

### Decision Tree

```
Does the UDDF spec define fixed enumerated values?
├─ Yes → Use Option 2 (Hybrid Enum) ✓ PREFERRED
│        - Resilient to unknown values
│        - Type-safe for known values
│        - Forward compatible
│
└─ No → Are there recommended common values?
    ├─ Yes → Use Option 3 (String Constants)
    │
    └─ No → Use plain String
```

### Real-World Scenarios

#### Scenario 1: Parsing Unknown Values

**Problem:** File from Shearwater contains `<divemode type="gauge" />` (gauge mode not in UDDF 3.2.1))

**Option 1 Result:**

```swift
try UDDFSerialization.parse(data)  // ❌ Throws error, parsing fails
```

**Option 2 Result:**

```swift
let doc = try UDDFSerialization.parse(data)  // ✓ Succeeds
let mode = waypoint.divemode?.type  // .unknown("gauge")
print(mode?.isStandard)  // false
```

#### Scenario 2: Database String Conversion

**Problem:** Need to create enum from database string `"gauge"`

**Option 1 Result:**

```swift
if let mode = ModeType(rawValue: "gauge") {
    // Never executes - returns nil
} else {
    // ❌ Conversion failed, need error handling
}
```

**Option 2 Result:**

```swift
let mode = ModeType(rawValue: "gauge")  // ✓ Always succeeds
// Returns .unknown("gauge")
```

#### Scenario 3: Logging Non-Standard Values

**Option 2 Only:**

```swift
func validateDive(_ dive: Dive) {
    for waypoint in dive.samples?.waypoint ?? [] {
        if let mode = waypoint.divemode?.type, !mode.isStandard {
            logger.warning("Non-standard dive mode: \(mode.rawValue)")
        }

        if let kind = waypoint.decostop?.kind, !kind.isStandard {
            logger.warning("Non-standard deco stop: \(kind.rawValue)")
        }
    }
}
```

### Examples in This Library

#### Implemented with Option 2

- **`DiveMode.ModeType`** - Dive breathing apparatus modes in [UDDF divemode element](https://www.streit.cc/resources/UDDF/v3.2.3/en/divemode.html)
  - Standard: `.apnea`, `.closedCircuit`, `.openCircuit`, `.semiClosedCircuit`
  - Unknown: `.unknown(String)`
  - Backwards compat: the decoder also accepts the legacy `"apnoe"` spelling (pre-UDDF 3.2.2) and maps it to `.apnea`; the encoder always emits `"apnea"`.

- **`DecoStop.StopKind`** - Decompression stop types in [UDDF waypoint element](https://www.streit.cc/resources/UDDF/v3.2.3/en/waypoint.html)
  - Standard: `.mandatory`, `.safety`
  - Unknown: `.unknown(String)`

#### Not Currently Used

- **Option 1**: Reserved for strictly controlled environments only
- **Option 3**: Would be appropriate for free-form fields (not yet needed)

### Adding New Enumerated Types

When adding support for a new UDDF element with enumerated values:

1. Check the [UDDF specification](https://www.streit.cc/resources/UDDF/v3.2.3/en/) for the attribute definition
2. **Default to Option 2** (hybrid enum) unless you have a specific reason not to
3. Implement as a nested type within the parent struct
4. Include `.unknown(String)` case and `.isStandard` property
5. Add `init(rawValue:)` and manual `Codable` conformance
6. Document with links to the relevant UDDF spec section
7. Add test cases for:
   - All standard enum values
   - Unknown/non-standard values
   - String-to-enum conversion
   - Parsing resilience
