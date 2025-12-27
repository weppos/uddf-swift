import Foundation

/// Comprehensive error types for UDDF operations
public enum UDDFError: Error, LocalizedError {
    // MARK: - Parsing Errors

    /// Invalid XML structure or malformed XML data
    case invalidXML(String)

    /// Unsupported or invalid UDDF version
    case invalidVersion(String)

    /// Required XML element is missing
    case missingRequiredElement(String)

    /// XML elements are not in the expected order
    case invalidElementOrder

    // MARK: - Reference Errors

    /// IDREF references an ID that doesn't exist in the document
    case unresolvedReference(String)

    /// Multiple elements have the same ID
    case duplicateID(String)

    /// ID format is invalid
    case invalidIDFormat(String)

    // MARK: - Validation Errors

    /// Required generator section is missing
    case missingGenerator

    /// Date/time format is invalid
    case invalidDateTime(String)

    /// Unit value or format is invalid
    case invalidUnit(String)

    // MARK: - I/O Errors

    /// File not found at specified URL
    case fileNotFound(URL)

    /// File exists but cannot be read
    case unreadableFile(URL)

    /// Cannot write to specified location
    case unwritableFile(URL)

    // MARK: - LocalizedError

    public var errorDescription: String? {
        switch self {
        case .invalidXML(let detail):
            return "Invalid XML: \(detail)"
        case .invalidVersion(let version):
            return "Unsupported UDDF version: \(version)"
        case .missingRequiredElement(let element):
            return "Required element '\(element)' is missing"
        case .invalidElementOrder:
            return "XML elements are not in the expected order"
        case .unresolvedReference(let ref):
            return "Unresolved reference: \(ref)"
        case .duplicateID(let id):
            return "Duplicate ID found: \(id)"
        case .invalidIDFormat(let id):
            return "Invalid ID format: \(id)"
        case .missingGenerator:
            return "UDDF files must contain a <generator> section"
        case .invalidDateTime(let value):
            return "Invalid date/time format: \(value)"
        case .invalidUnit(let value):
            return "Invalid unit value: \(value)"
        case .fileNotFound(let url):
            return "File not found: \(url.path)"
        case .unreadableFile(let url):
            return "Cannot read file: \(url.path)"
        case .unwritableFile(let url):
            return "Cannot write to file: \(url.path)"
        }
    }
}
