# UDDF Swift Implementation Notes

## Handling Enumerated Values in UDDF

The UDDF specification defines many attributes with fixed, enumerated values (e.g., `divemode type="closedcircuit"`). This document describes the three approaches for implementing these in Swift and when to use each.

### Option 1: Type-Safe Enum (PREFERRED)

Use type-safe enums for attributes with **compulsory fixed values** defined by the UDDF spec.

**When to use:**

- The UDDF spec defines a fixed, closed set of values
- Values are compulsory (not just recommended)
- The set of values is unlikely to expand frequently

**Implementation:**

```swift
public struct DiveMode: Codable, Equatable {
    public enum ModeType: String, Codable {
        case apnoe = "apnoe"
        case closedCircuit = "closedcircuit"
        case openCircuit = "opencircuit"
        case semiClosedCircuit = "semiclosedcircuit"
    }

    public var type: ModeType?

    public init(type: ModeType? = nil) {
        self.type = type
    }
}
```

**Benefits:**

- ✓ Compile-time type safety
- ✓ Autocomplete in IDEs
- ✓ Exhaustive switch coverage
- ✓ Self-documenting API
- ✓ Prevents invalid values

**Usage:**

```swift
// Creating
let mode = DiveMode(type: .closedCircuit)

// Pattern matching
switch waypoint.divemode?.type {
case .closedCircuit:
    print("CCR dive")
case .openCircuit:
    print("OC dive")
case .apnoe:
    print("Freediving")
case .semiClosedCircuit:
    print("SCR dive")
case .none:
    print("No mode specified")
}
```

### Option 2: Hybrid Enum with Custom Case (FALLBACK)

Use for attributes with fixed values that **may expand in future UDDF versions** or when parsing files from unknown sources.

**When to use:**

- The UDDF spec defines fixed values but may expand
- Need forward compatibility with unknown values
- Parsing files that might use non-standard extensions

**Implementation:**

```swift
public struct DiveMode: Codable, Equatable {
    public enum ModeType: Equatable {
        case apnoe
        case closedCircuit
        case openCircuit
        case semiClosedCircuit
        case custom(String)

        public var rawValue: String {
            switch self {
            case .apnoe: return "apnoe"
            case .closedCircuit: return "closedcircuit"
            case .openCircuit: return "opencircuit"
            case .semiClosedCircuit: return "semiclosedcircuit"
            case .custom(let value): return value
            }
        }
    }

    public var type: ModeType?
}

extension DiveMode.ModeType: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        switch value {
        case "apnoe": self = .apnoe
        case "closedcircuit": self = .closedCircuit
        case "opencircuit": self = .openCircuit
        case "semiclosedcircuit": self = .semiClosedCircuit
        default: self = .custom(value)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
```

**Benefits:**

- ✓ Type safety for known values
- ✓ Forward compatibility
- ✓ Graceful handling of unknown values
- ✓ Can still use pattern matching

**Usage:**

```swift
// Pattern matching with unknown values
switch waypoint.divemode?.type {
case .closedCircuit:
    print("CCR dive")
case .custom(let value):
    print("Unknown mode: \(value)")
default:
    break
}
```

### Option 3: String Constants (RESERVED)

Use only for **recommended but not compulsory values** where users might need arbitrary strings.

**When to use:**

- Values are recommended but not required by spec
- Users need flexibility for custom values
- The attribute accepts free-form text with common conventions

**Implementation:**

```swift
public struct SomeElement: Codable, Equatable {
    public struct CommonValues {
        public static let recommended1 = "value1"
        public static let recommended2 = "value2"
        public static let recommended3 = "value3"
    }

    public var attribute: String?
}
```

**Benefits:**

- ✓ Maximum flexibility
- ✓ Discoverable constants
- ✓ Backward/forward compatible

**Usage:**

```swift
// Using constants
element.attribute = SomeElement.CommonValues.recommended1

// Or custom values
element.attribute = "my-custom-value"
```

## Decision Tree

```
Is the attribute value compulsory and fixed by UDDF spec?
├─ Yes → Use Option 1 (Type-Safe Enum)
│
└─ No → Could the spec expand or are extensions likely?
    ├─ Yes → Use Option 2 (Hybrid Enum)
    │
    └─ No → Are these just recommended values?
        └─ Yes → Use Option 3 (String Constants)
```

## Examples in This Library

### Option 1 (Type-Safe Enum)

- `DiveMode.ModeType` - Fixed set of dive modes
- `DecoStop.Kind` - Fixed decompression stop types

### Option 2 (Hybrid Enum)

- Not currently used, reserved for future extensibility needs

### Option 3 (String Constants)

- Not currently used, would be appropriate for free-form fields like notes or custom identifiers

## Adding New Enumerated Types

When adding support for a new UDDF element with enumerated values:

1. Check the [UDDF specification](https://www.streit.cc/extern/uddf_v321/en/) for the attribute definition
2. Determine if values are compulsory or recommended
3. Choose the appropriate option using the decision tree above
4. Implement the enum as a nested type within the parent struct
5. Add documentation with links to the relevant UDDF spec section
6. Add test cases covering all enum values

## References

- [UDDF 3.2.1 Specification](https://www.streit.cc/extern/uddf_v321/en/)
- [UDDF divemode element](https://www.streit.cc/extern/uddf_v321/en/divemode.html)
- [UDDF waypoint element](https://www.streit.cc/extern/uddf_v321/en/waypoint.html)
