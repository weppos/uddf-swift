import XCTest
@testable import UDDF

final class WaypointTests: XCTestCase {

    func testDefaultsMeasuredPO2ToEmptyArray() {
        let waypoint = Waypoint()

        XCTAssertEqual(waypoint.measuredpo2, [])
    }

    func testDefaultsTankPressureToEmptyArray() {
        let waypoint = Waypoint()

        XCTAssertEqual(waypoint.tankpressure, [])
    }
}
