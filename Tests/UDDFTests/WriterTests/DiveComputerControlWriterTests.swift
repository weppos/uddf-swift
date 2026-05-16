import XCTest
@testable import UDDF

final class DiveComputerControlWriterTests: XCTestCase {

    func testWriteMinimalRoundTrip() throws {
        let datetime = ISO8601DateFormatter().date(from: "2025-06-01T08:00:00Z")!
        var document = UDDFDocument(version: "3.2.3", generator: Generator(name: "DCApp"))
        document.divecomputercontrol = DiveComputerControl(
            setdcdata: SetDCData(setdcdatetime: SetDCDateTime(datetime: datetime))
        )

        let xmlData = try UDDFSerialization.write(document, prettyPrinted: true)
        let xmlString = String(data: xmlData, encoding: .utf8) ?? ""

        XCTAssertTrue(xmlString.contains("<divecomputercontrol>"), "expected <divecomputercontrol> element")
        XCTAssertTrue(xmlString.contains("<setdcdata>"), "expected <setdcdata> element")
        XCTAssertTrue(xmlString.contains("<setdcdatetime>"), "expected <setdcdatetime> element")

        let reparsed = try UDDFSerialization.parse(xmlData)
        XCTAssertEqual(reparsed.divecomputercontrol?.setdcdata?.setdcdatetime?.datetime, datetime)
    }

    func testWriteAllGasDefinitionsRoundTrip() throws {
        var document = UDDFDocument(version: "3.2.3", generator: Generator(name: "DCApp"))
        document.divecomputercontrol = DiveComputerControl(
            setdcdata: SetDCData(
                setdcgasdefinitionsdata: SetDCGasDefinitionsData(
                    setdcallgasdefinitions: SetDCAllGasDefinitions()
                )
            )
        )

        let xmlData = try UDDFSerialization.write(document, prettyPrinted: true)
        let xmlString = String(data: xmlData, encoding: .utf8) ?? ""
        XCTAssertTrue(xmlString.contains("<setdcallgasdefinitions"),
                      "expected <setdcallgasdefinitions/> marker in output")

        let reparsed = try UDDFSerialization.parse(xmlData)
        XCTAssertNotNil(reparsed.divecomputercontrol?.setdcdata?.setdcgasdefinitionsdata?.setdcallgasdefinitions)
    }

    func testWriteSelectiveGasDataRoundTrip() throws {
        var document = UDDFDocument(version: "3.2.3", generator: Generator(name: "DCApp"))
        document.divecomputercontrol = DiveComputerControl(
            setdcdata: SetDCData(
                setdcgasdefinitionsdata: SetDCGasDefinitionsData(
                    setdcgasdata: [
                        SetDCGasData(ref: "air"),
                        SetDCGasData(ref: "ean32")
                    ]
                )
            )
        )

        let xmlData = try UDDFSerialization.write(document, prettyPrinted: true)
        let xmlString = String(data: xmlData, encoding: .utf8) ?? ""
        XCTAssertTrue(xmlString.contains("ref=\"air\""), "expected ref=\"air\" attribute")
        XCTAssertTrue(xmlString.contains("ref=\"ean32\""), "expected ref=\"ean32\" attribute")

        let reparsed = try UDDFSerialization.parse(xmlData)
        let gasData = reparsed.divecomputercontrol?.setdcdata?.setdcgasdefinitionsdata?.setdcgasdata
        XCTAssertEqual(gasData?.count, 2)
        XCTAssertEqual(gasData?.first?.ref, "air")
        XCTAssertEqual(gasData?.last?.ref, "ean32")
    }

    func testWriteAlarmsRoundTrip() throws {
        var document = UDDFDocument(version: "3.2.3", generator: Generator(name: "DCApp"))
        document.divecomputercontrol = DiveComputerControl(
            setdcdata: SetDCData(
                setdcdivedepthalarm: [
                    SetDCDiveDepthAlarm(
                        dcalarmdepth: Depth(meters: 40.0),
                        dcalarm: DCAlarm(acknowledge: Acknowledge(), alarmtype: 2)
                    )
                ],
                setdcdivetimealarm: [
                    SetDCDiveTimeAlarm(
                        dcalarm: DCAlarm(alarmtype: 4, period: Duration(seconds: 15)),
                        timespan: Duration(seconds: 2700)
                    )
                ]
            )
        )

        let xmlData = try UDDFSerialization.write(document, prettyPrinted: true)
        let reparsed = try UDDFSerialization.parse(xmlData)

        let setdc = reparsed.divecomputercontrol?.setdcdata
        XCTAssertEqual(setdc?.setdcdivedepthalarm.first?.dcalarmdepth.meters, 40.0)
        XCTAssertNotNil(setdc?.setdcdivedepthalarm.first?.dcalarm.acknowledge)
        XCTAssertEqual(setdc?.setdcdivetimealarm.first?.timespan.seconds, 2700.0)
        XCTAssertEqual(setdc?.setdcdivetimealarm.first?.dcalarm.period?.seconds, 15.0)
    }
}
