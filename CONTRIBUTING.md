# Contributing to UDDF Swift

Thank you for your interest in contributing to UDDF Swift!

## Development Workflow

1. Fork and clone the repository
2. Open Package.swift in Xcode or use Swift Package Manager
3. Create a branch: `git checkout -b feature/your-feature`
4. Make your changes
5. Run tests: `swift test`
6. Build: `swift build`
7. Commit using Conventional Commits format (see below)
8. Push and create a pull request

## Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for commit messages, with a capitalized description. Use the project-specific conventions below.

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Type

- **feat**: A new feature
- **fix**: A bug fix
- **chore**: Other changes that don't modify src or test files
- **docs**: Documentation only changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Performance improvement
- **test**: Adding or updating tests
- **build**: Changes to build system or external dependencies
- **ci**: Changes to CI configuration files and scripts

### Scope

- **parser**: XML parsing
- **writer**: XML writing
- **validation**: Validation logic
- **builder**: Fluent builder API
- **models**: Swift types/models
- **core**: Core utilities (units, etc.)

### Examples

```bash
feat(parser): Add support for UDDF 3.3.0 format

fix(validation): Allow missing generator names in real-world files

docs: update API examples in README

refactor(core): Simplify depth unit conversions
```

### Breaking Changes

Add `BREAKING CHANGE:` in the footer:

```
feat(validation): Change validation return type

BREAKING CHANGE: ValidationResult now uses Set instead of Array.
Update code accessing result.errors accordingly.
```

## Changelog

We follow the [Common Changelog](https://common-changelog.org/) format for changelog entries.

## Testing

### Running Tests

```bash
swift test                          # Run all tests
swift test --filter ValidationTests # Run specific test suite
swift test --parallel              # Run tests in parallel
```

### Writing Tests

- **Unit tests**: `Tests/UDDFTests/` organized by feature
- **Integration tests**: Use fixtures in test bundles
- **Test fixtures**: Real-world UDDF files for testing

### Real-World Integration Testing

When encountering UDDF files from dive computers that don't work:

1. Add fixture to test bundle
2. Write focused test verifying parsing and validation
3. Document the spec deviation in test comments

Example:

```swift
func testOceanicMissingGeneratorName() throws {
    let data = try loadFixture("oceanic-missing-generator-name.uddf")
    let document = try UDDFSerialization.parse(data)

    XCTAssertNotNil(document.generator.manufacturer)

    let result = UDDFSerialization.validate(document)
    XCTAssertTrue(result.isValid)
    XCTAssertTrue(result.hasWarnings)
}
```

## Pull Request Process

1. Update documentation for API changes
2. Add tests for new features or bug fixes
3. Ensure all tests pass: `swift test`
4. Use Conventional Commits format
5. Provide clear PR description with context
6. Reference related issues if applicable

## Code Style

- Follow Swift API Design Guidelines
- Use SwiftLint configuration if present
- Add documentation comments for public APIs
- Follow existing naming conventions:
  - Types: PascalCase
  - Methods/Properties: camelCase
  - Constants: camelCase (not UPPER_SNAKE_CASE)
  - Use descriptive names

### Swift-Specific Guidelines

- Uses **XMLCoder** for XML encoding/decoding
- Use value types (struct) where appropriate
- Codable conformance for serialization
- Leverage Swift's type system and optionals for missing/optional fields
- Use `try`/`throws` for error handling
- Protocol-oriented design where appropriate
- Prefer immutability when possible
- Use guard for early returns

### Documentation

- Add documentation comments (`///`) for public APIs
- Add `// MARK:` sections for organization
- Include code examples in documentation
- Update README.md for user-facing changes
- Keep inline comments minimal - prefer self-documenting code

## Questions?

Open an issue for questions, feature discussions, or bug reports.

Thank you for contributing! 🎉
