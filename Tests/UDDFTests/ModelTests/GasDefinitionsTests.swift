import XCTest
@testable import UDDF

final class GasDefinitionsTests: XCTestCase {

    // MARK: - Mix Type Tests

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

    // MARK: - GasUsage Enum Tests

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
}
