import XCTest
@testable import UDDF

final class RealWorldFixtureTests: XCTestCase {
    func testParseShearwaterPerdixRealWorldFixture() throws {
        let fixtureURL = Bundle.module.url(
            forResource: "shearwater_perdix_closedcircuit_deco",
            withExtension: "uddf",
            subdirectory: "Fixtures/real"
        )!
        let data = try Data(contentsOf: fixtureURL)
        let document = try UDDFSerialization.parse(data)

        let waypoints = document.profiledata?.repetitiongroup?.first?.dive?.first?.samples?.waypoint
        XCTAssertNotNil(waypoints)
        XCTAssertEqual(waypoints?.count, 10)

        // Test first waypoint with gas switch
        let waypoint0 = waypoints?[0]
        XCTAssertEqual(waypoint0?.divetime?.seconds, 0)
        XCTAssertEqual(waypoint0?.depth?.meters, 0)
        XCTAssertEqual(waypoint0?.temperature?.kelvin, 299.15)
        XCTAssertEqual(waypoint0?.batterychargecondition, 3.43)
        XCTAssertEqual(waypoint0?.calculatedpo2 ?? 0, 1.19999993, accuracy: 0.001)
        XCTAssertEqual(waypoint0?.switchmix?.ref, "CC4:15/55")
        XCTAssertEqual(waypoint0?.divemode?.type, .closedCircuit)
        XCTAssertEqual(waypoint0?.gradientfactor, 0)

        // Test waypoint with NDL time
        let waypoint1 = waypoints?[1]
        XCTAssertEqual(waypoint1?.nodecotime?.seconds, 5940)
        XCTAssertEqual(waypoint1?.divemode?.type, .closedCircuit)

        // Test waypoint with deco stop (480 seconds)
        let waypoint3 = waypoints?[3]
        XCTAssertEqual(waypoint3?.cns, 5)
        XCTAssertEqual(waypoint3?.decostop?.kind, .mandatory)
        XCTAssertEqual(waypoint3?.decostop?.decodepth, 6)
        XCTAssertEqual(waypoint3?.decostop?.duration, 480)

        // Test waypoint with decreasing deco stop (420 seconds)
        let waypoint5 = waypoints?[5]
        XCTAssertEqual(waypoint5?.cns, 6)
        XCTAssertEqual(waypoint5?.decostop?.kind, .mandatory)
        XCTAssertEqual(waypoint5?.decostop?.decodepth, 6)
        XCTAssertEqual(waypoint5?.decostop?.duration, 420)

        // Test waypoint with further decreased deco stop (180 seconds)
        let waypoint9 = waypoints?[9]
        XCTAssertEqual(waypoint9?.cns, 8)
        XCTAssertEqual(waypoint9?.decostop?.kind, .mandatory)
        XCTAssertEqual(waypoint9?.decostop?.decodepth, 6)
        XCTAssertEqual(waypoint9?.decostop?.duration, 180)
        XCTAssertEqual(waypoint9?.gradientfactor, 52)
    }
}
