import XCTest
@testable import UDDF

final class UDDFWriterTests: XCTestCase {
    func testWriteIncludesXMLDeclaration() throws {
        let document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(name: "TestApp", version: "1.0.0")
        )

        let data = try UDDFSerialization.write(document)
        let xmlString = String(data: data, encoding: .utf8)

        XCTAssertNotNil(xmlString)
        XCTAssertTrue(
            xmlString!.hasPrefix("<?xml version=\"1.0\" encoding=\"utf-8\"?>"),
            "XML output should start with XML declaration"
        )
    }

    func testWriteNonPrettyPrintedIncludesXMLDeclaration() throws {
        let document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(name: "TestApp", version: "1.0.0")
        )

        let data = try UDDFSerialization.write(document, prettyPrinted: false)
        let xmlString = String(data: data, encoding: .utf8)

        XCTAssertNotNil(xmlString)
        XCTAssertTrue(
            xmlString!.hasPrefix("<?xml version=\"1.0\" encoding=\"utf-8\"?>"),
            "XML output should start with XML declaration even when not pretty printed"
        )
    }

    func testWriteIncludesXmlns() throws {
        let document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(name: "TestApp", version: "1.0.0")
        )

        let data = try UDDFSerialization.write(document)
        let xmlString = String(data: data, encoding: .utf8)!

        XCTAssertTrue(
            xmlString.contains("xmlns=\"http://www.streit.cc/uddf/3.2/\""),
            "XML output should include UDDF namespace: \(xmlString)"
        )
    }

    // MARK: - Date Format Tests

    func testWriteDateWithLocalFormat() throws {
        var document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(name: "TestApp", version: "1.0.0")
        )
        document.generator.datetime = Date()

        let data = try UDDFSerialization.write(document, dateFormat: .local)
        let xmlString = String(data: data, encoding: .utf8)!

        XCTAssertTrue(xmlString.contains("</datetime>"), "Should contain datetime element")
        XCTAssertFalse(xmlString.contains("Z</datetime>"), "Local format should not have Z suffix")
    }

    func testWriteDateWithUTCFormat() throws {
        var document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(name: "TestApp", version: "1.0.0")
        )
        document.generator.datetime = Date()

        let data = try UDDFSerialization.write(document, dateFormat: .utc)
        let xmlString = String(data: data, encoding: .utf8)!

        XCTAssertTrue(xmlString.contains("Z</datetime>"), "UTC format should have Z suffix")
    }
}
