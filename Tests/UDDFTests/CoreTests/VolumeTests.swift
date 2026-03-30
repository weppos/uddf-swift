import XCTest
@testable import UDDF

final class VolumeTests: XCTestCase {
    func testLitersConversion() {
        let volume = Volume(liters: 12)

        XCTAssertEqual(volume.liters, 12.0, accuracy: 0.01)
        XCTAssertEqual(volume.cubicMeters, 0.012, accuracy: 0.0001)
        XCTAssertEqual(volume.cubicFeet, 0.4238, accuracy: 0.001)
    }

    func testCubicMetersInitializer() {
        let volume = Volume(cubicMeters: 0.012)

        XCTAssertEqual(volume.cubicMeters, 0.012, accuracy: 0.0001)
        XCTAssertEqual(volume.liters, 12.0, accuracy: 0.01)
    }

    func testCubicFeetInitializer() {
        let volume = Volume(cubicFeet: 80)

        XCTAssertEqual(volume.cubicFeet, 80.0, accuracy: 0.01)
        XCTAssertEqual(volume.liters, 2265.35, accuracy: 0.1)
    }

    func testComparable() {
        XCTAssertLessThan(Volume(liters: 7), Volume(liters: 12))
    }

    func testCodableRoundTrip() throws {
        let volume = Volume(liters: 12)
        let data = try JSONEncoder().encode(volume)
        let decoded = try JSONDecoder().decode(Volume.self, from: data)

        XCTAssertEqual(decoded.cubicMeters, volume.cubicMeters, accuracy: 0.0001)
        XCTAssertEqual(decoded.liters, 12.0, accuracy: 0.01)
    }
}
