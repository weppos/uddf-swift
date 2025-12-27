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
    .package(url: "https://github.com/yourusername/uddf-swift.git", from: "1.0.0")
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
let document = try UDDF.parse(xmlData)

// Parse directly from file
let document = try UDDF.parse(contentsOf: uddfFileURL)

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
let xmlData = try UDDF.write(document)

// Write directly to file
try UDDF.write(document, to: outputURL)

// Write without pretty printing (compact XML)
let compactData = try UDDF.write(document, prettyPrinted: false)
```

### Error Handling

```swift
do {
    let document = try UDDF.parse(xmlData)
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

## Current Status

### Phase 1: Foundation (Complete ✓)

- [x] Swift Package structure
- [x] XMLCoder integration
- [x] Basic parsing and writing
- [x] Error handling
- [x] Core models (Generator, UDDFDocument)
- [x] Round-trip tests
- [x] File I/O support

### Phase 2: Core Models (Complete ✓)

- [x] Unit types (Depth, Temperature, Pressure, Duration) with automatic conversions
- [x] UDDFDateTime with timezone support
- [x] ProfileData (dive profiles, waypoints, samples)
- [x] Diver (owner, buddy, personal information, equipment)
- [x] GasDefinitions (air, nitrox, trimix with gas analysis)
- [x] DiveSite (locations, GPS, geography)
- [x] MediaData (images, audio, video)
- [x] Maker (manufacturers)
- [x] Business (dive shops, training organizations)
- [x] DecoModel (decompression algorithms)
- [x] TableGeneration (dive tables)
- [x] DiveTrip (multi-dive trips)
- [x] DiveComputerControl (device configuration)
- [x] All 13 UDDF sections fully modeled
- [x] Comprehensive test coverage (26 passing tests)

### Phase 3: Cross-Reference Resolution (Complete ✓)

- [x] UDDFIdentifier type-safe wrapper for IDs
- [x] UDDFReference type for unresolved references
- [x] ReferenceResolver with ID registry
- [x] Duplicate ID detection
- [x] Unresolved reference detection
- [x] parseAndResolve() API
- [x] 10 comprehensive reference resolution tests
- [x] Total: 36 passing tests

### Upcoming Phases

**Phase 4: Builder API & Validation** (Next)

- [ ] Fluent builder API
- [ ] Validation framework
- [ ] Lenient parsing mode

**Phase 5: Documentation & Polish**

- [ ] Complete DocC documentation
- [ ] Example projects
- [ ] Performance optimization

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

MIT License (or specify your preferred license)

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.
