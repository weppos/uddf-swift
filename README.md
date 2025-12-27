# UDDF Swift

A comprehensive Swift library for parsing and writing UDDF (Universal Dive Data Format) v3.2.1 files.

## Overview

UDDF is an XML-based format for dive data exchange between applications and dive computers. This library provides type-safe parsing and writing capabilities with a clean, modern Swift API.

## Features

- **Type-safe parsing**: Convert UDDF XML into Swift structs with full type safety
- **Writing support**: Generate valid UDDF files from Swift models
- **Error handling**: Comprehensive error types with clear messages
- **Round-trip fidelity**: Parse → write → parse produces identical results
- **iOS and macOS support**: Works on iOS 15+ and macOS 12+

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
    manufacturer: ManufacturerInfo(
        name: "My Company",
        contact: Contact(
            homepage: "https://example.com",
            email: "info@example.com"
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

### Error Handling

```swift
do {
    let document = try UDDFSerialization.parse(xmlData)
    // Process document
} catch UDDFError.invalidXML(let detail) {
    print("Invalid XML: \(detail)")
} catch UDDFError.missingGenerator {
    print("UDDF files must contain a generator section")
} catch UDDFError.fileNotFound(let url) {
    print("File not found: \(url.path)")
} catch {
    print("Unexpected error: \(error)")
}
```

### Builder API

Create UDDF documents with a fluent, type-safe builder:

```swift
import UDDF

// Create a complete dive log
let owner = Owner(
    id: "diver1",
    personal: Personal(firstname: "John", lastname: "Diver")
)

let site = DiveSite(
    id: "reef1",
    name: "Coral Reef",
    geography: Geography(
        location: "Red Sea, Egypt",
        gps: GPS(latitude: 28.0, longitude: 34.0)
    )
)

let dive = Dive(
    id: "dive1",
    informationbeforedive: InformationBeforeDive(
        datetime: Date(),
        divenumber: 42
    ),
    informationafterdive: InformationAfterDive(
        greatestdepth: Depth(meters: 18.5),
        averagedepth: Depth(meters: 12.3),
        diveduration: Duration(minutes: 25)
    )
)

let document = try UDDFBuilder()
    .generator(name: "MyDiveApp", version: "1.0")
    .addOwner(owner)
    .addDiveSite(site)
    .addAir()                           // Convenience method for air
    .addNitrox(id: "ean32", oxygenPercent: 32)  // Convenience for nitrox
    .addDive(dive)
    .build()

// Write to file
try UDDFSerialization.write(document, to: outputURL)
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

## Test Fixtures

The library includes comprehensive test fixtures in `Tests/UDDFTests/Fixtures/`:

- `minimal.uddf` - Minimal valid UDDF (generator only)
- `full_profile.uddf` - Complete dive profile with all details
- `cross_references.uddf` - Multiple dives with various IDs
- `gas_definitions.uddf` - Various gas mixes (air, nitrox, trimix)
- `all_sections.uddf` - Example with all 13 UDDF sections
- `invalid/` - Malformed files for error handling tests

## Current Status

The UDDF Swift library is complete and production-ready:

- ✓ Full UDDF 3.2.1 specification support
- ✓ All 13 UDDF sections implemented
- ✓ Type-safe parsing and writing
- ✓ Fluent builder API
- ✓ Comprehensive validation framework
- ✓ ID/IDREF cross-reference resolution
- ✓ Automatic unit conversions
- ✓ 72 passing tests with >85% coverage
- ✓ Extensive documentation and examples

## Requirements

- iOS 15.0+ / macOS 12.0+
- Swift 5.9+
- Xcode 15.0+

## Dependencies

- [XMLCoder](https://github.com/CoreOffice/XMLCoder) (0.17.0+)

## UDDF Specification

This library implements the UDDF v3.2.1 specification:

https://www.streit.cc/extern/uddf_v321/en/index.html

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.
