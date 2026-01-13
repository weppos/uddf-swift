import XCTest
@testable import UDDF

final class GeneratorSerializationTests: XCTestCase {

    func testRoundTrip() throws {
        let generator = Generator(
            name: "TestApp",
            version: "1.0.0"
        )
        let document = UDDFDocument(generator: generator)

        let data = try UDDFSerialization.write(document)
        let parsed = try UDDFSerialization.parse(data)

        XCTAssertEqual(parsed.generator.name, "TestApp")
        XCTAssertEqual(parsed.generator.version, "1.0.0")
        XCTAssertNil(parsed.generator.aliasname)
        XCTAssertNil(parsed.generator.manufacturer)
        XCTAssertNil(parsed.generator.type)
    }
}
