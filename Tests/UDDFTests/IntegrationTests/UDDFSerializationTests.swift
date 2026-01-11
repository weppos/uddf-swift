import XCTest
@testable import UDDF

/// High-level tests for UDDFSerialization API
final class UDDFSerializationTests: XCTestCase {
    // MARK: - Date Format Round-Trip Tests

    func testRoundTripWithLocalDateFormat() throws {
        var document = try UDDFBuilder()
            .generator(name: "TestApp", version: "1.0.0")
            .build()
        document.generator.datetime = Date()

        let data = try UDDFSerialization.write(document, dateFormat: .local)
        let reparsed = try UDDFSerialization.parse(data)

        XCTAssertEqual(reparsed.generator.name, document.generator.name)
        XCTAssertNotNil(reparsed.generator.datetime)
    }

    func testRoundTripWithUTCDateFormat() throws {
        var document = try UDDFBuilder()
            .generator(name: "TestApp", version: "1.0.0")
            .build()
        document.generator.datetime = Date()

        let data = try UDDFSerialization.write(document, dateFormat: .utc)
        let reparsed = try UDDFSerialization.parse(data)

        XCTAssertEqual(reparsed.generator.name, document.generator.name)
        XCTAssertNotNil(reparsed.generator.datetime)
    }
}
