import XCTest
@testable import UDDF

final class ProfileDataSerializationTests: XCTestCase {

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
            exercisebeforedive: .light,
            medicationbeforedive: MedicationBeforeDive(medicine: [
                Medicine(id: "med1", name: "Vitamin C", periodicallytaken: "yes")
            ]),
            nosuit: NoSuit(),
            platform: .charterBoat,
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
            equipmentused: EquipmentUsed(leadquantity: 3.5),
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
            program: .recreation,
            rating: Rating(ratingvalue: 9),
            surfaceintervalafterdive: Duration(hours: 2),
            thermalcomfort: .comfortable,
            visibility: Depth(meters: 25),
            workload: .light
        )

        let dive = Dive(
            id: "dive1",
            informationbeforedive: informationBeforeDive,
            samples: Samples(waypoint: [
                Waypoint(
                    depth: Depth(meters: 6),
                    divetime: Duration(minutes: 5),
                    measuredpo2: [MeasuredPO2(bar: 1.18)],
                    tankpressure: [TankPressure(bar: 200)]
                ),
                Waypoint(
                    depth: Depth(meters: 30),
                    divetime: Duration(minutes: 25),
                    measuredpo2: [
                        MeasuredPO2(bar: 1.2, ref: "sensor-1"),
                        MeasuredPO2(bar: 1.22, ref: "sensor-2")
                    ],
                    tankpressure: [
                        TankPressure(bar: 170, ref: "backgas"),
                        TankPressure(bar: 110, ref: "stage")
                    ]
                )
            ]),
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
        XCTAssertEqual(reparsedTank1?.tankvolume?.cubicMeters ?? 0, 0.012)

        // InformationBeforeDive
        let reparsedBefore = reparsedDive?.informationbeforedive
        XCTAssertEqual(reparsedBefore?.link?.count, 2)
        XCTAssertEqual(reparsedBefore?.altitude?.meters, 500)
        XCTAssertNotNil(reparsedBefore?.alcoholbeforedive)
        XCTAssertEqual(reparsedBefore?.apparatus, .openScuba)
        XCTAssertEqual(reparsedBefore?.divenumber, 42)

        // Samples
        let reparsedWaypoints = reparsedDive?.samples?.waypoint
        XCTAssertEqual(reparsedWaypoints?.count, 2)
        XCTAssertEqual(reparsedWaypoints?[0].measuredpo2, [MeasuredPO2(bar: 1.18)])
        XCTAssertEqual(reparsedWaypoints?[0].tankpressure, [TankPressure(bar: 200)])
        XCTAssertEqual(reparsedWaypoints?[1].measuredpo2, [
            MeasuredPO2(bar: 1.2, ref: "sensor-1"),
            MeasuredPO2(bar: 1.22, ref: "sensor-2")
        ])
        XCTAssertEqual(reparsedWaypoints?[1].tankpressure, [
            TankPressure(bar: 170, ref: "backgas"),
            TankPressure(bar: 110, ref: "stage")
        ])

        // InformationAfterDive
        let reparsedAfter = reparsedDive?.informationafterdive
        XCTAssertEqual(reparsedAfter?.anysymptoms, "None")
        XCTAssertEqual(reparsedAfter?.current, .mildCurrent)
        XCTAssertEqual(reparsedAfter?.diveplan, .diveComputer)
        XCTAssertEqual(reparsedAfter?.rating?.ratingvalue, 9)
        XCTAssertEqual(reparsedAfter?.equipmentused?.leadquantity, 3.5)
        XCTAssertEqual(reparsedAfter?.program, .recreation)

        // Writer emits <equipmentused> and <program> under <informationafterdive>
        // (UDDF 3.2.3 location) — not under <informationbeforedive>.
        let xmlString = String(data: xmlData, encoding: .utf8) ?? ""
        if let beforeStart = xmlString.range(of: "<informationbeforedive>"),
           let beforeEnd = xmlString.range(of: "</informationbeforedive>", range: beforeStart.upperBound..<xmlString.endIndex) {
            let beforeBlock = xmlString[beforeStart.lowerBound..<beforeEnd.upperBound]
            XCTAssertFalse(beforeBlock.contains("<equipmentused>"),
                           "<equipmentused> must not appear inside <informationbeforedive> per UDDF 3.2.3")
            XCTAssertFalse(beforeBlock.contains("<program>"),
                           "<program> must not appear inside <informationbeforedive> per UDDF 3.2.3")
        } else {
            XCTFail("Expected <informationbeforedive> in serialized XML")
        }
    }

    // MARK: - Legacy-location fallback for UDDF \u{2264} 3.2.1 placement

    func testParseLegacyPlacementOfEquipmentUsedAndProgramUnderInformationBeforeDive() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.3">
            <generator>
                <name>LegacyEmitter</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive>
                        <informationbeforedive>
                            <equipmentused>
                                <leadquantity>5.0</leadquantity>
                            </equipmentused>
                            <program>scientific</program>
                        </informationbeforedive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let dive = document.profiledata?.repetitiongroup?.first?.dive?.first

        // Parser re-routes the legacy fields to their UDDF 3.2.3 location.
        XCTAssertEqual(dive?.informationafterdive?.equipmentused?.leadquantity, 5.0)
        XCTAssertEqual(dive?.informationafterdive?.program, .scientific)
    }

    func testLegacyFallbackDoesNotOverwriteExplicitInformationAfterDiveValues() throws {
        // When a file has both the legacy *and* the new location, the new location wins.
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.3">
            <generator>
                <name>MixedEmitter</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive>
                        <informationbeforedive>
                            <program>scientific</program>
                        </informationbeforedive>
                        <informationafterdive>
                            <program>recreation</program>
                        </informationafterdive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let dive = document.profiledata?.repetitiongroup?.first?.dive?.first
        XCTAssertEqual(dive?.informationafterdive?.program, .recreation)
    }
}
