# UDDF Swift

A comprehensive Swift library for parsing and writing UDDF (Universal Dive Data Format) v3.2.1 files.

> [!WARNING]
> This library is a development preview and the API can still change.

## Overview

UDDF is an XML-based format for dive data exchange between applications and dive computers. This library provides type-safe parsing and writing capabilities with a clean, modern Swift API.

## Features

- **Type-safe parsing**: Convert UDDF XML into Swift structs with full type safety
- **Writing support**: Generate valid UDDF files from Swift models
- **Error handling**: Comprehensive error types with clear messages
- **Round-trip fidelity**: Parse → write → parse produces identical results
- **Real-world extensions**: Supports common non-standard fields
- **iOS and macOS support**: Works on iOS 15+ and macOS 12+

## UDDF Extensions

UDDF Swift supports a small number of non-standard tags that appear in real-world exports. These are treated as optional extensions and clearly labeled as such.

`profiledata`:

- `informationbeforedive` -> **`salinity`**: A libdivecomputer de-facto standard used by some dive computers.
- `samples` -> `waypoint` -> **`heartrate`**: Heart rate in beats per minute. Used by dive computers with heart rate monitoring (e.g., Garmin Descent series).

`gasdefinitions`:

- `mix` -> **`usage`**: A libdivecomputer extension for gas mix usage type (`oxygen`, `diluent`, `sidemount`).

## Installation

### Swift Package Manager

Add this package to your `Package.swift`:

```swift
dependencies:
[
    .package(url: "https://github.com/weppos/uddf-swift.git", from: "1.0.0")
]
```

Or add it in Xcode:

1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version

## Usage

### Parsing UDDF Files

```swift
import UDDF

// Parse from Data
let xmlData = try Data(contentsOf: uddfFileURL)
let document = try UDDFSerialization.parse(xmlData)

// Parse directly from file
let document = try UDDFSerialization.parse(contentsOf: uddfFileURL)

// Access parsed data
print("Generator: \(document.generator.name)")
print("Version: \(document.version)")
```

### Writing UDDF Files

```swift
import UDDF

// Create a document
let generator = Generator(
    name: "MyDiveApp",
    version: "1.0.0",
    manufacturer: Manufacturer(
        id: "mycompany",
        name: "My Company",
        contact: Contact(
            email: "info@example.com",
            homepage: "https://example.com"
        )
    )
)

let document = UDDFDocument(
    version: "3.2.1",
    generator: generator
)

// Write to Data
let xmlData = try UDDFSerialization.write(document)

// Write directly to file
try UDDFSerialization.write(document, to: outputURL)

// Write without pretty printing (compact XML)
let compactData = try UDDFSerialization.write(document, prettyPrinted: false)
```

### Validation

Validate UDDF documents with comprehensive checks:

```swift
import UDDF

let document = try UDDFSerialization.parse(xmlData)

// Basic validation
let result = UDDFSerialization.validate(document)

if result.isValid {
    print("✓ Document is valid")
} else {
    print("✗ Found \(result.errors.count) error(s):")
    for error in result.errors {
        print("  - \(error)")
    }
}

if result.hasWarnings {
    print("⚠ \(result.warnings.count) warning(s):")
    for warning in result.warnings {
        print("  - \(warning)")
    }
}

// Parse and validate in one step
let (doc, validation) = try UDDFSerialization.parseAndValidate(xmlData)

// Strict mode (warnings become errors)
var options = UDDFValidator.Options()
options.strictMode = true
let strictResult = UDDFSerialization.validate(document, options: options)

// Disable range validation for special cases
options.validateRanges = false
let lenientResult = UDDFSerialization.validate(document, options: options)
```

### Reference Resolution

Validate ID/IDREF cross-references:

```swift
import UDDF

// Parse and resolve all references
let (document, resolution) = try UDDFSerialization.parseAndResolve(xmlData)

if resolution.isValid {
    print("✓ All references resolved successfully")
    print("  Registry contains \(resolution.registry.count) elements")
} else {
    print("✗ Reference errors:")
    for error in resolution.errors {
        print("  - \(error.message) at \(error.location)")
    }
}

// Or resolve separately
let document = try UDDFSerialization.parse(xmlData)
let resolution = try UDDFSerialization.resolveReferences(in: document)
```

### Working with Unit Types

UDDF Swift provides type-safe units with automatic conversion:

