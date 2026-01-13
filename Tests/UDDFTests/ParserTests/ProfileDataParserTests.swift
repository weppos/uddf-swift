import XCTest
@testable import UDDF

final class ProfileDataParserTests: XCTestCase {

    // MARK: - Parsing Tests

    func testParseMinimal() throws {
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

    func testParseComplete() throws {
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
            <gasdefinitions>
                <mix id="air">
                    <name>Air</name>
                    <o2>0.21</o2>
                </mix>
            </gasdefinitions>
            <profiledata>
                <repetitiongroup id="rg1">
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
                            <program>recreation</program>
                            <stateofrestbeforedive>rested</stateofrestbeforedive>
                            <tripmembership>trip-2025-01</tripmembership>
                            <equipmentused>
                                <leadquantity>4.0</leadquantity>
                            </equipmentused>
                        </informationbeforedive>
                        <tankdata>
                            <link ref="air" />
                            <tankvolume>0.012</tankvolume>
                            <tankpressurebegin>20000000.0</tankpressurebegin>
                            <tankpressureend>5000000.0</tankpressureend>
                        </tankdata>
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
                            <waypoint>
                                <divetime>1200</divetime>
                                <depth>30.0</depth>
                                <temperature>291.15</temperature>
                            </waypoint>
                        </samples>
                        <informationafterdive>
                            <lowesttemperature>291.15</lowesttemperature>
                            <greatestdepth>30.0</greatestdepth>
                            <averagedepth>18.5</averagedepth>
                            <diveduration>2700</diveduration>
                            <visibility>25.0</visibility>
                            <current>mild-current</current>
                            <diveplan>dive-computer</diveplan>
                            <equipmentmalfunction>none</equipmentmalfunction>
                            <thermalcomfort>comfortable</thermalcomfort>
                            <workload>light</workload>
                            <desaturationtime>43200</desaturationtime>
                            <noflighttime>72000</noflighttime>
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

        XCTAssertNotNil(document.profiledata)
        let dive = document.profiledata?.repetitiongroup?.first?.dive?.first
        XCTAssertNotNil(dive)

        // InformationBeforeDive
        let beforeInfo = dive?.informationbeforedive
        XCTAssertEqual(beforeInfo?.link?.count, 2)
        XCTAssertEqual(beforeInfo?.divenumber, 42)
        XCTAssertEqual(beforeInfo?.internaldivenumber, 123)
        XCTAssertEqual(beforeInfo?.divenumberofday, 2)
        XCTAssertEqual(beforeInfo?.altitude?.meters, 500)
        XCTAssertEqual(beforeInfo?.platform, .charterBoat)
        XCTAssertEqual(beforeInfo?.apparatus, .openScuba)
        XCTAssertEqual(beforeInfo?.program, .recreation)
        XCTAssertEqual(beforeInfo?.stateofrestbeforedive, .rested)
        XCTAssertEqual(beforeInfo?.equipmentused?.leadquantity, 4.0)

        // TankData
        let tankData = dive?.tankdata
        XCTAssertEqual(tankData?.count, 1)
        XCTAssertEqual(tankData?.first?.link?.ref, "air")
        XCTAssertEqual(tankData?.first?.tankvolume?.liters ?? 0, 12.0, accuracy: 0.01)

        // Samples
        let waypoints = dive?.samples?.waypoint
        XCTAssertEqual(waypoints?.count, 3)
        XCTAssertEqual(waypoints?[1].depth?.meters, 10.5)
        XCTAssertEqual(waypoints?[2].depth?.meters, 30.0)

        // InformationAfterDive
        let afterInfo = dive?.informationafterdive
        XCTAssertEqual(afterInfo?.greatestdepth?.meters, 30.0)
        XCTAssertEqual(afterInfo?.averagedepth?.meters, 18.5)
        XCTAssertEqual(afterInfo?.current, .mildCurrent)
        XCTAssertEqual(afterInfo?.diveplan, .diveComputer)
        XCTAssertEqual(afterInfo?.thermalcomfort, .comfortable)
        XCTAssertEqual(afterInfo?.workload, .light)
        XCTAssertEqual(afterInfo?.rating?.ratingvalue, 9)
    }

    // MARK: - Waypoint Tests

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
        XCTAssertEqual(waypoint0?.batterychargecondition, 3.5)
        XCTAssertEqual(waypoint0?.calculatedpo2?.pascals ?? 0, 1.2e5)
        XCTAssertEqual(waypoint0?.depth?.meters, 0)
        XCTAssertEqual(waypoint0?.divemode?.type, .closedCircuit)
        XCTAssertEqual(waypoint0?.divetime?.seconds, 0)
        XCTAssertEqual(waypoint0?.gradientfactor, 0)
        XCTAssertNil(waypoint0?.heading)
        XCTAssertNil(waypoint0?.nodecotime)
        XCTAssertNil(waypoint0?.otu)
        XCTAssertNil(waypoint0?.remainingbottomtime)
        XCTAssertNil(waypoint0?.remainingo2time)
        XCTAssertEqual(waypoint0?.setpo2?.pascals ?? 0, 1.2e5)
        XCTAssertEqual(waypoint0?.switchmix?.ref, "mix1")
        XCTAssertEqual(waypoint0?.tankpressure?.pascals ?? 0, 2.0e7)
        XCTAssertEqual(waypoint0?.temperature?.celsius ?? 0, 20, accuracy: 0.01)

        // Waypoint 1: Shallow with NDL, RBT, setpoint, heart rate, heading
        let waypoint1 = waypoints?[1]
        XCTAssertEqual(waypoint1?.batterychargecondition, 3.48)
        XCTAssertEqual(waypoint1?.depth?.meters, 5.0)
        XCTAssertEqual(waypoint1?.divemode?.type, .closedCircuit)
        XCTAssertEqual(waypoint1?.divetime?.seconds, 60)
        XCTAssertEqual(waypoint1?.gradientfactor, 5)
        XCTAssertEqual(waypoint1?.heading, 90.0)
        XCTAssertEqual(waypoint1?.nodecotime?.seconds, 5940)
        XCTAssertEqual(waypoint1?.otu, 15.5)
        XCTAssertEqual(waypoint1?.remainingbottomtime?.seconds, 1800)
        XCTAssertEqual(waypoint1?.remainingo2time?.seconds, 3300)
        XCTAssertEqual(waypoint1?.setpo2?.pascals ?? 0, 1.2e5)
        XCTAssertEqual(waypoint1?.tankpressure?.pascals ?? 0, 1.95e7)
        XCTAssertEqual(waypoint1?.heartrate, 75)

        // Waypoint 2: Depth with deco stop, CNS, TTS, heading
        let waypoint2 = waypoints?[2]
        XCTAssertEqual(waypoint2?.cns, 8)
        XCTAssertEqual(waypoint2?.decostop?.kind, .mandatory)
        XCTAssertEqual(waypoint2?.decostop?.decodepth, 6)
        XCTAssertEqual(waypoint2?.decostop?.duration, 300)
        XCTAssertEqual(waypoint2?.depth?.meters, 40.0)
        XCTAssertEqual(waypoint2?.divemode?.type, .closedCircuit)
        XCTAssertEqual(waypoint2?.divetime?.seconds, 1200)
        XCTAssertEqual(waypoint2?.gradientfactor, 65)
        XCTAssertEqual(waypoint2?.heading, 180.5)
        XCTAssertEqual(waypoint2?.otu, 42.0)
        XCTAssertEqual(waypoint2?.remainingo2time?.seconds, 2400)
        XCTAssertEqual(waypoint2?.setpo2?.pascals ?? 0, 1.3e5)
        XCTAssertEqual(waypoint2?.tankpressure?.pascals ?? 0, 1.8e7)
        XCTAssertEqual(waypoint2?.tts?.seconds, 600)
        XCTAssertEqual(waypoint2?.heartrate, 80)
    }

