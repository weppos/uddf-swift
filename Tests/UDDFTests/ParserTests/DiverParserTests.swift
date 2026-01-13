import XCTest
@testable import UDDF

final class DiverParserTests: XCTestCase {

    // MARK: - Basic Equipment Parsing

    func testParseBasicEquipment() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf xmlns="http://www.streit.cc/uddf/3.2/" version="3.2.1">
            <generator>
                <name>Test</name>
                <manufacturer id="test">
                    <name>Test Co</name>
                </manufacturer>
            </generator>
            <diver>
                <owner id="owner1">
                    <equipment>
                        <divecomputer id="dc1">
                            <name>Perdix AI</name>
                            <manufacturer id="shearwater">
                                <name>Shearwater</name>
                            </manufacturer>
                            <model>Perdix AI</model>
                            <serialnumber>12345</serialnumber>
                        </divecomputer>
                    </equipment>
                </owner>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let owner = document.diver?.owner?.first
        XCTAssertNotNil(owner?.equipment)
        XCTAssertEqual(owner?.equipment?.divecomputer?.count, 1)

        let dc = owner?.equipment?.divecomputer?.first
        XCTAssertEqual(dc?.id, "dc1")
        XCTAssertEqual(dc?.name, "Perdix AI")
        XCTAssertEqual(dc?.manufacturer?.name, "Shearwater")
        XCTAssertEqual(dc?.model, "Perdix AI")
        XCTAssertEqual(dc?.serialnumber, "12345")
    }

    func testParseTankWithMaterial() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf xmlns="http://www.streit.cc/uddf/3.2/" version="3.2.1">
            <generator>
                <name>Test</name>
                <manufacturer id="test">
                    <name>Test Co</name>
                </manufacturer>
            </generator>
            <diver>
                <owner id="owner1">
                    <equipment>
                        <tank id="tank1">
                            <name>Main Tank</name>
                            <tankmaterial>steel</tankmaterial>
                            <tankvolume>0.012</tankvolume>
                        </tank>
                    </equipment>
                </owner>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let tank = document.diver?.owner?.first?.equipment?.tank?.first
        XCTAssertEqual(tank?.id, "tank1")
        XCTAssertEqual(tank?.name, "Main Tank")
        XCTAssertEqual(tank?.tankmaterial, .steel)
        if let cubicMeters = tank?.tankvolume?.cubicMeters {
            XCTAssertEqual(cubicMeters, 0.012, accuracy: 0.0001)
        } else {
            XCTFail("Tank volume should not be nil")
        }
    }

    func testParseSuitWithType() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf xmlns="http://www.streit.cc/uddf/3.2/" version="3.2.1">
            <generator>
                <name>Test</name>
                <manufacturer id="test">
                    <name>Test Co</name>
                </manufacturer>
            </generator>
            <diver>
                <owner id="owner1">
                    <equipment>
                        <suit id="suit1">
                            <name>Drysuit</name>
                            <suittype>dry-suit</suittype>
                        </suit>
                    </equipment>
                </owner>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let suit = document.diver?.owner?.first?.equipment?.suit?.first
        XCTAssertEqual(suit?.id, "suit1")
        XCTAssertEqual(suit?.name, "Drysuit")
        XCTAssertEqual(suit?.suittype, .drySuit)
    }

    func testParseUnknownTankMaterial() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf xmlns="http://www.streit.cc/uddf/3.2/" version="3.2.1">
            <generator>
                <name>Test</name>
                <manufacturer id="test">
                    <name>Test Co</name>
                </manufacturer>
            </generator>
            <diver>
                <owner id="owner1">
                    <equipment>
                        <tank id="tank1">
                            <tankmaterial>titanium</tankmaterial>
                        </tank>
                    </equipment>
                </owner>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let tank = document.diver?.owner?.first?.equipment?.tank?.first
        XCTAssertEqual(tank?.tankmaterial, .unknown("titanium"))
        XCTAssertFalse(tank?.tankmaterial?.isStandard ?? true)
    }

    func testParseEquipmentWithPurchase() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf xmlns="http://www.streit.cc/uddf/3.2/" version="3.2.1">
            <generator>
                <name>Test</name>
                <manufacturer id="test">
                    <name>Test Co</name>
                </manufacturer>
            </generator>
            <diver>
                <owner id="owner1">
                    <equipment>
                        <regulator id="reg1">
                            <name>MK25/S620Ti</name>
                            <purchase>
                                <datetime>2024-01-15T10:30:00Z</datetime>
                                <price currency="EUR">899.00</price>
                                <shop id="shop1">
                                    <name>Dive Shop Munich</name>
                                </shop>
                            </purchase>
                        </regulator>
                    </equipment>
                </owner>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let regulator = document.diver?.owner?.first?.equipment?.regulator?.first
        XCTAssertEqual(regulator?.id, "reg1")
        XCTAssertEqual(regulator?.name, "MK25/S620Ti")
        XCTAssertNotNil(regulator?.purchase)
        XCTAssertEqual(regulator?.purchase?.price?.value, 899.00)
        XCTAssertEqual(regulator?.purchase?.price?.currency, "EUR")
        XCTAssertEqual(regulator?.purchase?.shop?.name, "Dive Shop Munich")
    }
}
