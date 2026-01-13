import XCTest
@testable import UDDF

final class DecoModelParserTests: XCTestCase {

    // MARK: - Parsing Tests

    func testParseMinimalBuehlmann() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
                <manufacturer id="test">
                    <name>Test</name>
                </manufacturer>
            </generator>
            <decomodel>
                <buehlmann id="minimal" />
            </decomodel>
        </uddf>
        """

        let document = try UDDFSerialization.parse(xml.data(using: .utf8)!)

        XCTAssertNotNil(document.decomodel)
        let buehlmann = document.decomodel?.buehlmann?.first
        XCTAssertEqual(buehlmann?.id, "minimal")
        XCTAssertNil(buehlmann?.tissue)
        XCTAssertNil(buehlmann?.gradientfactorlow)
        XCTAssertNil(buehlmann?.gradientfactorhigh)
    }

    func testParseCompleteBuehlmann() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
                <manufacturer id="test">
                    <name>Test</name>
                </manufacturer>
            </generator>
            <decomodel>
                <buehlmann id="zhl16c">
                    <tissue gas="n2" number="1" halflife="300" a="1.1696" b="0.5578" />
                    <tissue gas="n2" number="2" halflife="480" a="1.0" b="0.6514" />
                    <tissue gas="he" number="1" halflife="113.4" a="1.7424" b="0.4245" />
                    <gradientfactorlow>0.3</gradientfactorlow>
                    <gradientfactorhigh>0.85</gradientfactorhigh>
                </buehlmann>
            </decomodel>
        </uddf>
        """

        let document = try UDDFSerialization.parse(xml.data(using: .utf8)!)

        XCTAssertNotNil(document.decomodel)
        let buehlmann = document.decomodel?.buehlmann?.first
        XCTAssertNotNil(buehlmann)
        XCTAssertEqual(buehlmann?.id, "zhl16c")
        XCTAssertEqual(buehlmann?.gradientfactorlow, 0.3)
        XCTAssertEqual(buehlmann?.gradientfactorhigh, 0.85)

        // Verify tissues
        XCTAssertEqual(buehlmann?.tissue?.count, 3)

        let tissue1 = buehlmann?.tissue?[0]
        XCTAssertEqual(tissue1?.gas, .n2)
        XCTAssertEqual(tissue1?.number, 1)
        XCTAssertEqual(tissue1?.halflife, 300)
        XCTAssertEqual(tissue1?.a, 1.1696)
        XCTAssertEqual(tissue1?.b, 0.5578)