    // MARK: - Extension Tests

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

    // MARK: - Unknown Enum Values Tests

    func testParseUnknownEnumValues() throws {
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

    // MARK: - TankData Tests

    func testParseEquipmentUsedAndTankData() throws {
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
                            <equipmentused>
                                <leadquantity>4.0</leadquantity>
                            </equipmentused>
                        </informationbeforedive>
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

        // equipmentused is inside informationbeforedive
        let equipmentUsed = dive?.informationbeforedive?.equipmentused
        XCTAssertNotNil(equipmentUsed)
        XCTAssertEqual(equipmentUsed?.leadquantity, 4.0)

        // tankdata is direct child of dive
        let tankData = dive?.tankdata
        XCTAssertNotNil(tankData)
        XCTAssertEqual(tankData?.count, 2)

        // First tank (Air)
        let tank1 = tankData?[0]
        XCTAssertEqual(tank1?.link?.ref, "mix1")
        XCTAssertEqual(tank1?.tankvolume?.liters ?? 0, 12.0, accuracy: 0.01)
        XCTAssertEqual(tank1?.tankpressurebegin?.pascals ?? 0, 2.0e7)
        XCTAssertEqual(tank1?.tankpressureend?.pascals ?? 0, 5.0e6)

        // Second tank (EAN32)
        let tank2 = tankData?[1]
        XCTAssertEqual(tank2?.link?.ref, "mix2")
        XCTAssertEqual(tank2?.tankvolume?.liters ?? 0, 7.0, accuracy: 0.01)
        XCTAssertEqual(tank2?.tankpressurebegin?.pascals ?? 0, 2.0e7)
        XCTAssertEqual(tank2?.tankpressureend?.pascals ?? 0, 1.5e7)
    }

    // MARK: - Surface Interval Tests

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

    // MARK: - Special Elements Tests

    func testParseAlcoholBeforeDive() throws {
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
                            <alcoholbeforedive>
                                <drink>
                                    <name>Beer</name>
                                    <periodicallytaken>no</periodicallytaken>
                                    <timespanbeforedive>7200</timespanbeforedive>
                                </drink>
                            </alcoholbeforedive>
                        </informationbeforedive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let alcohol = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive?.alcoholbeforedive
        XCTAssertNotNil(alcohol)
        XCTAssertEqual(alcohol?.drink.count, 1)
        XCTAssertEqual(alcohol?.drink.first?.name, "Beer")
        XCTAssertEqual(alcohol?.drink.first?.periodicallytaken, "no")
        XCTAssertEqual(alcohol?.drink.first?.timespanbeforedive?.hours ?? 0, 2, accuracy: 0.01)
    }

    func testParseMedicationBeforeDive() throws {
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
                            <medicationbeforedive>
                                <medicine id="med1">
                                    <name>Aspirin</name>
                                    <periodicallytaken>yes</periodicallytaken>
                                    <timespanbeforedive>3600</timespanbeforedive>
                                </medicine>
                            </medicationbeforedive>
                        </informationbeforedive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let medication = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive?.medicationbeforedive
        XCTAssertNotNil(medication)
        XCTAssertEqual(medication?.medicine.count, 1)
        XCTAssertEqual(medication?.medicine.first?.id, "med1")
        XCTAssertEqual(medication?.medicine.first?.name, "Aspirin")
        XCTAssertEqual(medication?.medicine.first?.periodicallytaken, "yes")
        XCTAssertEqual(medication?.medicine.first?.timespanbeforedive?.hours ?? 0, 1, accuracy: 0.01)
    }

    func testParseNoSuit() throws {
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
                            <nosuit />
                        </informationbeforedive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let nosuit = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive?.nosuit
        XCTAssertNotNil(nosuit)
    }

    func testParsePlannedProfile() throws {
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
                        <informationbeforedive>
                            <plannedprofile startdivemode="opencircuit" startmix="air">
                                <waypoint>
                                    <divetime>0</divetime>
                                    <depth>0</depth>
                                </waypoint>
                                <waypoint>
                                    <divetime>300</divetime>
                                    <depth>20</depth>
                                </waypoint>
                            </plannedprofile>
                        </informationbeforedive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let profile = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive?.plannedprofile
        XCTAssertNotNil(profile)
        XCTAssertEqual(profile?.startdivemode, "opencircuit")
        XCTAssertEqual(profile?.startmix, "air")
        XCTAssertEqual(profile?.waypoint?.count, 2)
        XCTAssertEqual(profile?.waypoint?[1].depth?.meters, 20)
    }

    func testParseDiveTable() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive>
                        <informationafterdive>
                            <diveplan>table</diveplan>
                            <divetable>Buehlmann</divetable>
                        </informationafterdive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let afterInfo = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationafterdive
        XCTAssertEqual(afterInfo?.diveplan, .table)
        XCTAssertEqual(afterInfo?.divetable, .buehlmann)
        XCTAssertEqual(afterInfo?.divetable?.isStandard, true)
    }

