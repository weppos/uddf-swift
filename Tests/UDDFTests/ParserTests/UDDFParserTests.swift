import XCTest
@testable import UDDF

final class UDDFParserTests: XCTestCase {
    // MARK: - Minimal Document Tests

    func testParseMinimalDocument() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDF.parse(data)

        XCTAssertEqual(document.version, "3.2.1")
        XCTAssertEqual(document.generator.name, "TestApp")
    }

    func testParseDocumentWithGeneratorDetails() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
                <version>1.0.0</version>
                <manufacturer>
                    <name>Test Manufacturer</name>
                    <contact>
                        <homepage>https://example.com</homepage>
                        <email>info@example.com</email>
                    </contact>
                </manufacturer>
            </generator>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDF.parse(data)

        XCTAssertEqual(document.version, "3.2.1")
        XCTAssertEqual(document.generator.name, "TestApp")
        XCTAssertEqual(document.generator.version, "1.0.0")
        XCTAssertEqual(document.generator.manufacturer?.name, "Test Manufacturer")
        XCTAssertEqual(document.generator.manufacturer?.contact?.homepage, "https://example.com")
        XCTAssertEqual(document.generator.manufacturer?.contact?.email, "info@example.com")
    }

    // MARK: - Round-Trip Tests

    func testRoundTrip() throws {
        // Create a document
        let generator = Generator(
            name: "TestApp",
            manufacturer: ManufacturerInfo(
                name: "Test Manufacturer",
                contact: Contact(
                    homepage: "https://example.com",
                    email: "info@example.com"
                )
            ),
            version: "1.0.0"
        )
        let originalDocument = UDDFDocument(version: "3.2.1", generator: generator)

        // Write it
        let xmlData = try UDDF.write(originalDocument)

        // Parse it back
        let reparsedDocument = try UDDF.parse(xmlData)

        // Verify equality
        XCTAssertEqual(reparsedDocument.version, originalDocument.version)
        XCTAssertEqual(reparsedDocument.generator, originalDocument.generator)
    }

    func testRoundTripWithoutPrettyPrinting() throws {
        let generator = Generator(name: "TestApp", version: "1.0.0")
        let originalDocument = UDDFDocument(version: "3.2.1", generator: generator)

        let xmlData = try UDDF.write(originalDocument, prettyPrinted: false)
        let reparsedDocument = try UDDF.parse(xmlData)

        XCTAssertEqual(reparsedDocument.generator, originalDocument.generator)
    }

    // MARK: - Error Handling Tests

    func testParseInvalidXML() throws {
        let invalidXML = "This is not XML"
        let data = invalidXML.data(using: .utf8)!

        XCTAssertThrowsError(try UDDF.parse(data)) { error in
            guard case UDDFError.invalidXML = error else {
                XCTFail("Expected invalidXML error, got \(error)")
                return
            }
        }
    }

    func testParseMissingGenerator() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
        </uddf>
        """

        let data = xml.data(using: .utf8)!

        XCTAssertThrowsError(try UDDF.parse(data)) { error in
            guard case UDDFError.missingRequiredElement = error else {
                XCTFail("Expected missingRequiredElement error, got \(error)")
                return
            }
        }
    }

    func testParseFileNotFound() throws {
        let url = URL(fileURLWithPath: "/nonexistent/file.uddf")

        XCTAssertThrowsError(try UDDF.parse(contentsOf: url)) { error in
            guard case UDDFError.fileNotFound = error else {
                XCTFail("Expected fileNotFound error, got \(error)")
                return
            }
        }
    }

    // MARK: - File I/O Tests

    func testWriteAndReadFile() throws {
        let generator = Generator(name: "TestApp", version: "1.0.0")
        let document = UDDFDocument(version: "3.2.1", generator: generator)

        // Create temporary file
        let tempDir = FileManager.default.temporaryDirectory
        let tempFile = tempDir.appendingPathComponent("test.uddf")

        // Write to file
        try UDDF.write(document, to: tempFile)

        // Read back from file
        let readDocument = try UDDF.parse(contentsOf: tempFile)

        // Verify
        XCTAssertEqual(readDocument.generator, document.generator)

        // Clean up
        try? FileManager.default.removeItem(at: tempFile)
    }
}
