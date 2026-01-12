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

    // MARK: - GasUsage Extension Tests

    func testGasUsageRawValues() {
        XCTAssertEqual(GasUsage.bottom.rawValue, "bottom")
        XCTAssertEqual(GasUsage.deco.rawValue, "deco")
        XCTAssertEqual(GasUsage.sidemount.rawValue, "sidemount")
        XCTAssertEqual(GasUsage.bailout.rawValue, "bailout")
        XCTAssertEqual(GasUsage.diluent.rawValue, "diluent")
        XCTAssertEqual(GasUsage.oxygen.rawValue, "oxygen")
        XCTAssertEqual(GasUsage.unknown("custom").rawValue, "custom")
    }

    func testGasUsageInitFromRawValue() {
        XCTAssertEqual(GasUsage(rawValue: "bottom"), .bottom)
        XCTAssertEqual(GasUsage(rawValue: "deco"), .deco)
        XCTAssertEqual(GasUsage(rawValue: "sidemount"), .sidemount)
        XCTAssertEqual(GasUsage(rawValue: "bailout"), .bailout)
        XCTAssertEqual(GasUsage(rawValue: "diluent"), .diluent)
        XCTAssertEqual(GasUsage(rawValue: "oxygen"), .oxygen)
        XCTAssertEqual(GasUsage(rawValue: "custom"), .unknown("custom"))
    }

    func testGasUsageIsStandard() {
        XCTAssertTrue(GasUsage.bottom.isStandard)
        XCTAssertTrue(GasUsage.deco.isStandard)
        XCTAssertTrue(GasUsage.sidemount.isStandard)
        XCTAssertTrue(GasUsage.bailout.isStandard)
        XCTAssertTrue(GasUsage.diluent.isStandard)
        XCTAssertTrue(GasUsage.oxygen.isStandard)
        XCTAssertFalse(GasUsage.unknown("custom").isStandard)
    }

    func testMixWithUsage() {
        let oxygenMix = Mix(id: "o2", name: "Oxygen", o2: 1.0, usage: .oxygen)
        XCTAssertEqual(oxygenMix.usage, .oxygen)

        let diluentMix = Mix(id: "diluent", name: "Air Diluent", o2: 0.21, n2: 0.79, usage: .diluent)
        XCTAssertEqual(diluentMix.usage, .diluent)

        let sidemountMix = Mix(id: "sm1", name: "EAN32", o2: 0.32, usage: .sidemount)
        XCTAssertEqual(sidemountMix.usage, .sidemount)

        let bottomMix = Mix(id: "back", name: "Air", o2: 0.21, usage: .bottom)
        XCTAssertEqual(bottomMix.usage, .bottom)

        let decoMix = Mix(id: "deco", name: "EAN50", o2: 0.50, usage: .deco)
        XCTAssertEqual(decoMix.usage, .deco)

        let bailoutMix = Mix(id: "bailout", name: "EAN32", o2: 0.32, usage: .bailout)
        XCTAssertEqual(bailoutMix.usage, .bailout)
    }

    func testParseGasUsageExtension() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <gasdefinitions>
                <mix id="diluent">
                    <name>Air Diluent</name>
                    <o2>0.21</o2>
                    <usage>diluent</usage>
                </mix>
                <mix id="o2">
                    <name>Oxygen</name>
                    <o2>1.0</o2>
                    <usage>oxygen</usage>
                </mix>
                <mix id="bailout">
                    <name>EAN50</name>
                    <o2>0.5</o2>
                </mix>
            </gasdefinitions>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        XCTAssertEqual(document.gasdefinitions?.mix?.count, 3)

        let diluentMix = document.gasdefinitions?.mix?.first { $0.id == "diluent" }
        XCTAssertEqual(diluentMix?.usage, .diluent)

        let oxygenMix = document.gasdefinitions?.mix?.first { $0.id == "o2" }
        XCTAssertEqual(oxygenMix?.usage, .oxygen)

        // Mix without usage should have nil
        let bailoutMix = document.gasdefinitions?.mix?.first { $0.id == "bailout" }
        XCTAssertNil(bailoutMix?.usage)
    }

    // MARK: - Round Trip Tests

    func testRoundTrip() throws {
        let generator = Generator(name: "TestApp")
        let gasDefs = GasDefinitions(mix: [
            Mix(id: "back", name: "Air", o2: 0.21, usage: .bottom),
            Mix(id: "deco1", name: "EAN50", o2: 0.5, usage: .deco),
            Mix(id: "diluent", name: "Air", o2: 0.21, usage: .diluent),
            Mix(id: "o2", name: "Oxygen", o2: 1.0, usage: .oxygen),
            Mix(id: "sm1", name: "EAN32", o2: 0.32, usage: .sidemount),
            Mix(id: "bo", name: "EAN32", o2: 0.32, usage: .bailout),
            Mix(id: "nousage", name: "Air", o2: 0.21)  // No usage
        ])

        var document = UDDFDocument(version: "3.2.1", generator: generator)
        document.gasdefinitions = gasDefs

        // Write and parse back
        let xmlData = try UDDFSerialization.write(document, prettyPrinted: true)
        let reparsed = try UDDFSerialization.parse(xmlData)

        XCTAssertEqual(reparsed.gasdefinitions?.mix?.count, 7)

        let reparsedBottom = reparsed.gasdefinitions?.mix?.first { $0.id == "back" }
        XCTAssertEqual(reparsedBottom?.usage, .bottom)

        let reparsedDeco = reparsed.gasdefinitions?.mix?.first { $0.id == "deco1" }
        XCTAssertEqual(reparsedDeco?.usage, .deco)

        let reparsedDiluent = reparsed.gasdefinitions?.mix?.first { $0.id == "diluent" }
        XCTAssertEqual(reparsedDiluent?.usage, .diluent)

        let reparsedOxygen = reparsed.gasdefinitions?.mix?.first { $0.id == "o2" }
        XCTAssertEqual(reparsedOxygen?.usage, .oxygen)

        let reparsedSidemount = reparsed.gasdefinitions?.mix?.first { $0.id == "sm1" }
        XCTAssertEqual(reparsedSidemount?.usage, .sidemount)

        let reparsedBailout = reparsed.gasdefinitions?.mix?.first { $0.id == "bo" }
        XCTAssertEqual(reparsedBailout?.usage, .bailout)

        let reparsedNoUsage = reparsed.gasdefinitions?.mix?.first { $0.id == "nousage" }
        XCTAssertNil(reparsedNoUsage?.usage)
    }

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
