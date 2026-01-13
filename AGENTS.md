# Agent Instructions

Instructions for AI coding agents when working on this project.

## Agent Organization

When creating agent instruction files:

- The main file should always be named `AGENTS.md`
- Create a `CLAUDE.md` file containing `@AGENTS.md` for compatibility with Claude Code

## Project Overview

UDDF Swift is a Swift library for parsing, validating, and writing Universal Dive Data Format (UDDF) files. The library handles both spec-compliant files and real-world dive computer exports that may deviate from the specification.

## Key Instructions

- @README.md - Library overview, features, usage examples, and API reference.
- @CONTRIBUTING.md - Contribution guidelines, commit format, testing approach.
- @RELEASING.md - Release process, versioning, and changelog management.
- @IMPLEMENTATION.md - Implementation philosophy, design patterns, and technical decisions. **Update this file** when adding significant implementation caveats, design patterns, or architectural notes that future contributors should know.

## Key Documentation

- **[UDDF Specification](https://www.streit.cc/extern/uddf_v321/en/)** - Official UDDF 3.2.1 specification
- **[Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)** - Apple's Swift style guide

## Project-Specific Context

### Code Style Notes

- Use Conventional Commits format (see [CONTRIBUTING.md](CONTRIBUTING.md#commit-message-guidelines))
- Follow Swift API Design Guidelines (see [CONTRIBUTING.md](CONTRIBUTING.md#code-style))
- Use Swift's type system effectively (optionals, value types, etc.) (see [CONTRIBUTING.md](CONTRIBUTING.md#swift-specific-guidelines))
- Do not include AI attribution in commit messages or code comments

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
├── BuilderTests/         # Builder API tests
├── IntegrationTests/     # High-level fixture tests
├── ModelTests/           # Model unit tests (enums, value types, etc.)
├── ParserTests/          # XML parsing tests (one file per section)
├── SerializationTests/   # Round-trip serialization tests (one file per section)
├── ValidationTests/      # Validation tests
├── WriterTests/          # XML writing tests (one file per section)
└── Fixtures/             # Test fixtures organized by UDDF section
```

### Test Organization

Tests are organized by UDDF section with consistent naming:

- **ModelTests/<Section>Tests.swift** - Model/enum unit tests (initialization, enum values)
- **ParserTests/<Section>ParserTests.swift** - XML parsing tests (minimal + complete)
- **SerializationTests/<Section>SerializationTests.swift** - Round-trip serialization tests
- **WriterTests/<Section>WriterTests.swift** - XML writing tests

Each parser test file should include:

- `testParseMinimal()` - Minimal valid section with required elements only
- `testParseComplete()` - Complete section with all optional elements
