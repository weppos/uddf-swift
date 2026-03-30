import XCTest
@testable import UDDF

final class VolumeTests: XCTestCase {
    func testLitersConversion() {
        let volume = Volume(liters: 12)

        XCTAssertEqual(volume.cubicMeters, 0.012)
        XCTAssertEqual(volume.liters, 12.0)
        XCTAssertEqual(volume.cubicFeet, 0.4237766979319697)
    }

    func testCubicMetersInitializer() {
        let volume = Volume(cubicMeters: 0.012)

        XCTAssertEqual(volume.cubicMeters, 0.012)
        XCTAssertEqual(volume.liters, 12.0)
    }

    func testCubicFeetInitializer() {
        let volume = Volume(cubicFeet: 80)

        XCTAssertEqual(volume.cubicMeters, 2.265344)
        XCTAssertEqual(volume.cubicFeet, 80.0)
        XCTAssertEqual(volume.liters, 2265.3439999999996)
    }

    func testComparable() {
        XCTAssertLessThan(Volume(liters: 7), Volume(liters: 12))
    }

    func testCodableRoundTrip() throws {
        let volume = Volume(liters: 12)
        let data = try JSONEncoder().encode(volume)
        let decoded = try JSONDecoder().decode(Volume.self, from: data)

        XCTAssertEqual(decoded.cubicMeters, volume.cubicMeters)
        XCTAssertEqual(decoded.liters, 12.0)
    }
}