```swift
import UDDF

// Depth
let depth = Depth(meters: 18.0)
print(depth.meters)  // 18.0
print(depth.feet)    // 59.06 (automatic conversion)

let depthFromFeet = Depth(feet: 60.0)
print(depthFromFeet.meters)  // 18.288

// Temperature
let temp = Temperature(kelvin: 300.0)
print(temp.kelvin)      // 300.0
print(temp.celsius)     // 26.85
print(temp.fahrenheit)  // 80.33

// Pressure
let pressure = Pressure(bar: 200.0)
print(pressure.bar)    // 200.0
print(pressure.psi)    // 2900.75

// Duration
let duration = Duration(seconds: 1500.0)
print(duration.seconds)  // 1500.0
print(duration.minutes)  // 25.0
print(duration.hours)    // 0.417
```

## API Reference

### UDDFSerialization

The main entry point for parsing, writing, validating, and resolving references.

```swift
public struct UDDFSerialization {
    // Parsing
    public static func parse(_ data: Data) throws -> UDDFDocument
    public static func parse(contentsOf url: URL) throws -> UDDFDocument

    // Reference resolution
    public static func parseAndResolve(_ data: Data) throws -> (document: UDDFDocument, resolution: ResolutionResult)
    public static func parseAndResolve(contentsOf url: URL) throws -> (document: UDDFDocument, resolution: ResolutionResult)
    public static func resolveReferences(in document: UDDFDocument) throws -> ResolutionResult

    // Validation
    public static func validate(_ document: UDDFDocument, options: UDDFValidator.Options = .init()) -> ValidationResult
    public static func parseAndValidate(_ data: Data, options: UDDFValidator.Options = .init()) throws -> (document: UDDFDocument, validation: ValidationResult)

    // Writing
    public static func write(_ document: UDDFDocument, prettyPrinted: Bool = true, dateFormat: UDDFDateFormat = .local) throws -> Data
    public static func write(_ document: UDDFDocument, to url: URL, prettyPrinted: Bool = true, dateFormat: UDDFDateFormat = .local) throws
}
```

### UDDFValidator

Validates UDDF documents for correctness and compliance.

```swift
public class UDDFValidator {
    public struct Options {
        public var validateRanges: Bool       // Default: true
        public var validateReferences: Bool   // Default: true
        public var strictMode: Bool           // Default: false
    }

    public init(options: Options = Options())
    public func validate(_ document: UDDFDocument) -> ValidationResult
}
```

### ReferenceResolver

Resolves and validates ID/IDREF references across the document.

```swift
public class ReferenceResolver {
    public init()
    public func resolve(_ document: UDDFDocument) throws -> ResolutionResult
    public func element(for id: String) -> ReferenceableElement?
    public func contains(id: String) -> Bool
    public var allIDs: [String] { get }
}
```

## Error Handling

The library throws `UDDFError` cases for all error conditions:

```swift
import UDDF

do {
    let document = try UDDFSerialization.parse(xmlData)
    // Process document
} catch UDDFError.invalidXML(let detail) {
    print("Invalid XML: \(detail)")
} catch UDDFError.missingGenerator {
    print("UDDF files must contain a generator section")
} catch UDDFError.fileNotFound(let url) {
    print("File not found: \(url.path)")
} catch let error as UDDFError {
    print("UDDF error: \(error.localizedDescription)")
}
```

Error cases:

| Case | When it's thrown |
| --- | --- |
| `invalidXML(String)` | Malformed XML or unparseable structure |
| `invalidVersion(String)` | Unsupported UDDF version |
| `missingRequiredElement(String)` | A required XML element is absent |
| `invalidElementOrder` | XML elements appear in an unexpected order |
| `unresolvedReference(String)` | An IDREF points to an ID that doesn't exist |
| `duplicateID(String)` | The same ID is used by multiple elements |
| `invalidIDFormat(String)` | An ID value doesn't match the expected format |
| `missingGenerator` | The required `<generator>` section is absent |
| `invalidDateTime(String)` | Date/time value cannot be parsed |
| `invalidUnit(String)` | Unit value or format is invalid |
| `fileNotFound(URL)` | File doesn't exist at the given URL |
| `unreadableFile(URL)` | File exists but cannot be read |
| `unwritableFile(URL)` | File cannot be written to the given URL |

## Requirements

- iOS 15.0+ / macOS 12.0+
- Swift 5.9+
- Xcode 15.0+

## Dependencies

- [XMLCoder](https://github.com/CoreOffice/XMLCoder) (0.17.0+)

## UDDF Specification

This library implements [UDDF v3.2.1](https://www.streit.cc/extern/uddf_v321/en/index.html), supporting all major sections:

- Generator (required)
- Maker
- Business
- Diver
- Dive Site
- Gas Definitions
- Decompression Model
- Profile Data
- Table Generation
- Dive Trip
- Dive Computer Control
- Media Data

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history.

## License

[MIT License](LICENSE.txt)
