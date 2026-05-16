import XCTest
@testable import UDDF

final class DiveComputerControlParserTests: XCTestCase {

    // MARK: - Parsing Tests

    func testParseMinimal() throws {
        let fixtureURL = Bundle.module.url(
            forResource: "basic",
            withExtension: "uddf",
            subdirectory: "Fixtures/divecomputercontrol"
        )!
        let data = try Data(contentsOf: fixtureURL)
        let document = try UDDFSerialization.parse(data)

        let dcc = document.divecomputercontrol
        XCTAssertNotNil(dcc)
        XCTAssertNotNil(dcc?.setdcdata)
        XCTAssertNotNil(dcc?.setdcdata?.setdcdatetime)

        let expected = ISO8601DateFormatter().date(from: "2025-06-01T08:00:00Z")
        XCTAssertEqual(dcc?.setdcdata?.setdcdatetime?.datetime, expected)
    }

    func testParseComplete() throws {
        let fixtureURL = Bundle.module.url(
            forResource: "full",
            withExtension: "uddf",
            subdirectory: "Fixtures/divecomputercontrol"
        )!
        let data = try Data(contentsOf: fixtureURL)
        let document = try UDDFSerialization.parse(data)

        guard let setdc = document.divecomputercontrol?.setdcdata else {
            XCTFail("Expected setdcdata"); return
        }

        // setdcalarmtime (clock-time alarm)
        XCTAssertEqual(setdc.setdcalarmtime.count, 1)
        XCTAssertEqual(setdc.setdcalarmtime.first?.dcalarm.alarmtype, 1)
        XCTAssertEqual(setdc.setdcalarmtime.first?.dcalarm.period?.seconds, 10.0)

        // setdcaltitude
        XCTAssertEqual(setdc.setdcaltitude?.meters, 1500.0)

        // setdcbuddydata
        XCTAssertEqual(setdc.setdcbuddydata.count, 1)
        XCTAssertEqual(setdc.setdcbuddydata.first?.buddy, "buddy1")

        // setdcdatetime
        let expectedDate = ISO8601DateFormatter().date(from: "2025-06-15T08:00:00Z")
        XCTAssertEqual(setdc.setdcdatetime?.datetime, expectedDate)

        // setdcdecomodel
        XCTAssertEqual(setdc.setdcdecomodel?.name, "Buhlmann ZH-L16C")
        XCTAssertEqual(setdc.setdcdecomodel?.aliasname, ["ZHL-16C", "Buhlmann-C"])

        // setdcdivedepthalarm
        XCTAssertEqual(setdc.setdcdivedepthalarm.count, 1)
        XCTAssertEqual(setdc.setdcdivedepthalarm.first?.dcalarmdepth.meters, 40.0)
        XCTAssertNotNil(setdc.setdcdivedepthalarm.first?.dcalarm.acknowledge)
        XCTAssertEqual(setdc.setdcdivedepthalarm.first?.dcalarm.alarmtype, 2)

        // setdcdivepo2alarm
        XCTAssertEqual(setdc.setdcdivepo2alarm.count, 1)
        XCTAssertEqual(setdc.setdcdivepo2alarm.first?.maximumpo2.pascals, 1.4e5)
        XCTAssertEqual(setdc.setdcdivepo2alarm.first?.dcalarm.alarmtype, 3)
        XCTAssertEqual(setdc.setdcdivepo2alarm.first?.dcalarm.period?.seconds, 5.0)

        // setdcdivesitedata
        XCTAssertEqual(setdc.setdcdivesitedata.count, 1)
        XCTAssertEqual(setdc.setdcdivesitedata.first?.divesite, "site1")

        // setdcdivetimealarm
        XCTAssertEqual(setdc.setdcdivetimealarm.count, 1)
        XCTAssertEqual(setdc.setdcdivetimealarm.first?.timespan.seconds, 2700.0)
        XCTAssertEqual(setdc.setdcdivetimealarm.first?.dcalarm.alarmtype, 4)

        // setdcendndtalarm
        XCTAssertNotNil(setdc.setdcendndtalarm)
        XCTAssertNotNil(setdc.setdcendndtalarm?.dcalarm.acknowledge)
        XCTAssertEqual(setdc.setdcendndtalarm?.dcalarm.alarmtype, 5)

        // setdcgasdefinitionsdata — UDDF 3.2.2 selective-gas form
        XCTAssertNil(setdc.setdcgasdefinitionsdata?.setdcallgasdefinitions)
        XCTAssertEqual(setdc.setdcgasdefinitionsdata?.setdcgasdata.count, 2)
        XCTAssertEqual(setdc.setdcgasdefinitionsdata?.setdcgasdata.first?.ref, "air")
        XCTAssertEqual(setdc.setdcgasdefinitionsdata?.setdcgasdata.last?.ref, "ean32")

        // setdcownerdata (empty marker)
        XCTAssertNotNil(setdc.setdcownerdata)

        // setdcpassword
        XCTAssertEqual(setdc.setdcpassword, "1234")

        // setdcgeneratordata (empty marker)
        XCTAssertNotNil(setdc.setdcgeneratordata)
    }

    // UDDF 3.2.2 alternative form: <setdcallgasdefinitions/> instead of selective gas list.
    func testParseAllGasDefinitionsMarker() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.3">
            <generator>
                <name>DCApp</name>
            </generator>
            <divecomputercontrol>
                <setdcdata>
                    <setdcgasdefinitionsdata>
                        <setdcallgasdefinitions/>
                    </setdcgasdefinitionsdata>
                </setdcdata>
            </divecomputercontrol>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let gasDefs = document.divecomputercontrol?.setdcdata?.setdcgasdefinitionsdata
        XCTAssertNotNil(gasDefs?.setdcallgasdefinitions)
        XCTAssertEqual(gasDefs?.setdcgasdata, [])
    }
}