    func testParseHyperbaricFacilityTreatment() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive>
                        <informationafterdive>
                            <hyperbaricfacilitytreatment>
                                <dateofrecompressiontreatment>
                                    <datetime>2025-01-15T14:00:00Z</datetime>
                                </dateofrecompressiontreatment>
                                <numberofrecompressiontreatments>2</numberofrecompressiontreatments>
                            </hyperbaricfacilitytreatment>
                        </informationafterdive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let treatment = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationafterdive?.hyperbaricfacilitytreatment
        XCTAssertNotNil(treatment)
        XCTAssertNotNil(treatment?.dateofrecompressiontreatment?.datetime)
        XCTAssertEqual(treatment?.numberofrecompressiontreatments, 2)
    }

    // MARK: - Round Trip Tests

    func testRoundTrip() throws {
        let generator = Generator(name: "TestApp")
        let gasDefs = GasDefinitions(mix: [
            Mix(id: "mix1", name: "Air", o2: 0.21),
            Mix(id: "mix2", name: "EAN32", o2: 0.32)
        ])

        let tankDataArray = [
            TankData(
                link: Link(ref: "mix1"),
                tankvolume: Volume(liters: 12.0),
                tankpressurebegin: Pressure(bar: 200),
                tankpressureend: Pressure(bar: 60)
            ),
            TankData(
                link: Link(ref: "mix2"),
                tankvolume: Volume(liters: 11.0),
                tankpressurebegin: Pressure(bar: 200),
                tankpressureend: Pressure(bar: 180)
            )
        ]

        let informationBeforeDive = InformationBeforeDive(
            link: [Link(ref: "diver1"), Link(ref: "site1")],
            airtemperature: Temperature(celsius: 28),
            alcoholbeforedive: AlcoholBeforeDive(drink: [
                Drink(name: "Wine", periodicallytaken: "no", timespanbeforedive: Duration(hours: 3))
            ]),
            altitude: Altitude(meters: 500),
            apparatus: .openScuba,
            divenumber: 42,
            divenumberofday: 2,
            internaldivenumber: 123,
            equipmentused: EquipmentUsed(leadquantity: 3.5),
            exercisebeforedive: .light,
            medicationbeforedive: MedicationBeforeDive(medicine: [
                Medicine(id: "med1", name: "Vitamin C", periodicallytaken: "yes")
            ]),
            nosuit: NoSuit(),
            platform: .charterBoat,
            program: .recreation,
            stateofrestbeforedive: .rested,
            surfacepressure: Pressure(bar: 0.95),
            tripmembership: "trip-2025"
        )

        let informationAfterDive = InformationAfterDive(
            anysymptoms: "None",
            averagedepth: Depth(meters: 18),
            current: .mildCurrent,
            desaturationtime: Duration(hours: 12),
            diveduration: Duration(minutes: 45),
            diveplan: .diveComputer,
            divetable: .padi,
            equipmentmalfunction: EquipmentMalfunction.none,
            globalalarmsgiven: GlobalAlarmsGiven(globalalarm: ["ascent-warning-too-long"]),
            greatestdepth: Depth(meters: 30),
            highestpo2: Pressure(bar: 1.3),
            hyperbaricfacilitytreatment: HyperbaricFacilityTreatment(
                numberofrecompressiontreatments: 1
            ),
            lowesttemperature: Temperature(celsius: 20),
            noflighttime: Duration(hours: 20),
            observations: "Manta rays",
            pressuredrop: Pressure(bar: 150),
            problems: "Minor mask leak",
            rating: Rating(ratingvalue: 9),
            surfaceintervalafterdive: Duration(hours: 2),
            thermalcomfort: .comfortable,
            visibility: Depth(meters: 25),
            workload: .light
        )

        let dive = Dive(
            id: "dive1",
            informationbeforedive: informationBeforeDive,
            tankdata: tankDataArray,
            informationafterdive: informationAfterDive
        )

        let repetitionGroup = RepetitionGroup(dive: [dive])
        let profileData = ProfileData(repetitiongroup: [repetitionGroup])

        var document = UDDFDocument(version: "3.2.1", generator: generator)
        document.gasdefinitions = gasDefs
        document.profiledata = profileData

        let xmlData = try UDDFSerialization.write(document, prettyPrinted: true)
        let reparsed = try UDDFSerialization.parse(xmlData)

        let reparsedDive = reparsed.profiledata?.repetitiongroup?.first?.dive?.first

        // TankData
        XCTAssertEqual(reparsedDive?.tankdata?.count, 2)
        let reparsedTank1 = reparsedDive?.tankdata?[0]
        XCTAssertEqual(reparsedTank1?.link?.ref, "mix1")
        XCTAssertEqual(reparsedTank1?.tankvolume?.liters ?? 0, 12.0, accuracy: 0.01)

        // InformationBeforeDive
        let reparsedBefore = reparsedDive?.informationbeforedive
        XCTAssertEqual(reparsedBefore?.link?.count, 2)
        XCTAssertEqual(reparsedBefore?.altitude?.meters, 500)
        XCTAssertNotNil(reparsedBefore?.alcoholbeforedive)
        XCTAssertEqual(reparsedBefore?.apparatus, .openScuba)
        XCTAssertEqual(reparsedBefore?.divenumber, 42)

        // InformationAfterDive
        let reparsedAfter = reparsedDive?.informationafterdive
        XCTAssertEqual(reparsedAfter?.anysymptoms, "None")
        XCTAssertEqual(reparsedAfter?.current, .mildCurrent)
        XCTAssertEqual(reparsedAfter?.diveplan, .diveComputer)
        XCTAssertEqual(reparsedAfter?.rating?.ratingvalue, 9)
    }
}