        let tissue3 = buehlmann?.tissue?[2]
        XCTAssertEqual(tissue3?.gas, .he)
        XCTAssertEqual(tissue3?.number, 1)
        XCTAssertEqual(tissue3?.halflife, 113.4)
    }

    func testParseCompleteVPM() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
                <manufacturer id="test">
                    <name>Test</name>
                </manufacturer>
            </generator>
            <decomodel>
                <vpm id="vpmb">
                    <conservatism>1.0</conservatism>
                    <gamma>0.0179</gamma>
                    <gc>0.0114</gc>
                    <lambda>7500.0</lambda>
                    <r0>0.8</r0>
                    <tissue gas="n2" number="1" halflife="300" a="1.1696" b="0.5578" />
                </vpm>
            </decomodel>
        </uddf>
        """

        let document = try UDDFSerialization.parse(xml.data(using: .utf8)!)

        XCTAssertNotNil(document.decomodel)
        let vpm = document.decomodel?.vpm?.first
        XCTAssertNotNil(vpm)
        XCTAssertEqual(vpm?.id, "vpmb")
        XCTAssertEqual(vpm?.conservatism, 1.0)
        XCTAssertEqual(vpm?.gamma, 0.0179)
        XCTAssertEqual(vpm?.gc, 0.0114)
        XCTAssertEqual(vpm?.lambda, 7500.0)
        XCTAssertEqual(vpm?.r0, 0.8)
        XCTAssertEqual(vpm?.tissue?.count, 1)
    }

    func testParseCompleteRGBM() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
                <manufacturer id="test">
                    <name>Test</name>
                </manufacturer>
            </generator>
            <decomodel>
                <rgbm id="rgbm-suunto">
                    <tissue gas="n2" number="1" halflife="300" a="1.1696" b="0.5578" />
                    <tissue gas="n2" number="2" halflife="480" a="1.0" b="0.6514" />
                </rgbm>
            </decomodel>
        </uddf>
        """

        let document = try UDDFSerialization.parse(xml.data(using: .utf8)!)

        XCTAssertNotNil(document.decomodel)
        let rgbm = document.decomodel?.rgbm?.first
        XCTAssertNotNil(rgbm)
        XCTAssertEqual(rgbm?.id, "rgbm-suunto")
        XCTAssertEqual(rgbm?.tissue?.count, 2)
    }

    // MARK: - Special cases

    func testParseMultipleDecoModels() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
                <manufacturer id="test">
                    <name>Test</name>
                </manufacturer>
            </generator>
            <decomodel>
                <buehlmann id="zhl16c">
                    <tissue gas="n2" number="1" halflife="300" a="1.1696" b="0.5578" />
                </buehlmann>
                <buehlmann id="zhl16c-conservative">
                    <gradientfactorlow>0.2</gradientfactorlow>
                    <gradientfactorhigh>0.7</gradientfactorhigh>
                </buehlmann>
                <vpm id="vpmb">
                    <conservatism>1.0</conservatism>
                </vpm>
                <rgbm id="rgbm1">
                    <tissue gas="n2" number="1" halflife="300" a="1.1696" b="0.5578" />
                </rgbm>
            </decomodel>
        </uddf>
        """

        let document = try UDDFSerialization.parse(xml.data(using: .utf8)!)

        XCTAssertNotNil(document.decomodel)
        XCTAssertEqual(document.decomodel?.buehlmann?.count, 2)
        XCTAssertEqual(document.decomodel?.vpm?.count, 1)
        XCTAssertEqual(document.decomodel?.rgbm?.count, 1)
    }

    func testParseUnknownTissueGas() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
                <manufacturer id="test">
                    <name>Test</name>
                </manufacturer>
            </generator>
            <decomodel>
                <buehlmann id="test">
                    <tissue gas="ar" number="1" halflife="300" a="1.0" b="0.5" />
                </buehlmann>
            </decomodel>
        </uddf>
        """

        let document = try UDDFSerialization.parse(xml.data(using: .utf8)!)

        let tissue = document.decomodel?.buehlmann?.first?.tissue?.first
        XCTAssertEqual(tissue?.gas, .unknown("ar"))
        XCTAssertFalse(tissue?.gas.isStandard ?? true)
    }

    // MARK: - Fixture Tests

    func testParseBasicFixture() throws {
        let url = Bundle.module.url(
            forResource: "basic",
            withExtension: "uddf",
            subdirectory: "Fixtures/decomodel"
        )!

        let document = try UDDFSerialization.parse(contentsOf: url)

        XCTAssertNotNil(document.decomodel)
        XCTAssertEqual(document.decomodel?.buehlmann?.count, 1)

        let buehlmann = document.decomodel?.buehlmann?.first
        XCTAssertEqual(buehlmann?.id, "zhl16c")
        XCTAssertEqual(buehlmann?.tissue?.count, 2)
        XCTAssertEqual(buehlmann?.gradientfactorlow, 0.3)
        XCTAssertEqual(buehlmann?.gradientfactorhigh, 0.85)
    }

    func testParseFullFixture() throws {
        let url = Bundle.module.url(
            forResource: "full",
            withExtension: "uddf",
            subdirectory: "Fixtures/decomodel"
        )!

        let document = try UDDFSerialization.parse(contentsOf: url)

        XCTAssertNotNil(document.decomodel)
        XCTAssertEqual(document.decomodel?.buehlmann?.count, 2)
        XCTAssertEqual(document.decomodel?.vpm?.count, 1)
        XCTAssertEqual(document.decomodel?.rgbm?.count, 1)

        // Verify first Buehlmann has tissues with different gases
        let buehlmann = document.decomodel?.buehlmann?.first
        XCTAssertEqual(buehlmann?.id, "zhl16c")

        let n2Tissues = buehlmann?.tissue?.filter { $0.gas == .n2 }
        let heTissues = buehlmann?.tissue?.filter { $0.gas == .he }
        XCTAssertEqual(n2Tissues?.count, 4)
        XCTAssertEqual(heTissues?.count, 2)

        // Verify VPM parameters
        let vpm = document.decomodel?.vpm?.first
        XCTAssertEqual(vpm?.id, "vpmb")
        XCTAssertEqual(vpm?.conservatism, 1.0)
        XCTAssertEqual(vpm?.gamma, 0.0179)
    }
}
