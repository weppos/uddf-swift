import XCTest
@testable import UDDF

final class GasDefinitionsParserTests: XCTestCase {

    // MARK: - Parsing Tests

    func testParseMinimal() throws {
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
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        XCTAssertNotNil(document.gasdefinitions)
        XCTAssertEqual(document.gasdefinitions?.mix?.count, 1)

        let mix = document.gasdefinitions?.mix?.first
        XCTAssertEqual(mix?.id, "air")
        XCTAssertEqual(mix?.name, "Air")
        XCTAssertEqual(mix?.o2, 0.21)
        XCTAssertNil(mix?.n2)
        XCTAssertNil(mix?.he)
        XCTAssertNil(mix?.ar)
        XCTAssertNil(mix?.h2)
        XCTAssertNil(mix?.usage)
    }

    func testParseComplete() throws {
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
                <mix id="tx1845">
                    <name>Trimix 18/45</name>
                    <o2>0.18</o2>
                    <n2>0.37</n2>
                    <he>0.45</he>
                </mix>
                <mix id="diluent">
                    <name>Air Diluent</name>
                    <o2>0.21</o2>
                    <n2>0.79</n2>
                    <usage>diluent</usage>
                </mix>
                <mix id="o2">
                    <name>Oxygen</name>
                    <o2>1.0</o2>
                    <usage>oxygen</usage>
                </mix>
            </gasdefinitions>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        XCTAssertNotNil(document.gasdefinitions)
        XCTAssertEqual(document.gasdefinitions?.mix?.count, 5)

        // Air
        let airMix = document.gasdefinitions?.mix?.first { $0.id == "air" }
        XCTAssertNotNil(airMix)
        XCTAssertTrue(airMix!.isAir)
        XCTAssertEqual(airMix?.o2, 0.21)
        XCTAssertEqual(airMix?.n2, 0.79)

        // Nitrox
        let nitroxMix = document.gasdefinitions?.mix?.first { $0.id == "ean32" }
        XCTAssertNotNil(nitroxMix)
        XCTAssertTrue(nitroxMix!.isNitrox)
        XCTAssertEqual(nitroxMix?.o2, 0.32)

        // Trimix
        let trimixMix = document.gasdefinitions?.mix?.first { $0.id == "tx1845" }
        XCTAssertNotNil(trimixMix)
        XCTAssertTrue(trimixMix!.isTrimix)
        XCTAssertEqual(trimixMix?.he, 0.45)

        // With usage extension
        let diluentMix = document.gasdefinitions?.mix?.first { $0.id == "diluent" }
        XCTAssertEqual(diluentMix?.usage, .diluent)

        let oxygenMix = document.gasdefinitions?.mix?.first { $0.id == "o2" }
        XCTAssertEqual(oxygenMix?.usage, .oxygen)
    }

    // MARK: - Special cases

    func testParseUnknownGasUsage() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <gasdefinitions>
                <mix id="custom">
                    <name>Custom Gas</name>
                    <o2>0.21</o2>
                    <usage>travel</usage>
                </mix>
            </gasdefinitions>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let customMix = document.gasdefinitions?.mix?.first { $0.id == "custom" }
        XCTAssertEqual(customMix?.usage, .unknown("travel"))
        XCTAssertEqual(customMix?.usage?.rawValue, "travel")
        XCTAssertFalse(customMix?.usage?.isStandard ?? true)
    }
}
