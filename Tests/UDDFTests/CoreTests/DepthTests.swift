import XCTest
@testable import UDDF

final class DepthTests: XCTestCase {
    func testMetersToFeetConversion() {
        let depth = Depth(meters: 10)

        XCTAssertEqual(depth.meters, 10.0)
        XCTAssertEqual(depth.feet, 32.8084, accuracy: 0.001)
    }

    func testFeetToMetersConversion() {
        let depth = Depth(feet: 33)

        XCTAssertEqual(depth.feet, 33.0, accuracy: 0.001)
        XCTAssertEqual(depth.meters, 10.0584, accuracy: 0.001)
    }

    func testComparable() {
        XCTAssertLessThan(Depth(meters: 5), Depth(meters: 10))
    }

    func testCodableRoundTrip() throws {
        let depth = Depth(meters: 15.5)
        let data = try JSONEncoder().encode(depth)
        let decoded = try JSONDecoder().decode(Depth.self, from: data)

        XCTAssertEqual(decoded.meters, depth.meters)
    }
}
