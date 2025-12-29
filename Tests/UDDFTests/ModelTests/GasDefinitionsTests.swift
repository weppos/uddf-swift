import XCTest
@testable import UDDF

final class GasDefinitionsTests: XCTestCase {
    func testAirMix() {
        let air = Mix(id: "air", name: "Air", o2: 0.21, n2: 0.79)

        XCTAssertTrue(air.isAir)
        XCTAssertFalse(air.isNitrox)
        XCTAssertFalse(air.isTrimix)
        XCTAssertEqual(air.oxygenPercentage, 21.0)
    }

    func testNitroxMix() {
        let nitrox = Mix(id: "ean32", name: "EAN32", o2: 0.32, n2: 0.68)

        XCTAssertFalse(nitrox.isAir)
        XCTAssertTrue(nitrox.isNitrox)
        XCTAssertFalse(nitrox.isTrimix)
        XCTAssertEqual(nitrox.oxygenPercentage, 32.0)
    }

    func testTrimixMix() {
        let trimix = Mix(id: "tx1845", name: "Trimix 18/45", o2: 0.18, n2: 0.37, he: 0.45)

        XCTAssertFalse(trimix.isAir)
        XCTAssertFalse(trimix.isNitrox)
        XCTAssertTrue(trimix.isTrimix)
    }

    func testParseGasDefinitions() throws {
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
                    <n2>0.79</n2>
                </mix>
                <mix id="ean32">
                    <name>EAN32</name>
                    <o2>0.32</o2>
                    <n2>0.68</n2>
                </mix>
            </gasdefinitions>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        XCTAssertNotNil(document.gasdefinitions)
        XCTAssertEqual(document.gasdefinitions?.mix?.count, 2)

        let airMix = document.gasdefinitions?.mix?.first { $0.id == "air" }
        XCTAssertNotNil(airMix)
        XCTAssertTrue(airMix!.isAir)

        let nitroxMix = document.gasdefinitions?.mix?.first { $0.id == "ean32" }
        XCTAssertNotNil(nitroxMix)
        XCTAssertTrue(nitroxMix!.isNitrox)
    }
}
