import Foundation
import XMLCoder

/// Writer for UDDF XML files
///
/// Uses XMLCoder to encode Swift types into UDDF XML format. Configured to
/// produce valid UDDF files with proper formatting and attributes.
class UDDFWriter {
    private let encoder: XMLEncoder
    private let prettyPrinted: Bool

    init(prettyPrinted: Bool = true) {
        self.prettyPrinted = prettyPrinted
        encoder = XMLEncoder()

        // UDDF uses ISO 8601 date format
        encoder.dateEncodingStrategy = .iso8601

        // Encode data as base64
        encoder.dataEncodingStrategy = .base64

        // Set output formatting (don't use sortedKeys to preserve element order)
        encoder.outputFormatting = prettyPrinted ? [.prettyPrinted] : []
    }

    /// Write a UDDF document to Data
    ///
    /// - Parameter document: UDDF document to write
    /// - Returns: XML data
    /// - Throws: UDDFError if encoding fails
    func write(_ document: UDDFDocument) throws -> Data {
        do {
            // Validate document before writing
            try validateDocument(document)

            let data = try encoder.encode(document, withRootKey: "uddf")
            return data
        } catch let error as UDDFError {
            throw error
        } catch {
            throw UDDFError.invalidXML("Failed to encode UDDF: \(error.localizedDescription)")
        }
    }

    /// Write a UDDF document to a file URL
    ///
    /// - Parameters:
    ///   - document: UDDF document to write
    ///   - url: File URL to write to
    /// - Throws: UDDFError if writing fails
    func write(_ document: UDDFDocument, to url: URL) throws {
        let data = try write(document)

        do {
            try data.write(to: url)
        } catch {
            throw UDDFError.unwritableFile(url)
        }
    }

    // MARK: - Private Helpers

    private func validateDocument(_ document: UDDFDocument) throws {
        // Writer validates structure, not content
        // Content validation happens in UDDFValidator

        // Ensure version is valid
        if document.version.isEmpty {
            throw UDDFError.invalidVersion(document.version)
        }
    }
}
