import XCTest
@testable import UDDF

final class PressureTests: XCTestCase {
    func testBarConversion() {
        let pressure = Pressure(bar: 200)

        XCTAssertEqual(pressure.bar, 200.0)
        XCTAssertEqual(pressure.psi, 2900.76, accuracy: 0.01)
        XCTAssertEqual(pressure.atmospheres, 197.38, accuracy: 0.01)
    }

    func testPSIInitializer() {
        let pressure = Pressure(psi: 3000)

        XCTAssertEqual(pressure.psi, 3000.0, accuracy: 0.01)
        XCTAssertEqual(pressure.bar, 206.84, accuracy: 0.01)
    }

    func testAtmospheresInitializer() {
        let pressure = Pressure(atmospheres: 1)

        XCTAssertEqual(pressure.pascals, 101325, accuracy: 0.001)
        XCTAssertEqual(pressure.bar, 1.01325, accuracy: 0.00001)
    }

    func testComparable() {
        XCTAssertLessThan(Pressure(bar: 50), Pressure(bar: 200))
    }

    func testCodableRoundTrip() throws {
        let pressure = Pressure(bar: 232)
        let data = try JSONEncoder().encode(pressure)
        let decoded = try JSONDecoder().decode(Pressure.self, from: data)

        XCTAssertEqual(decoded.pascals, pressure.pascals)
    }
}
