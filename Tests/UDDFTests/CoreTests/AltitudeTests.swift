import XCTest
@testable import UDDF

final class AltitudeTests: XCTestCase {
    func testMetersToFeetConversion() {
        let altitude = Altitude(meters: 1000)

        XCTAssertEqual(altitude.meters, 1000.0)
        XCTAssertEqual(altitude.feet, 3280.839895013123)
    }

    func testFeetToMetersConversion() {
        let altitude = Altitude(feet: 5000)

        XCTAssertEqual(altitude.feet, 5000.0)
        XCTAssertEqual(altitude.meters, 1524.0)
    }

    func testComparable() {
        XCTAssertLessThan(Altitude(meters: 500), Altitude(meters: 1500))
    }

    func testCodableRoundTrip() throws {
        let altitude = Altitude(meters: 1200)
        let data = try JSONEncoder().encode(altitude)
        let decoded = try JSONDecoder().decode(Altitude.self, from: data)

        XCTAssertEqual(decoded.meters, altitude.meters)
    }
}
