import Foundation

/// Main entry point for parsing and writing UDDF files
///
/// UDDF (Universal Dive Data Format) is an XML-based format for dive data.
/// This library provides type-safe parsing and writing of UDDF 3.2.1 files.
///
/// Example usage:
///
/// ```swift
/// // Parsing
/// let data = try Data(contentsOf: uddfFileURL)
/// let document = try UDDFSerialization.parse(data)
///
/// // Writing
/// let document = UDDFDocument(
///     version: "3.2.1",
///     generator: Generator(name: "MyApp", version: "1.0")
/// )
/// let xmlData = try UDDFSerialization.write(document)
/// ```
public struct UDDFSerialization {
    // MARK: - Parsing

    /// Parse UDDF from Data
    ///
    /// - Parameter data: XML data to parse
    /// - Returns: Parsed UDDF document
    /// - Throws: UDDFError if parsing fails
    public static func parse(_ data: Data) throws -> UDDFDocument {
        let parser = UDDFParser()
        return try parser.parse(data)
    }

    /// Parse UDDF from a file URL
    ///
    /// - Parameter url: File URL to parse
    /// - Returns: Parsed UDDF document
    /// - Throws: UDDFError if file cannot be read or parsed
    public static func parse(contentsOf url: URL) throws -> UDDFDocument {
        let parser = UDDFParser()
        return try parser.parse(contentsOf: url)
    }

    // MARK: - Reference Resolution

    /// Parse UDDF and resolve all cross-references
    ///
    /// This method parses the document and validates that all ID/IDREF references
    /// can be resolved. It builds a registry of all elements with IDs and checks
    /// that all references point to valid elements.
    ///
    /// - Parameter data: XML data to parse
    /// - Returns: A tuple containing the parsed document and resolution result
    /// - Throws: UDDFError if parsing fails or references are invalid
    public static func parseAndResolve(_ data: Data) throws -> (document: UDDFDocument, resolution: ResolutionResult) {
        let document = try parse(data)
        let resolver = ReferenceResolver()
        let result = try resolver.resolve(document)

        // Throw if there are unresolved references
        if !result.isValid {
            let errorMessages = result.errors.map { $0.message }.joined(separator: ", ")
            throw UDDFError.unresolvedReference(errorMessages)
        }

        return (document, result)
    }

    /// Parse UDDF from file and resolve all cross-references
    ///
    /// - Parameter url: File URL to parse
    /// - Returns: A tuple containing the parsed document and resolution result
    /// - Throws: UDDFError if parsing fails or references are invalid
    public static func parseAndResolve(contentsOf url: URL) throws -> (document: UDDFDocument, resolution: ResolutionResult) {
        let data = try Data(contentsOf: url)
        return try parseAndResolve(data)
    }

    /// Resolve references in an already-parsed document
    ///
    /// - Parameter document: The UDDF document to resolve
    /// - Returns: Resolution result with registry and any errors
    /// - Throws: UDDFError if resolution fails
    public static func resolveReferences(in document: UDDFDocument) throws -> ResolutionResult {
        let resolver = ReferenceResolver()
        return try resolver.resolve(document)
    }

    // MARK: - Validation

    /// Validate a UDDF document
    ///
    /// Performs comprehensive validation including required elements, value ranges,
    /// and reference integrity.
    ///
    /// - Parameters:
    ///   - document: Document to validate
    ///   - options: Validation options
    /// - Returns: Validation result with errors and warnings
    public static func validate(
        _ document: UDDFDocument,
        options: UDDFValidator.Options = UDDFValidator.Options()
    ) -> ValidationResult {
        let validator = UDDFValidator(options: options)
        return validator.validate(document)
    }

    /// Parse and validate a UDDF document
    ///
    /// - Parameters:
    ///   - data: XML data to parse
    ///   - options: Validation options
    /// - Returns: Tuple of parsed document and validation result
    /// - Throws: UDDFError if parsing fails
    public static func parseAndValidate(
        _ data: Data,
        options: UDDFValidator.Options = UDDFValidator.Options()
    ) throws -> (document: UDDFDocument, validation: ValidationResult) {
        let document = try parse(data)
        let validation = validate(document, options: options)
        return (document, validation)
    }

    // MARK: - Writing

    /// Write UDDF document to Data
    ///
    /// - Parameters:
    ///   - document: UDDF document to write
    ///   - prettyPrinted: Whether to format XML with indentation (default: true)
    ///   - dateFormat: Date format for export (default: .local)
    /// - Returns: XML data
    /// - Throws: UDDFError if writing fails
    public static func write(
        _ document: UDDFDocument,
        prettyPrinted: Bool = true,
        dateFormat: UDDFDateFormat = .local
    ) throws -> Data {
        let writer = UDDFWriter(prettyPrinted: prettyPrinted, dateFormat: dateFormat)
        return try writer.write(document)
    }

    /// Write UDDF document to a file URL
    ///
    /// - Parameters:
    ///   - document: UDDF document to write
    ///   - url: File URL to write to
    ///   - prettyPrinted: Whether to format XML with indentation (default: true)
    ///   - dateFormat: Date format for export (default: .local)
    /// - Throws: UDDFError if writing fails
    public static func write(
        _ document: UDDFDocument,
        to url: URL,
        prettyPrinted: Bool = true,
        dateFormat: UDDFDateFormat = .local
    ) throws {
        let writer = UDDFWriter(prettyPrinted: prettyPrinted, dateFormat: dateFormat)
        try writer.write(document, to: url)
    }
}
