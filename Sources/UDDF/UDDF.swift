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
/// let document = try UDDF.parse(data)
///
/// // Writing
/// let document = UDDFDocument(
///     version: "3.2.1",
///     generator: Generator(name: "MyApp", version: "1.0")
/// )
/// let xmlData = try UDDF.write(document)
/// ```
public struct UDDF {
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

    // MARK: - Writing

    /// Write UDDF document to Data
    ///
    /// - Parameters:
    ///   - document: UDDF document to write
    ///   - prettyPrinted: Whether to format XML with indentation (default: true)
    /// - Returns: XML data
    /// - Throws: UDDFError if writing fails
    public static func write(_ document: UDDFDocument, prettyPrinted: Bool = true) throws -> Data {
        let writer = UDDFWriter(prettyPrinted: prettyPrinted)
        return try writer.write(document)
    }

    /// Write UDDF document to a file URL
    ///
    /// - Parameters:
    ///   - document: UDDF document to write
    ///   - url: File URL to write to
    ///   - prettyPrinted: Whether to format XML with indentation (default: true)
    /// - Throws: UDDFError if writing fails
    public static func write(_ document: UDDFDocument, to url: URL, prettyPrinted: Bool = true) throws {
        let writer = UDDFWriter(prettyPrinted: prettyPrinted)
        try writer.write(document, to: url)
    }
}
