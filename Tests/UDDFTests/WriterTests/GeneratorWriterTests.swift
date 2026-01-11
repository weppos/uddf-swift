import XCTest
@testable import UDDF

final class GeneratorWriterTests: XCTestCase {

    func testWriteGeneratorWithMinimalAttributes() throws {
        let generator = Generator(
            name: "TestApp",
            version: "1.0.0"
        )
        let document = UDDFDocument(generator: generator)

        let data = try UDDFSerialization.write(document)
        let xmlString = String(data: data, encoding: .utf8)!

        XCTAssertTrue(xmlString.contains("<generator>"))
        XCTAssertTrue(xmlString.contains("<name>TestApp</name>"))
        XCTAssertTrue(xmlString.contains("<version>1.0.0</version>"))
        XCTAssertTrue(xmlString.contains("</generator>"))

        // Verify optional fields are not present
        XCTAssertFalse(xmlString.contains("<aliasname>"))
        XCTAssertFalse(xmlString.contains("<manufacturer>"))
        XCTAssertFalse(xmlString.contains("<datetime>"))
        XCTAssertFalse(xmlString.contains("<type>"))
        XCTAssertFalse(xmlString.contains("<link"))
    }
}
