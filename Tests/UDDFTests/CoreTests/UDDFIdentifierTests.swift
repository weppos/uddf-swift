import XCTest
@testable import UDDF

final class UDDFIdentifierTests: XCTestCase {
    func testStringLiteralInitialization() {
        let identifier: UDDFIdentifier = "tank-1"

        XCTAssertEqual(identifier.value, "tank-1")
    }

    func testCodableRoundTrip() throws {
        let identifier = UDDFIdentifier("sensor-1")
        let data = try JSONEncoder().encode(identifier)
        let decoded = try JSONDecoder().decode(UDDFIdentifier.self, from: data)

        XCTAssertEqual(decoded, identifier)
    }

    func testDescriptionReturnsRawValue() {
        XCTAssertEqual(UDDFIdentifier("tank-42").description, "tank-42")
    }
}
