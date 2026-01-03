# Agent Instructions

Instructions for AI coding agents when working on this project.

## Agent Organization

When creating agent instruction files:

- The main file should always be named `AGENTS.md`
- Create a `CLAUDE.md` symlink pointing to `AGENTS.md` for compatibility with Claude Code

## Project Overview

UDDF Swift is a Swift library for parsing, validating, and writing Universal Dive Data Format (UDDF) files. The library handles both spec-compliant files and real-world dive computer exports that may deviate from the specification.

## Key Documentation

- **[README.md](README.md)** - Library overview, features, usage examples, and API reference
- **[IMPLEMENTATION.md](IMPLEMENTATION.md)** - Implementation philosophy, design patterns, and technical decisions. **Update this file** when adding significant implementation caveats, design patterns, or architectural notes that future contributors should know.
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines, commit format, testing approach
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
├── ValidationTests/      # Validation tests
├── UDDFParserTests/     # Parser/Writer tests
├── UDDFBuilderTests/    # Builder API tests
├── ProfileDataTests/    # Profile data tests
├── ReferenceResolutionTests/ # Reference validation tests
└── Fixtures/            # Test fixtures
```

