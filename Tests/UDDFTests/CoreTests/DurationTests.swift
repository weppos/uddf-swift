import XCTest
@testable import UDDF

final class DurationTests: XCTestCase {
    func testMinutesInitializerConvertsToSecondsAndHours() {
        let duration = Duration(minutes: 45)

        XCTAssertEqual(duration.seconds, 2700.0)
        XCTAssertEqual(duration.minutes, 45.0)
        XCTAssertEqual(duration.hours, 0.75)
    }

    func testHoursInitializerConvertsToMinutesAndSeconds() {
        let duration = Duration(hours: 1.5)

        XCTAssertEqual(duration.hours, 1.5)
        XCTAssertEqual(duration.minutes, 90.0)
        XCTAssertEqual(duration.seconds, 5400.0)
    }

    func testComparable() {
        XCTAssertLessThan(Duration(minutes: 30), Duration(minutes: 45))
    }

    func testDescriptionFormatsSecondsMinutesAndHours() {
        XCTAssertEqual(Duration(seconds: 45).description, "45s")
        XCTAssertEqual(Duration(minutes: 45).description, "45m")
        XCTAssertEqual(Duration(hours: 1.5).description, "1.5h")
    }

    func testCodableRoundTrip() throws {
        let duration = Duration(minutes: 42)
        let data = try JSONEncoder().encode(duration)
        let decoded = try JSONDecoder().decode(Duration.self, from: data)

        XCTAssertEqual(decoded.seconds, duration.seconds)
    }
}
