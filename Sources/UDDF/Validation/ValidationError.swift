import Foundation

/// A validation error with context
public struct ValidationError: Error, Equatable {
    /// The severity of the validation error
    public enum Severity: String, Equatable {
        case error
        case warning
    }

    /// Error severity
    public let severity: Severity

    /// The field or element that failed validation
    public let field: String

    /// Error message
    public let message: String

    /// Additional context
    public let context: [String: String]?

    public init(
        severity: Severity = .error,
        field: String,
        message: String,
        context: [String: String]? = nil
    ) {
        self.severity = severity
        self.field = field
        self.message = message
        self.context = context
    }
}

// MARK: - CustomStringConvertible

extension ValidationError: CustomStringConvertible {
    public var description: String {
        let severityStr = severity == .error ? "Error" : "Warning"
        var desc = "[\(severityStr)] \(field): \(message)"
        if let context = context, !context.isEmpty {
            let contextStr = context.map { "\($0.key)=\($0.value)" }.joined(separator: ", ")
            desc += " (\(contextStr))"
        }
        return desc
    }
}

/// Result of document validation
public struct ValidationResult: Equatable {
    /// All validation errors found
    public let errors: [ValidationError]

    /// All validation warnings found
    public let warnings: [ValidationError]

    /// Whether validation passed (no errors)
    public var isValid: Bool {
        errors.isEmpty
    }

    /// Whether there are any warnings
    public var hasWarnings: Bool {
        !warnings.isEmpty
    }

    /// Total number of issues (errors + warnings)
    public var issueCount: Int {
        errors.count + warnings.count
    }

    public init(errors: [ValidationError] = [], warnings: [ValidationError] = []) {
        self.errors = errors
        self.warnings = warnings
    }
}

// MARK: - CustomStringConvertible

extension ValidationResult: CustomStringConvertible {
    public var description: String {
        if isValid && !hasWarnings {
            return "Validation passed"
        }

        var parts: [String] = []
        if !errors.isEmpty {
            parts.append("\(errors.count) error(s)")
        }
        if !warnings.isEmpty {
            parts.append("\(warnings.count) warning(s)")
        }

        return "Validation: \(parts.joined(separator: ", "))"
    }
}
