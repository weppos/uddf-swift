import XCTest
@testable import UDDF

final class ProfileDataTests: XCTestCase {
    func testParseProfileData() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <profiledata>
                <repetitiongroup id="rg1">
                    <dive id="dive1">
                        <informationafterdive>
                            <greatestdepth>18.5</greatestdepth>
                            <diveduration>2700</diveduration>
                        </informationafterdive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        XCTAssertNotNil(document.profiledata)
        XCTAssertEqual(document.profiledata?.repetitiongroup?.count, 1)

        let dive = document.profiledata?.repetitiongroup?.first?.dive?.first
        XCTAssertNotNil(dive)
        XCTAssertEqual(dive?.id, "dive1")
        XCTAssertEqual(dive?.informationafterdive?.greatestdepth?.meters, 18.5)
        XCTAssertEqual(dive?.informationafterdive?.diveduration?.seconds, 2700)
    }

    func testParseWaypoints() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive>
                        <samples>
                            <waypoint>
                                <divetime>0</divetime>
                                <depth>0</depth>
                            </waypoint>
                            <waypoint>
                                <divetime>60</divetime>
                                <depth>10.5</depth>
                                <temperature>293.15</temperature>
                            </waypoint>
                        </samples>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let waypoints = document.profiledata?.repetitiongroup?.first?.dive?.first?.samples?.waypoint
        XCTAssertNotNil(waypoints)
        XCTAssertEqual(waypoints?.count, 2)

        let waypoint1 = waypoints?[0]
        XCTAssertEqual(waypoint1?.divetime?.seconds, 0)
        XCTAssertEqual(waypoint1?.depth?.meters, 0)

        let waypoint2 = waypoints?[1]
        XCTAssertEqual(waypoint2?.divetime?.seconds, 60)
        XCTAssertEqual(waypoint2?.depth?.meters, 10.5)
        XCTAssertNotNil(waypoint2?.temperature)
        XCTAssertEqual(waypoint2?.temperature?.celsius ?? 0, 20, accuracy: 0.01)
    }

    func testParseExtendedWaypointFields() throws {
        let fixtureURL = Bundle.module.url(
            forResource: "waypoint_extended_fields",
            withExtension: "uddf",
            subdirectory: "Fixtures"
        )!
        let data = try Data(contentsOf: fixtureURL)
        let document = try UDDFSerialization.parse(data)

        let waypoints = document.profiledata?.repetitiongroup?.first?.dive?.first?.samples?.waypoint
        XCTAssertNotNil(waypoints)
        XCTAssertEqual(waypoints?.count, 3)

        // Waypoint 0: Surface with setpoint, battery, PPO2
        let waypoint0 = waypoints?[0]
        XCTAssertEqual(waypoint0?.divetime?.seconds, 0)
        XCTAssertEqual(waypoint0?.depth?.meters, 0)
        XCTAssertEqual(waypoint0?.temperature?.celsius ?? 0, 20, accuracy: 0.01)
        XCTAssertEqual(waypoint0?.batterychargecondition, 3.5)
        XCTAssertEqual(waypoint0?.calculatedpo2, 1.2)
        XCTAssertEqual(waypoint0?.setpo2?.pascals ?? 0, 1.2e5, accuracy: 0.01)
        XCTAssertEqual(waypoint0?.setpo2?.bar ?? 0, 1.2, accuracy: 0.01)
        XCTAssertEqual(waypoint0?.switchmix?.ref, "mix1")
        XCTAssertEqual(waypoint0?.tankpressure?.pascals ?? 0, 2.0e7, accuracy: 0.01)
        XCTAssertEqual(waypoint0?.divemode?.type, .closedCircuit)
        XCTAssertEqual(waypoint0?.gradientfactor, 0)
        XCTAssertNil(waypoint0?.nodecotime)
        XCTAssertNil(waypoint0?.remainingbottomtime)

        // Waypoint 1: Shallow with NDL, RBT, setpoint, heart rate
        let waypoint1 = waypoints?[1]
        XCTAssertEqual(waypoint1?.divetime?.seconds, 60)
        XCTAssertEqual(waypoint1?.depth?.meters, 5.0)
        XCTAssertEqual(waypoint1?.batterychargecondition, 3.48)
        XCTAssertEqual(waypoint1?.heartrate, 75)
        XCTAssertEqual(waypoint1?.nodecotime?.seconds, 5940)
        XCTAssertEqual(waypoint1?.remainingbottomtime?.seconds, 1800)
        XCTAssertEqual(waypoint1?.setpo2?.bar ?? 0, 1.2, accuracy: 0.01)
        XCTAssertEqual(waypoint1?.tankpressure?.pascals ?? 0, 1.95e7, accuracy: 0.01)
        XCTAssertEqual(waypoint1?.divemode?.type, .closedCircuit)
        XCTAssertEqual(waypoint1?.gradientfactor, 5)

        // Waypoint 2: Depth with deco stop, CNS, TTS
        let waypoint2 = waypoints?[2]
        XCTAssertEqual(waypoint2?.divetime?.seconds, 1200)
        XCTAssertEqual(waypoint2?.depth?.meters, 40.0)
        XCTAssertEqual(waypoint2?.cns, 8)
        XCTAssertEqual(waypoint2?.decostop?.kind, .mandatory)
        XCTAssertEqual(waypoint2?.decostop?.decodepth, 6)
        XCTAssertEqual(waypoint2?.decostop?.duration, 300)
        XCTAssertEqual(waypoint2?.heartrate, 80)
        XCTAssertEqual(waypoint2?.setpo2?.bar ?? 0, 1.3, accuracy: 0.01)
        XCTAssertEqual(waypoint2?.tankpressure?.pascals ?? 0, 1.8e7, accuracy: 0.01)
        XCTAssertEqual(waypoint2?.tts?.seconds, 600)
        XCTAssertEqual(waypoint2?.divemode?.type, .closedCircuit)
        XCTAssertEqual(waypoint2?.gradientfactor, 65)
    }

    func testParseShearwaterRealWorldFixture() throws {
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

    func testEnumUnknownValues() throws {
        // Test that unknown enum values are parsed gracefully
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive>
                        <samples>
                            <waypoint>
                                <divemode type="gauge" />
                                <decostop kind="recommended" decodepth="3" duration="180" />
                                <depth>10</depth>
                                <divetime>60</divetime>
                            </waypoint>
                        </samples>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let waypoint = document.profiledata?.repetitiongroup?.first?.dive?.first?.samples?.waypoint?.first
        XCTAssertNotNil(waypoint)

        // Unknown dive mode should parse as .unknown("gauge")
        XCTAssertEqual(waypoint?.divemode?.type?.rawValue, "gauge")
        XCTAssertEqual(waypoint?.divemode?.type?.isStandard, false)
        if case .unknown(let value) = waypoint?.divemode?.type {
            XCTAssertEqual(value, "gauge")
        } else {
            XCTFail("Expected .unknown case")
        }

        // Unknown deco stop kind should parse as .unknown("recommended")
        XCTAssertEqual(waypoint?.decostop?.kind?.rawValue, "recommended")
        XCTAssertEqual(waypoint?.decostop?.kind?.isStandard, false)
        if case .unknown(let value) = waypoint?.decostop?.kind {
            XCTAssertEqual(value, "recommended")
        } else {
            XCTFail("Expected .unknown case")
        }
    }

    func testEnumStringConversion() {
        // Test standard values
        let mode1 = DiveMode.ModeType(rawValue: "closedcircuit")
        XCTAssertEqual(mode1, .closedCircuit)
        XCTAssertEqual(mode1.isStandard, true)

        // Test unknown values
        let mode2 = DiveMode.ModeType(rawValue: "gauge")
        XCTAssertEqual(mode2.rawValue, "gauge")
        XCTAssertEqual(mode2.isStandard, false)

        // Test DecoStop
        let kind1 = DecoStop.StopKind(rawValue: "mandatory")
        XCTAssertEqual(kind1, .mandatory)
        XCTAssertEqual(kind1.isStandard, true)

        let kind2 = DecoStop.StopKind(rawValue: "deep")
        XCTAssertEqual(kind2.rawValue, "deep")
        XCTAssertEqual(kind2.isStandard, false)
    }
}
