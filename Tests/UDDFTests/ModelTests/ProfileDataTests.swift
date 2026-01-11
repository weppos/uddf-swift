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

    // MARK: - InformationBeforeDive Extended Fields

    func testParseInformationBeforeDiveExtendedFields() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <diver>
                <owner id="diver1">
                    <personal>
                        <firstname>John</firstname>
                        <lastname>Doe</lastname>
                    </personal>
                </owner>
            </diver>
            <divesite>
                <site id="site1">
                    <name>Great Barrier Reef</name>
                </site>
            </divesite>
            <profiledata>
                <repetitiongroup>
                    <dive id="dive1">
                        <informationbeforedive>
                            <link ref="diver1" />
                            <link ref="site1" />
                            <datetime>2025-01-15T09:00:00Z</datetime>
                            <divenumber>42</divenumber>
                            <internaldivenumber>123</internaldivenumber>
                            <divenumberofday>2</divenumberofday>
                            <airtemperature>301.15</airtemperature>
                            <altitude>500</altitude>
                            <surfacepressure>95000</surfacepressure>
                            <platform>charter-boat</platform>
                            <apparatus>open-scuba</apparatus>
                            <purpose>sightseeing</purpose>
                            <stateofrestbeforedive>rested</stateofrestbeforedive>
                            <tripmembership>trip-2025-01</tripmembership>
                        </informationbeforedive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let info = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive
        XCTAssertNotNil(info)

        // Links
        XCTAssertEqual(info?.link?.count, 2)
        XCTAssertEqual(info?.link?[0].ref, "diver1")
        XCTAssertEqual(info?.link?[1].ref, "site1")

        // Dive numbers
        XCTAssertEqual(info?.divenumber, 42)
        XCTAssertEqual(info?.internaldivenumber, 123)
        XCTAssertEqual(info?.divenumberofday, 2)

        // Environment
        XCTAssertEqual(info?.airtemperature?.kelvin ?? 0, 301.15, accuracy: 0.01)
        XCTAssertEqual(info?.airtemperature?.celsius ?? 0, 28, accuracy: 0.01)
        XCTAssertEqual(info?.altitude?.meters, 500)
        XCTAssertEqual(info?.surfacepressure?.pascals, 95000)
        XCTAssertEqual(info?.surfacepressure?.bar ?? 0, 0.95, accuracy: 0.01)

        // Enumerations
        XCTAssertEqual(info?.platform, .charterBoat)
        XCTAssertEqual(info?.apparatus, .openScuba)
        XCTAssertEqual(info?.purpose, .sightseeing)
        XCTAssertEqual(info?.stateofrestbeforedive, .rested)

        // Other
        XCTAssertEqual(info?.tripmembership, "trip-2025-01")
    }

    func testParseSurfaceIntervalBeforeDive() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive id="dive1">
                        <informationbeforedive>
                            <surfaceintervalbeforedive>
                                <passedtime>5400</passedtime>
                            </surfaceintervalbeforedive>
                        </informationbeforedive>
                    </dive>
                    <dive id="dive2">
                        <informationbeforedive>
                            <surfaceintervalbeforedive>
                                <infinity />
                            </surfaceintervalbeforedive>
                        </informationbeforedive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let dives = document.profiledata?.repetitiongroup?.first?.dive
        XCTAssertEqual(dives?.count, 2)

        // First dive with passedtime
        let interval1 = dives?[0].informationbeforedive?.surfaceintervalbeforedive
        XCTAssertNotNil(interval1)
        XCTAssertEqual(interval1?.passedtime?.seconds, 5400)
        XCTAssertEqual(interval1?.passedtime?.minutes ?? 0, 90, accuracy: 0.01)
        XCTAssertNil(interval1?.infinity)

        // Second dive with infinity
        let interval2 = dives?[1].informationbeforedive?.surfaceintervalbeforedive
        XCTAssertNotNil(interval2)
        XCTAssertNil(interval2?.passedtime)
        XCTAssertEqual(interval2?.infinity, true)
    }

    // MARK: - InformationAfterDive Extended Fields

    func testParseInformationAfterDiveExtendedFields() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive id="dive1">
                        <informationafterdive>
                            <lowesttemperature>293.15</lowesttemperature>
                            <greatestdepth>30.0</greatestdepth>
                            <averagedepth>18.5</averagedepth>
                            <diveduration>2700</diveduration>
                            <visibility>25.0</visibility>
                            <current>mild-current</current>
                            <diveplan>dive-computer</diveplan>
                            <equipmentmalfunction>none</equipmentmalfunction>
                            <pressuredrop>15000000</pressuredrop>
                            <problems>Minor mask leak</problems>
                            <program>recreation</program>
                            <thermalcomfort>comfortable</thermalcomfort>
                            <workload>light</workload>
                            <desaturationtime>43200</desaturationtime>
                            <noflighttime>72000</noflighttime>
                            <surfaceintervalafterdive>7200</surfaceintervalafterdive>
                            <highestpo2>130000</highestpo2>
                            <anysymptoms>None</anysymptoms>
                            <globalalarmsgiven>Low tank warning</globalalarmsgiven>
                            <observations>Manta rays, sea turtles</observations>
                            <rating>
                                <ratingvalue>9</ratingvalue>
                            </rating>
                        </informationafterdive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let info = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationafterdive
        XCTAssertNotNil(info)

        // Core measurements
        XCTAssertEqual(info?.lowesttemperature?.celsius ?? 0, 20, accuracy: 0.01)
        XCTAssertEqual(info?.greatestdepth?.meters, 30.0)
        XCTAssertEqual(info?.averagedepth?.meters, 18.5)
        XCTAssertEqual(info?.diveduration?.minutes ?? 0, 45, accuracy: 0.01)

        // Extended measurements
        XCTAssertEqual(info?.visibility?.meters, 25.0)
        XCTAssertEqual(info?.pressuredrop?.pascals, 15000000)
        XCTAssertEqual(info?.pressuredrop?.bar ?? 0, 150, accuracy: 0.01)
        XCTAssertEqual(info?.highestpo2?.pascals, 130000)
        XCTAssertEqual(info?.highestpo2?.bar ?? 0, 1.3, accuracy: 0.01)

        // Time-based fields
        XCTAssertEqual(info?.desaturationtime?.seconds, 43200)
        XCTAssertEqual(info?.desaturationtime?.hours ?? 0, 12, accuracy: 0.01)
        XCTAssertEqual(info?.noflighttime?.seconds, 72000)
        XCTAssertEqual(info?.noflighttime?.hours ?? 0, 20, accuracy: 0.01)
        XCTAssertEqual(info?.surfaceintervalafterdive?.seconds, 7200)
        XCTAssertEqual(info?.surfaceintervalafterdive?.hours ?? 0, 2, accuracy: 0.01)

        // Enumerations
        XCTAssertEqual(info?.current, .mildCurrent)
        XCTAssertEqual(info?.diveplan, .diveComputer)
        XCTAssertEqual(info?.equipmentmalfunction, EquipmentMalfunction.none)
        XCTAssertEqual(info?.program, .recreation)
        XCTAssertEqual(info?.thermalcomfort, .comfortable)
        XCTAssertEqual(info?.workload, .light)

        // Text fields
        XCTAssertEqual(info?.problems, "Minor mask leak")
        XCTAssertEqual(info?.anysymptoms, "None")
        XCTAssertEqual(info?.globalalarmsgiven, "Low tank warning")
        XCTAssertEqual(info?.observations, "Manta rays, sea turtles")

        // Rating
        XCTAssertEqual(info?.rating?.ratingvalue, 9)
    }

    // MARK: - Dive Enumeration Tests

    func testPlatformEnumValues() {
        // Test standard values
        XCTAssertEqual(Platform(rawValue: "beach-shore"), .beachShore)
        XCTAssertEqual(Platform(rawValue: "pier"), .pier)
        XCTAssertEqual(Platform(rawValue: "small-boat"), .smallBoat)
        XCTAssertEqual(Platform(rawValue: "charter-boat"), .charterBoat)
        XCTAssertEqual(Platform(rawValue: "live-aboard"), .liveAboard)
        XCTAssertEqual(Platform(rawValue: "barge"), .barge)
        XCTAssertEqual(Platform(rawValue: "landside"), .landside)
        XCTAssertEqual(Platform(rawValue: "hyperbaric-facility"), .hyperbaricFacility)
        XCTAssertEqual(Platform(rawValue: "other"), .other)

        // Test unknown value
        let unknown = Platform(rawValue: "submarine")
        XCTAssertEqual(unknown.rawValue, "submarine")
        XCTAssertEqual(unknown.isStandard, false)
    }

    func testApparatusEnumValues() {
        XCTAssertEqual(Apparatus(rawValue: "open-scuba"), .openScuba)
        XCTAssertEqual(Apparatus(rawValue: "rebreather"), .rebreather)
        XCTAssertEqual(Apparatus(rawValue: "surface-supplied"), .surfaceSupplied)
        XCTAssertEqual(Apparatus(rawValue: "chamber"), .chamber)
        XCTAssertEqual(Apparatus(rawValue: "experimental"), .experimental)
        XCTAssertEqual(Apparatus(rawValue: "other"), .other)

        let unknown = Apparatus(rawValue: "freediving")
        XCTAssertEqual(unknown.isStandard, false)
    }

    func testPurposeEnumValues() {
        XCTAssertEqual(Purpose(rawValue: "sightseeing"), .sightseeing)
        XCTAssertEqual(Purpose(rawValue: "learning"), .learning)
        XCTAssertEqual(Purpose(rawValue: "teaching"), .teaching)
        XCTAssertEqual(Purpose(rawValue: "research"), .research)
        XCTAssertEqual(Purpose(rawValue: "photography-videography"), .photographyVideography)
        XCTAssertEqual(Purpose(rawValue: "spearfishing"), .spearfishing)
        XCTAssertEqual(Purpose(rawValue: "proficiency"), .proficiency)
        XCTAssertEqual(Purpose(rawValue: "work"), .work)
        XCTAssertEqual(Purpose(rawValue: "other"), .other)

        let unknown = Purpose(rawValue: "treasure-hunting")
        XCTAssertEqual(unknown.isStandard, false)
    }

    func testCurrentEnumValues() {
        XCTAssertEqual(Current(rawValue: "no-current"), .noCurrent)
        XCTAssertEqual(Current(rawValue: "very-mild-current"), .veryMildCurrent)
        XCTAssertEqual(Current(rawValue: "mild-current"), .mildCurrent)
        XCTAssertEqual(Current(rawValue: "moderate-current"), .moderateCurrent)
        XCTAssertEqual(Current(rawValue: "hard-current"), .hardCurrent)
        XCTAssertEqual(Current(rawValue: "very-hard-current"), .veryHardCurrent)

        let unknown = Current(rawValue: "ripping")
        XCTAssertEqual(unknown.isStandard, false)
    }

    func testDivePlanEnumValues() {
        XCTAssertEqual(DivePlan(rawValue: "none"), DivePlan.none)
        XCTAssertEqual(DivePlan(rawValue: "table"), .table)
        XCTAssertEqual(DivePlan(rawValue: "dive-computer"), .diveComputer)
        XCTAssertEqual(DivePlan(rawValue: "another-diver"), .anotherDiver)

        let unknown = DivePlan(rawValue: "gut-feeling")
        XCTAssertEqual(unknown.isStandard, false)
    }

    func testThermalComfortEnumValues() {
        XCTAssertEqual(ThermalComfort(rawValue: "not-indicated"), .notIndicated)
        XCTAssertEqual(ThermalComfort(rawValue: "comfortable"), .comfortable)
        XCTAssertEqual(ThermalComfort(rawValue: "cold"), .cold)
        XCTAssertEqual(ThermalComfort(rawValue: "very-cold"), .veryCold)
        XCTAssertEqual(ThermalComfort(rawValue: "hot"), .hot)

        let unknown = ThermalComfort(rawValue: "freezing")
        XCTAssertEqual(unknown.isStandard, false)
    }

    func testWorkloadEnumValues() {
        XCTAssertEqual(Workload(rawValue: "not-specified"), .notSpecified)
        XCTAssertEqual(Workload(rawValue: "resting"), .resting)
        XCTAssertEqual(Workload(rawValue: "light"), .light)
        XCTAssertEqual(Workload(rawValue: "moderate"), .moderate)
        XCTAssertEqual(Workload(rawValue: "severe"), .severe)
        XCTAssertEqual(Workload(rawValue: "exhausting"), .exhausting)

        let unknown = Workload(rawValue: "extreme")
        XCTAssertEqual(unknown.isStandard, false)
    }

    func testEquipmentMalfunctionEnumValues() {
        XCTAssertEqual(EquipmentMalfunction(rawValue: "none"), EquipmentMalfunction.none)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "face-mask"), .faceMask)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "fins"), .fins)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "weight-belt"), .weightBelt)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "buoyancy-control-device"), .buoyancyControlDevice)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "thermal-protection"), .thermalProtection)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "dive-computer"), .diveComputer)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "depth-gauge"), .depthGauge)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "pressure-gauge"), .pressureGauge)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "breathing-apparatus"), .breathingApparatus)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "deco-reel"), .decoReel)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "other"), .other)

        let unknown = EquipmentMalfunction(rawValue: "torch")
        XCTAssertEqual(unknown.isStandard, false)
    }

    func testProgramEnumValues() {
        XCTAssertEqual(Program(rawValue: "recreation"), .recreation)
        XCTAssertEqual(Program(rawValue: "training"), .training)
        XCTAssertEqual(Program(rawValue: "scientific"), .scientific)
        XCTAssertEqual(Program(rawValue: "medical"), .medical)
        XCTAssertEqual(Program(rawValue: "commercial"), .commercial)
        XCTAssertEqual(Program(rawValue: "military"), .military)
        XCTAssertEqual(Program(rawValue: "competitive"), .competitive)
        XCTAssertEqual(Program(rawValue: "other"), .other)

        let unknown = Program(rawValue: "expedition")
        XCTAssertEqual(unknown.isStandard, false)
    }

    func testStateOfRestBeforeDiveEnumValues() {
        XCTAssertEqual(StateOfRestBeforeDive(rawValue: "not-specified"), .notSpecified)
        XCTAssertEqual(StateOfRestBeforeDive(rawValue: "rested"), .rested)
        XCTAssertEqual(StateOfRestBeforeDive(rawValue: "tired"), .tired)
        XCTAssertEqual(StateOfRestBeforeDive(rawValue: "exhausted"), .exhausted)

        let unknown = StateOfRestBeforeDive(rawValue: "sleepy")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - Round-trip Tests

    func testRoundTripInformationBeforeDiveExtended() throws {
        let generator = Generator(name: "TestApp")

        let info = InformationBeforeDive(
            link: [Link(ref: "diver1"), Link(ref: "site1")],
            divenumber: 42,
            internaldivenumber: 123,
            divenumberofday: 2,
            airtemperature: Temperature(celsius: 28),
            altitude: Altitude(meters: 500),
            surfacepressure: Pressure(bar: 0.95),
            platform: .charterBoat,
            apparatus: .openScuba,
            purpose: .sightseeing,
            stateofrestbeforedive: .rested,
            tripmembership: "trip-2025"
        )

        let dive = Dive(id: "dive1", informationbeforedive: info)
        let repetitionGroup = RepetitionGroup(dive: [dive])
        let profileData = ProfileData(repetitiongroup: [repetitionGroup])

        var document = UDDFDocument(version: "3.2.1", generator: generator)
        document.profiledata = profileData

        let xmlData = try UDDFSerialization.write(document, prettyPrinted: true)
        let reparsed = try UDDFSerialization.parse(xmlData)

        let reparsedInfo = reparsed.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive
        XCTAssertNotNil(reparsedInfo)

        XCTAssertEqual(reparsedInfo?.link?.count, 2)
        XCTAssertEqual(reparsedInfo?.divenumber, 42)
        XCTAssertEqual(reparsedInfo?.internaldivenumber, 123)
        XCTAssertEqual(reparsedInfo?.divenumberofday, 2)
        XCTAssertEqual(reparsedInfo?.altitude?.meters, 500)
        XCTAssertEqual(reparsedInfo?.platform, .charterBoat)
        XCTAssertEqual(reparsedInfo?.apparatus, .openScuba)
        XCTAssertEqual(reparsedInfo?.purpose, .sightseeing)
        XCTAssertEqual(reparsedInfo?.stateofrestbeforedive, .rested)
        XCTAssertEqual(reparsedInfo?.tripmembership, "trip-2025")
    }

    func testRoundTripInformationAfterDiveExtended() throws {
        let generator = Generator(name: "TestApp")

        let info = InformationAfterDive(
            lowesttemperature: Temperature(celsius: 20),
            greatestdepth: Depth(meters: 30),
            averagedepth: Depth(meters: 18),
            diveduration: Duration(minutes: 45),
            visibility: Depth(meters: 25),
            current: .mildCurrent,
            diveplan: .diveComputer,
            equipmentmalfunction: EquipmentMalfunction.none,
            pressuredrop: Pressure(bar: 150),
            problems: "Minor mask leak",
            program: .recreation,
            thermalcomfort: .comfortable,
            workload: .light,
            desaturationtime: Duration(hours: 12),
            noflighttime: Duration(hours: 20),
            surfaceintervalafterdive: Duration(hours: 2),
            highestpo2: Pressure(bar: 1.3),
            anysymptoms: "None",
            globalalarmsgiven: "Low tank warning",
            observations: "Manta rays",
            rating: Rating(ratingvalue: 9)
        )

        let dive = Dive(id: "dive1", informationafterdive: info)
        let repetitionGroup = RepetitionGroup(dive: [dive])
        let profileData = ProfileData(repetitiongroup: [repetitionGroup])

        var document = UDDFDocument(version: "3.2.1", generator: generator)
        document.profiledata = profileData

        let xmlData = try UDDFSerialization.write(document, prettyPrinted: true)
        let reparsed = try UDDFSerialization.parse(xmlData)

        let reparsedInfo = reparsed.profiledata?.repetitiongroup?.first?.dive?.first?.informationafterdive
        XCTAssertNotNil(reparsedInfo)

        XCTAssertEqual(reparsedInfo?.visibility?.meters, 25)
        XCTAssertEqual(reparsedInfo?.current, .mildCurrent)
        XCTAssertEqual(reparsedInfo?.diveplan, .diveComputer)
        XCTAssertEqual(reparsedInfo?.equipmentmalfunction, EquipmentMalfunction.none)
        XCTAssertEqual(reparsedInfo?.pressuredrop?.bar ?? 0, 150, accuracy: 0.01)
        XCTAssertEqual(reparsedInfo?.problems, "Minor mask leak")
        XCTAssertEqual(reparsedInfo?.program, .recreation)
        XCTAssertEqual(reparsedInfo?.thermalcomfort, .comfortable)
        XCTAssertEqual(reparsedInfo?.workload, .light)
        XCTAssertEqual(reparsedInfo?.desaturationtime?.hours ?? 0, 12, accuracy: 0.01)
        XCTAssertEqual(reparsedInfo?.noflighttime?.hours ?? 0, 20, accuracy: 0.01)
        XCTAssertEqual(reparsedInfo?.surfaceintervalafterdive?.hours ?? 0, 2, accuracy: 0.01)
        XCTAssertEqual(reparsedInfo?.highestpo2?.bar ?? 0, 1.3, accuracy: 0.01)
        XCTAssertEqual(reparsedInfo?.anysymptoms, "None")
        XCTAssertEqual(reparsedInfo?.globalalarmsgiven, "Low tank warning")
        XCTAssertEqual(reparsedInfo?.observations, "Manta rays")
        XCTAssertEqual(reparsedInfo?.rating?.ratingvalue, 9)
    }

    func testUnknownEnumValuesRoundTrip() throws {
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
                            <platform>submarine</platform>
                            <apparatus>jetpack</apparatus>
                            <purpose>exploration</purpose>
                        </informationbeforedive>
                        <informationafterdive>
                            <current>extreme-current</current>
                            <thermalcomfort>freezing</thermalcomfort>
                            <workload>extreme</workload>
                        </informationafterdive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        // Verify unknown values are parsed
        let beforeInfo = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive
        XCTAssertEqual(beforeInfo?.platform?.rawValue, "submarine")
        XCTAssertEqual(beforeInfo?.platform?.isStandard, false)
        XCTAssertEqual(beforeInfo?.apparatus?.rawValue, "jetpack")
        XCTAssertEqual(beforeInfo?.purpose?.rawValue, "exploration")

        let afterInfo = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationafterdive
        XCTAssertEqual(afterInfo?.current?.rawValue, "extreme-current")
        XCTAssertEqual(afterInfo?.current?.isStandard, false)
        XCTAssertEqual(afterInfo?.thermalcomfort?.rawValue, "freezing")
        XCTAssertEqual(afterInfo?.workload?.rawValue, "extreme")

        // Round-trip and verify preservation
        let xmlData = try UDDFSerialization.write(document, prettyPrinted: true)
        let reparsed = try UDDFSerialization.parse(xmlData)

        let reparsedBefore = reparsed.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive
        XCTAssertEqual(reparsedBefore?.platform?.rawValue, "submarine")
        XCTAssertEqual(reparsedBefore?.apparatus?.rawValue, "jetpack")
        XCTAssertEqual(reparsedBefore?.purpose?.rawValue, "exploration")

        let reparsedAfter = reparsed.profiledata?.repetitiongroup?.first?.dive?.first?.informationafterdive
        XCTAssertEqual(reparsedAfter?.current?.rawValue, "extreme-current")
        XCTAssertEqual(reparsedAfter?.thermalcomfort?.rawValue, "freezing")
        XCTAssertEqual(reparsedAfter?.workload?.rawValue, "extreme")
    }
}
