import XCTest
@testable import UDDF

final class DecoModelTests: XCTestCase {

    // MARK: - TissueGas Tests

    func testTissueGasRawValues() {
        XCTAssertEqual(TissueGas.n2.rawValue, "n2")
        XCTAssertEqual(TissueGas.he.rawValue, "he")
        XCTAssertEqual(TissueGas.h2.rawValue, "h2")
        XCTAssertEqual(TissueGas.unknown("ar").rawValue, "ar")
    }

    func testTissueGasInitFromRawValue() {
        XCTAssertEqual(TissueGas(rawValue: "n2"), .n2)
        XCTAssertEqual(TissueGas(rawValue: "he"), .he)
        XCTAssertEqual(TissueGas(rawValue: "h2"), .h2)

        // Case-insensitive
        XCTAssertEqual(TissueGas(rawValue: "N2"), .n2)
        XCTAssertEqual(TissueGas(rawValue: "HE"), .he)
        XCTAssertEqual(TissueGas(rawValue: "H2"), .h2)
    }

    func testTissueGasUnknown() {
        let unknown = TissueGas(rawValue: "ar")
        XCTAssertEqual(unknown, .unknown("ar"))
        XCTAssertEqual(unknown.rawValue, "ar")
    }

    func testTissueGasIsStandard() {
        XCTAssertTrue(TissueGas.n2.isStandard)
        XCTAssertTrue(TissueGas.he.isStandard)
        XCTAssertTrue(TissueGas.h2.isStandard)
        XCTAssertFalse(TissueGas.unknown("ar").isStandard)
    }

    // MARK: - Tissue Tests

    func testTissueInit() {
        let tissue = Tissue(
            gas: .n2,
            number: 1,
            halflife: 300,
            a: 1.1696,
            b: 0.5578
        )

        XCTAssertEqual(tissue.gas, .n2)
        XCTAssertEqual(tissue.number, 1)
        XCTAssertEqual(tissue.halflife, 300)
        XCTAssertEqual(tissue.a, 1.1696)
        XCTAssertEqual(tissue.b, 0.5578)
    }

    // MARK: - Buehlmann Tests

    func testBuehlmannInit() {
        let tissues = [
            Tissue(gas: .n2, number: 1, halflife: 300, a: 1.1696, b: 0.5578),
            Tissue(gas: .n2, number: 2, halflife: 480, a: 1.0, b: 0.6514),
        ]

        let buehlmann = Buehlmann(
            id: "zhl16c",
            tissue: tissues,
            gradientfactorlow: 0.3,
            gradientfactorhigh: 0.85
        )

        XCTAssertEqual(buehlmann.id, "zhl16c")
        XCTAssertEqual(buehlmann.tissue?.count, 2)
        XCTAssertEqual(buehlmann.gradientfactorlow, 0.3)
        XCTAssertEqual(buehlmann.gradientfactorhigh, 0.85)
    }

    func testBuehlmannMinimalInit() {
        let buehlmann = Buehlmann(id: "minimal")

        XCTAssertEqual(buehlmann.id, "minimal")
        XCTAssertNil(buehlmann.tissue)
        XCTAssertNil(buehlmann.gradientfactorlow)
        XCTAssertNil(buehlmann.gradientfactorhigh)
    }

    // MARK: - VPM Tests

    func testVPMInit() {
        let vpm = VPM(
            id: "vpmb",
            conservatism: 1.0,
            gamma: 0.0179,
            gc: 0.0114,
            lambda: 7500.0,
            r0: 0.8,
            tissue: []
        )

        XCTAssertEqual(vpm.id, "vpmb")
        XCTAssertEqual(vpm.conservatism, 1.0)
        XCTAssertEqual(vpm.gamma, 0.0179)
        XCTAssertEqual(vpm.gc, 0.0114)
        XCTAssertEqual(vpm.lambda, 7500.0)
        XCTAssertEqual(vpm.r0, 0.8)
    }

    func testVPMMinimalInit() {
        let vpm = VPM(id: "minimal")

        XCTAssertEqual(vpm.id, "minimal")
        XCTAssertNil(vpm.conservatism)
        XCTAssertNil(vpm.gamma)
        XCTAssertNil(vpm.gc)
        XCTAssertNil(vpm.lambda)
        XCTAssertNil(vpm.r0)
        XCTAssertNil(vpm.tissue)
    }

    // MARK: - RGBM Tests

    func testRGBMInit() {
        let tissues = [
            Tissue(gas: .n2, number: 1, halflife: 300, a: 1.1696, b: 0.5578),
        ]

        let rgbm = RGBM(id: "rgbm1", tissue: tissues)

        XCTAssertEqual(rgbm.id, "rgbm1")
        XCTAssertEqual(rgbm.tissue?.count, 1)
    }

    func testRGBMMinimalInit() {
        let rgbm = RGBM(id: "minimal")

        XCTAssertEqual(rgbm.id, "minimal")
        XCTAssertNil(rgbm.tissue)
    }

    // MARK: - DecoModel Container Tests

    func testDecoModelInit() {
        let buehlmann = Buehlmann(id: "zhl16c")
        let vpm = VPM(id: "vpmb")
        let rgbm = RGBM(id: "rgbm1")

        let decomodel = DecoModel(
            buehlmann: [buehlmann],
            vpm: [vpm],
            rgbm: [rgbm]
        )

        XCTAssertEqual(decomodel.buehlmann?.count, 1)
        XCTAssertEqual(decomodel.vpm?.count, 1)
        XCTAssertEqual(decomodel.rgbm?.count, 1)
    }

    func testDecoModelEmptyInit() {
        let decomodel = DecoModel()

        XCTAssertNil(decomodel.buehlmann)
        XCTAssertNil(decomodel.vpm)
        XCTAssertNil(decomodel.rgbm)
    }

    // MARK: - Equatable Tests

    func testTissueGasEquatable() {
        XCTAssertEqual(TissueGas.n2, TissueGas.n2)
        XCTAssertNotEqual(TissueGas.n2, TissueGas.he)
        XCTAssertEqual(TissueGas.unknown("ar"), TissueGas.unknown("ar"))
        XCTAssertNotEqual(TissueGas.unknown("ar"), TissueGas.unknown("kr"))
    }

    func testTissueEquatable() {
        let tissue1 = Tissue(gas: .n2, number: 1, halflife: 300, a: 1.0, b: 0.5)
        let tissue2 = Tissue(gas: .n2, number: 1, halflife: 300, a: 1.0, b: 0.5)
        let tissue3 = Tissue(gas: .he, number: 1, halflife: 300, a: 1.0, b: 0.5)

        XCTAssertEqual(tissue1, tissue2)
        XCTAssertNotEqual(tissue1, tissue3)
    }
}
