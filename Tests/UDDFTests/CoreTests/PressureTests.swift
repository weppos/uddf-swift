import XCTest
@testable import UDDF

final class PressureTests: XCTestCase {
    func testBarConversion() {
        let pressure = Pressure(bar: 200)

        XCTAssertEqual(pressure.pascals, 20_000_000)
        XCTAssertEqual(pressure.bar, 200.0)
        XCTAssertEqual(pressure.psi, 2900.753615789382)
        XCTAssertEqual(pressure.atmospheres, 197.38465334320257)
    }

    func testPSIInitializer() {
        let pressure = Pressure(psi: 3000)

        XCTAssertEqual(pressure.pascals, 20_684_280)
        XCTAssertEqual(pressure.psi, 3000.0)
        XCTAssertEqual(pressure.bar, 206.8428)
    }

    func testAtmospheresInitializer() {
        let pressure = Pressure(atmospheres: 1)

        XCTAssertEqual(pressure.pascals, 101_325)
        XCTAssertEqual(pressure.bar, 1.01325)
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
