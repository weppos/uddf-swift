import Foundation
import XMLCoder

/// Parser for UDDF XML files
///
/// Uses XMLCoder to decode UDDF XML into Swift types. Configured specifically
/// for UDDF's requirements including attribute handling and date parsing.
class UDDFParser {
    private let decoder: XMLDecoder

    init() {
        decoder = XMLDecoder()

        // Configure decoder for UDDF format
        decoder.shouldProcessNamespaces = false

        // UDDF uses ISO 8601 date format
        decoder.dateDecodingStrategy = .iso8601

        // Decode data as base64 if present
        decoder.dataDecodingStrategy = .base64

        // Don't trim whitespace - preserve exact content
        decoder.trimValueWhitespaces = false
    }

    /// Parse UDDF data into a UDDFDocument
    ///
    /// - Parameter data: XML data to parse
    /// - Returns: Parsed UDDF document
    /// - Throws: UDDFError if parsing fails
    func parse(_ data: Data) throws -> UDDFDocument {
        do {
            let document = try decoder.decode(UDDFDocument.self, from: data)

            // Parser is permissive - parse what exists, validate separately
            return document
        } catch let error as UDDFError {
            throw error
        } catch let error as DecodingError {
            throw mapDecodingError(error)
        } catch {
            throw UDDFError.invalidXML(error.localizedDescription)
        }
    }

    /// Parse UDDF from a file URL
    ///
    /// - Parameter url: File URL to parse
    /// - Returns: Parsed UDDF document
    /// - Throws: UDDFError if file cannot be read or parsed
    func parse(contentsOf url: URL) throws -> UDDFDocument {
        // Check file exists
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw UDDFError.fileNotFound(url)
        }

        // Read data
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw UDDFError.unreadableFile(url)
        }

        return try parse(data)
    }

    // MARK: - Private Helpers

    private func mapDecodingError(_ error: DecodingError) -> UDDFError {
        switch error {
        case .keyNotFound(let key, let context):
            return .missingRequiredElement("\(key.stringValue) at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
        case .valueNotFound(_, let context):
            return .missingRequiredElement(context.codingPath.map { $0.stringValue }.joined(separator: "."))
        case .typeMismatch(_, let context):
            return .invalidXML("Type mismatch at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")): \(context.debugDescription)")
        case .dataCorrupted(let context):
            return .invalidXML("Data corrupted at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")): \(context.debugDescription)")
        @unknown default:
            return .invalidXML(error.localizedDescription)
        }
    }
}
