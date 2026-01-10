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
            subdirectory: "Fixtures/profiledata"
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

    func testParseExtensionSalinity() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive>
                        <informationbeforedive>
                            <salinity density="1025.0">salt</salinity>
                        </informationbeforedive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let salinity = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive?.salinity
        XCTAssertNotNil(salinity)
        XCTAssertEqual(salinity?.type, .salt)
        XCTAssertEqual(salinity?.density, 1025.0)

        let roundTrip = try UDDFSerialization.write(document)
        let reparsed = try UDDFSerialization.parse(roundTrip)
        let roundTripSalinity = reparsed.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive?.salinity
        XCTAssertEqual(roundTripSalinity?.type, .salt)
        XCTAssertEqual(roundTripSalinity?.density, 1025.0)
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

    // MARK: - EquipmentUsed Tests

    func testParseEquipmentUsed() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <gasdefinitions>
                <mix id="mix1">
                    <name>Air</name>
                    <o2>0.21</o2>
                </mix>
                <mix id="mix2">
                    <name>EAN32</name>
                    <o2>0.32</o2>
                </mix>
            </gasdefinitions>
            <profiledata>
                <repetitiongroup>
                    <dive id="dive1">
                        <informationbeforedive>
                            <datetime>2025-01-15T14:00:00Z</datetime>
                        </informationbeforedive>
                        <equipmentused>
                            <leadquantity>4.0</leadquantity>
                            <tankdata>
                                <link ref="mix1" />
                                <tankvolume>0.012</tankvolume>
                                <tankpressurebegin>20000000.0</tankpressurebegin>
                                <tankpressureend>5000000.0</tankpressureend>
                            </tankdata>
                            <tankdata>
                                <link ref="mix2" />
                                <tankvolume>0.007</tankvolume>
                                <tankpressurebegin>20000000.0</tankpressurebegin>
                                <tankpressureend>15000000.0</tankpressureend>
                            </tankdata>
                        </equipmentused>
                        <informationafterdive>
                            <greatestdepth>30.0</greatestdepth>
                        </informationafterdive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let dive = document.profiledata?.repetitiongroup?.first?.dive?.first
        XCTAssertNotNil(dive)

        let equipmentUsed = dive?.equipmentused
        XCTAssertNotNil(equipmentUsed)
        XCTAssertEqual(equipmentUsed?.leadquantity, 4.0)

        let tankData = equipmentUsed?.tankdata
        XCTAssertNotNil(tankData)
        XCTAssertEqual(tankData?.count, 2)

        // First tank (Air)
        let tank1 = tankData?[0]
        XCTAssertEqual(tank1?.link?.ref, "mix1")
        XCTAssertEqual(tank1?.tankvolume?.liters ?? 0, 12.0, accuracy: 0.01)
        XCTAssertEqual(tank1?.tankpressurebegin?.bar ?? 0, 200.0, accuracy: 0.01)
        XCTAssertEqual(tank1?.tankpressureend?.bar ?? 0, 50.0, accuracy: 0.01)

        // Second tank (EAN32)
        let tank2 = tankData?[1]
        XCTAssertEqual(tank2?.link?.ref, "mix2")
        XCTAssertEqual(tank2?.tankvolume?.liters ?? 0, 7.0, accuracy: 0.01)
        XCTAssertEqual(tank2?.tankpressurebegin?.bar ?? 0, 200.0, accuracy: 0.01)
        XCTAssertEqual(tank2?.tankpressureend?.bar ?? 0, 150.0, accuracy: 0.01)
    }

    func testRoundTripEquipmentUsed() throws {
        // Create a document with equipment used
        let generator = Generator(name: "TestApp")
        let gasDefs = GasDefinitions(mix: [
            Mix(id: "mix1", name: "Air", o2: 0.21),
            Mix(id: "mix2", name: "EAN32", o2: 0.32)
        ])

        let equipmentUsed = EquipmentUsed(
            leadquantity: 3.5,
            tankdata: [
                TankData(
                    link: Link(ref: "mix1"),
                    tankpressurebegin: Pressure(bar: 200),
                    tankpressureend: Pressure(bar: 60),
                    tankvolume: Volume(liters: 12.0)
                ),
                TankData(
                    link: Link(ref: "mix2"),
                    tankpressurebegin: Pressure(bar: 200),
                    tankpressureend: Pressure(bar: 180),
                    tankvolume: Volume(liters: 11.0)
                )
            ]
        )

        let dive = Dive(
            id: "dive1",
            informationbeforedive: InformationBeforeDive(datetime: Date()),
            equipmentused: equipmentUsed,
            informationafterdive: InformationAfterDive(greatestdepth: Depth(meters: 25))
        )

        let repetitionGroup = RepetitionGroup(dive: [dive])
        let profileData = ProfileData(repetitiongroup: [repetitionGroup])

        var document = UDDFDocument(version: "3.2.1", generator: generator)
        document.gasdefinitions = gasDefs
        document.profiledata = profileData

        // Write and parse back
        let xmlData = try UDDFSerialization.write(document, prettyPrinted: true)
        let reparsed = try UDDFSerialization.parse(xmlData)

        // Verify round-trip
        let reparsedDive = reparsed.profiledata?.repetitiongroup?.first?.dive?.first
        XCTAssertNotNil(reparsedDive?.equipmentused)
        XCTAssertEqual(reparsedDive?.equipmentused?.leadquantity, 3.5)
        XCTAssertEqual(reparsedDive?.equipmentused?.tankdata?.count, 2)

        let reparsedTank1 = reparsedDive?.equipmentused?.tankdata?[0]
        XCTAssertEqual(reparsedTank1?.link?.ref, "mix1")
        XCTAssertEqual(reparsedTank1?.tankvolume?.liters ?? 0, 12.0, accuracy: 0.01)
        XCTAssertEqual(reparsedTank1?.tankpressurebegin?.bar ?? 0, 200.0, accuracy: 0.01)
        XCTAssertEqual(reparsedTank1?.tankpressureend?.bar ?? 0, 60.0, accuracy: 0.01)

        let reparsedTank2 = reparsedDive?.equipmentused?.tankdata?[1]
        XCTAssertEqual(reparsedTank2?.link?.ref, "mix2")
        XCTAssertEqual(reparsedTank2?.tankvolume?.liters ?? 0, 11.0, accuracy: 0.01)
    }

    func testEquipmentUsedWithOnlyLeadQuantity() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive>
                        <equipmentused>
                            <leadquantity>2.5</leadquantity>
                        </equipmentused>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let equipmentUsed = document.profiledata?.repetitiongroup?.first?.dive?.first?.equipmentused
        XCTAssertNotNil(equipmentUsed)
        XCTAssertEqual(equipmentUsed?.leadquantity, 2.5)
        XCTAssertNil(equipmentUsed?.tankdata)
    }

    func testEquipmentUsedWithOnlyTankData() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <gasdefinitions>
                <mix id="air">
                    <name>Air</name>
                    <o2>0.21</o2>
                </mix>
            </gasdefinitions>
            <profiledata>
                <repetitiongroup>
                    <dive>
                        <equipmentused>
                            <tankdata>
                                <link ref="air" />
                                <tankvolume>0.015</tankvolume>
                            </tankdata>
                        </equipmentused>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let equipmentUsed = document.profiledata?.repetitiongroup?.first?.dive?.first?.equipmentused
        XCTAssertNotNil(equipmentUsed)
        XCTAssertNil(equipmentUsed?.leadquantity)
        XCTAssertEqual(equipmentUsed?.tankdata?.count, 1)
        XCTAssertEqual(equipmentUsed?.tankdata?.first?.link?.ref, "air")
        XCTAssertEqual(equipmentUsed?.tankdata?.first?.tankvolume?.liters ?? 0, 15.0, accuracy: 0.01)
    }
}
