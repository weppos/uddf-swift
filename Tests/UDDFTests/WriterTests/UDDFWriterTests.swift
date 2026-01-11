import XCTest
@testable import UDDF

final class UDDFWriterTests: XCTestCase {
    func testWriteIncludesXMLDeclaration() throws {
        let document = try UDDFBuilder()
            .generator(name: "TestApp", version: "1.0.0")
            .build()

        let data = try UDDFSerialization.write(document)
        let xmlString = String(data: data, encoding: .utf8)

        XCTAssertNotNil(xmlString)
        XCTAssertTrue(
            xmlString!.hasPrefix("<?xml version=\"1.0\" encoding=\"utf-8\"?>"),
            "XML output should start with XML declaration"
        )
    }

    func testWriteNonPrettyPrintedIncludesXMLDeclaration() throws {
        let document = try UDDFBuilder()
            .generator(name: "TestApp", version: "1.0.0")
            .build()

        let data = try UDDFSerialization.write(document, prettyPrinted: false)
        let xmlString = String(data: data, encoding: .utf8)

        XCTAssertNotNil(xmlString)
        XCTAssertTrue(
            xmlString!.hasPrefix("<?xml version=\"1.0\" encoding=\"utf-8\"?>"),
            "XML output should start with XML declaration even when not pretty printed"
        )
    }

    func testWriteIncludesXmlns() throws {
        let document = try UDDFBuilder()
            .generator(name: "TestApp", version: "1.0.0")
            .build()

        let data = try UDDFSerialization.write(document)
        let xmlString = String(data: data, encoding: .utf8)!

        XCTAssertTrue(
            xmlString.contains("xmlns=\"http://www.streit.cc/uddf/3.2/\""),
            "XML output should include UDDF namespace: \(xmlString)"
        )
    }
}
