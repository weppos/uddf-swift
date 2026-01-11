import Foundation
import XMLCoder

/// Date format options for UDDF export
public enum UDDFDateFormat {
    /// UTC time with Z suffix (e.g., 2025-09-30T10:49:17Z)
    case utc

    /// Local time without timezone (e.g., 2025-09-30T12:49:17)
    case local
}

/// Writer for UDDF XML files
///
/// Uses XMLCoder to encode Swift types into UDDF XML format. Configured to
/// produce valid UDDF files with proper formatting and attributes.
class UDDFWriter {
    private let encoder: XMLEncoder
    private let prettyPrinted: Bool

    init(prettyPrinted: Bool = true, dateFormat: UDDFDateFormat = .local) {
        self.prettyPrinted = prettyPrinted
        encoder = XMLEncoder()

        // Configure date encoding based on format option
        switch dateFormat {
        case .utc:
            encoder.dateEncodingStrategy = .iso8601
        case .local:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
        }

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

            let header = XMLHeader(version: 1.0, encoding: "utf-8")
            let data = try encoder.encode(document, withRootKey: "uddf", header: header)
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
