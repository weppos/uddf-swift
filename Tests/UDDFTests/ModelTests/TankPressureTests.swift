import XCTest
@testable import UDDF

final class TankPressureTests: XCTestCase {

    func testConvenienceInitializers() {
        let tankPressure = TankPressure(bar: 200, ref: "backgas")

        XCTAssertEqual(tankPressure.ref, "backgas")
        XCTAssertEqual(tankPressure.pascals, 20000000, accuracy: 0.001)
    }
}
