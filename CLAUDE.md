# Claude Code Instructions

Instructions for Claude Code when working on this project.

## Project Overview

UDDF Swift is a Swift library for parsing, validating, and writing Universal Dive Data Format (UDDF) files. The library handles both spec-compliant files and real-world dive computer exports that may deviate from the specification.

## Key Documentation

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines, commit format, testing approach
- **[UDDF Specification](https://www.streit.cc/extern/uddf_v321/en/)** - Official UDDF 3.2.1 specification
- **[Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)** - Apple's Swift style guide

## Project-Specific Context

### Parser vs Validator Philosophy

- **Parser**: Permissive - parse whatever valid XML exists, don't enforce UDDF rules
- **Validator**: Two modes
  - Default (strictMode: false): Allow real-world deviations with warnings
  - Strict (strictMode: true): Warnings become errors, full spec compliance

Use `addWarning()` for recommended fields (like generator.name), `addError()` for truly required data.

### Real-World First

The library prioritizes working with actual dive computer exports over strict spec compliance. When real-world files don't conform to spec recommendations (not requirements), the library should handle them gracefully with warnings, not errors.

### Code Style Notes

- Follow user's formatting rules in `~/.claude/CLAUDE.md`
- Never include Claude Code attribution in commits or code
- Use Conventional Commits format (see CONTRIBUTING.md)
- Follow Swift API Design Guidelines
- Use Swift's type system effectively (optionals, value types, etc.)

## Project Structure

```
Sources/UDDF/
├── Builder/        # Fluent builder API
├── Core/           # Units (Depth, Temperature, etc.), DateTime, Identifiers
├── Errors/         # Error types
├── Models/         # Swift structs/types for UDDF sections
├── Parser/         # XML parsing and writing (XMLCoder-based)
└── Validation/     # Document validation

Tests/UDDFTests/
├── ValidationTests/      # Validation tests
├── UDDFParserTests/     # Parser/Writer tests
├── UDDFBuilderTests/    # Builder API tests
├── ProfileDataTests/    # Profile data tests
├── ReferenceResolutionTests/ # Reference validation tests
└── Fixtures/            # Test fixtures
```

## Swift-Specific Notes

- Uses **XMLCoder** for XML encoding/decoding
- Value types (structs) for models
- Codable conformance for serialization
- Leverage optionals for missing/optional fields
- Use `try`/`throws` for error handling
- Protocol-oriented design where appropriate
