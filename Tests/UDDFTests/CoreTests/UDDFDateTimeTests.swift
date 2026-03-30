import Foundation
import XCTest
@testable import UDDF

final class UDDFDateTimeTests: XCTestCase {
    func testDecodeInternetDateTimeWithUTC() throws {
        let dateTime = try decode("\"2025-12-27T14:00:00Z\"")

        XCTAssertEqual(dateTime.timezone?.secondsFromGMT(), 0)
        XCTAssertEqual(dateTime.description, "2025-12-27T14:00:00Z")
    }

    func testDecodeInternetDateTimeWithOffsetPreservesTimezone() throws {
        let dateTime = try decode("\"2025-12-27T14:00:00+01:00\"")

        XCTAssertEqual(dateTime.timezone?.secondsFromGMT(), 3600)
        XCTAssertEqual(try encode(dateTime), "\"2025-12-27T14:00:00+01:00\"")
    }

    func testDecodeFullDateLeavesTimezoneNil() throws {
        let dateTime = try decode("\"2025-12-27\"")

        XCTAssertNil(dateTime.timezone)
        XCTAssertEqual(try encode(dateTime), "\"2025-12-27T00:00:00Z\"")
    }

    func testInvalidDateThrows() {
        XCTAssertThrowsError(try decode("\"not-a-date\""))
    }

    func testComparableUsesUnderlyingDate() throws {
        let earlier = try decode("\"2025-12-27T14:00:00Z\"")
        let later = try decode("\"2025-12-27T15:00:00Z\"")

        XCTAssertLessThan(earlier, later)
    }

    private func decode(_ json: String) throws -> UDDFDateTime {
        try JSONDecoder().decode(UDDFDateTime.self, from: Data(json.utf8))
    }

    private func encode(_ dateTime: UDDFDateTime) throws -> String {
        let data = try JSONEncoder().encode(dateTime)
        return String(decoding: data, as: UTF8.self)
    }
}
