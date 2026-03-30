import XCTest
@testable import UDDF

final class MeasuredPO2Tests: XCTestCase {

    func testConvenienceInitializers() {
        let measuredPO2 = MeasuredPO2(bar: 1.2, ref: "sensor-center")

        XCTAssertEqual(measuredPO2.ref, "sensor-center")
        XCTAssertEqual(measuredPO2.pascals, 120000, accuracy: 0.001)
    }
}
