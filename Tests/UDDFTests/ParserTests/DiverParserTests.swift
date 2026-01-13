import XCTest
@testable import UDDF

final class DiverParserTests: XCTestCase {

    // MARK: - Owner Complete

    func testParseOwnerComplete() throws {
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
                    <personal>
                        <firstname>John</firstname>
                        <middlename>Michael</middlename>
                        <lastname>Diver</lastname>
                        <birthname>Smith</birthname>
                        <honorific>Dr.</honorific>
                        <sex>male</sex>
                        <height>1.82</height>
                        <weight>78.6</weight>
                        <smoking>0</smoking>
                        <birthdate>
                            <datetime>1985-06-15T00:00:00</datetime>
                        </birthdate>
                        <passport>AB123456</passport>
                        <bloodgroup>A+</bloodgroup>
                        <membership organisation="DAN" memberid="123456"/>
                        <membership organisation="PADI" memberid="789012"/>
                        <numberofdives startdate="2010-01-01" enddate="2024-01-01" dives="500"/>
                    </personal>
                    <address>
                        <street>123 Dive Street</street>
                        <city>Munich</city>
                        <postcode>80331</postcode>
                        <country>Germany</country>
                        <province>Bavaria</province>
                    </address>
                    <contact>
                        <phone>+49 89 123456</phone>
                        <email>diver@example.com</email>
                        <homepage>https://example.com</homepage>
                    </contact>
                </owner>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let owner = document.diver?.owner
        XCTAssertEqual(owner?.id, "owner1")

        // Personal
        let personal = owner?.personal
        XCTAssertEqual(personal?.firstname, "John")
        XCTAssertEqual(personal?.middlename, "Michael")
        XCTAssertEqual(personal?.lastname, "Diver")
        XCTAssertEqual(personal?.birthname, "Smith")
        XCTAssertEqual(personal?.honorific, "Dr.")
        XCTAssertEqual(personal?.sex, .male)
        XCTAssertEqual(personal?.height, 1.82)
        XCTAssertEqual(personal?.weight, 78.6)
        XCTAssertEqual(personal?.smoking, .nonSmoker)
        XCTAssertNotNil(personal?.birthdate?.datetime)
        XCTAssertEqual(personal?.passport, "AB123456")
        XCTAssertEqual(personal?.bloodgroup, "A+")

        // Memberships
        XCTAssertEqual(personal?.membership?.count, 2)
        XCTAssertEqual(personal?.membership?[0].organisation, "DAN")
        XCTAssertEqual(personal?.membership?[0].memberid, "123456")
        XCTAssertEqual(personal?.membership?[1].organisation, "PADI")
        XCTAssertEqual(personal?.membership?[1].memberid, "789012")

        // Number of dives
        XCTAssertEqual(personal?.numberofdives?.startdate, "2010-01-01")
        XCTAssertEqual(personal?.numberofdives?.enddate, "2024-01-01")
        XCTAssertEqual(personal?.numberofdives?.dives, 500)

        // Address
        XCTAssertEqual(owner?.address?.street, "123 Dive Street")
        XCTAssertEqual(owner?.address?.city, "Munich")
        XCTAssertEqual(owner?.address?.postcode, "80331")
        XCTAssertEqual(owner?.address?.country, "Germany")
        XCTAssertEqual(owner?.address?.province, "Bavaria")

        // Contact
        XCTAssertEqual(owner?.contact?.phone, "+49 89 123456")
        XCTAssertEqual(owner?.contact?.email, "diver@example.com")
        XCTAssertEqual(owner?.contact?.homepage, "https://example.com")
    }

    // MARK: - Buddy Complete

    func testParseBuddyWithAddressAndContact() throws {
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
                <buddy id="buddy1">
                    <address>
                        <street>456 Ocean Ave</street>
                        <city>Hamburg</city>
                        <postcode>20095</postcode>
                        <country>Germany</country>
                    </address>
                    <contact>
                        <mobilephone>+49 171 9876543</mobilephone>
                        <email>buddy@example.com</email>
                    </contact>
                    <personal>
                        <firstname>Jane</firstname>
                        <lastname>Buddy</lastname>
                    </personal>
                </buddy>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let buddy = document.diver?.buddy?.first
        XCTAssertEqual(buddy?.id, "buddy1")

        // Address
        XCTAssertEqual(buddy?.address?.street, "456 Ocean Ave")
        XCTAssertEqual(buddy?.address?.city, "Hamburg")
        XCTAssertEqual(buddy?.address?.postcode, "20095")
        XCTAssertEqual(buddy?.address?.country, "Germany")

        // Contact
        XCTAssertEqual(buddy?.contact?.mobilephone, "+49 171 9876543")
        XCTAssertEqual(buddy?.contact?.email, "buddy@example.com")

        // Personal
        XCTAssertEqual(buddy?.personal?.firstname, "Jane")
        XCTAssertEqual(buddy?.personal?.lastname, "Buddy")
    }

    // MARK: - Sex and Smoking Enums

    func testParseSexValues() throws {
        let sexValues = ["undetermined", "male", "female", "hermaphrodite"]

        for sexValue in sexValues {
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
                        <personal>
                            <sex>\(sexValue)</sex>
                        </personal>
                    </owner>
                </diver>
            </uddf>
            """

            let data = xml.data(using: .utf8)!
            let document = try UDDFSerialization.parse(data)

            let sex = document.diver?.owner?.personal?.sex
            XCTAssertNotNil(sex)
            XCTAssertEqual(sex?.rawValue, sexValue)
            XCTAssertTrue(sex?.isStandard ?? false, "Sex '\(sexValue)' should be standard")
        }
    }

    func testParseUnknownSex() throws {
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
                    <personal>
                        <sex>other</sex>
                    </personal>
                </owner>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let sex = document.diver?.owner?.personal?.sex
        XCTAssertEqual(sex, .unknown("other"))
        XCTAssertFalse(sex?.isStandard ?? true)
    }

    func testParseSmokingValues() throws {
        let smokingTests: [(String, Smoking)] = [
            ("0", .nonSmoker),
            ("0-3", .zeroToThree),
            ("4-10", .fourToTen),
            ("11-20", .elevenToTwenty),
            ("21-40", .twentyOneToForty),
            ("40+", .fortyPlus)
        ]

        for (xmlValue, expected) in smokingTests {
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
                        <personal>
                            <smoking>\(xmlValue)</smoking>
                        </personal>
                    </owner>
                </diver>
            </uddf>
            """

            let data = xml.data(using: .utf8)!
            let document = try UDDFSerialization.parse(data)

            let smoking = document.diver?.owner?.personal?.smoking
            XCTAssertEqual(smoking, expected, "Smoking '\(xmlValue)' should parse correctly")
            XCTAssertTrue(smoking?.isStandard ?? false, "Smoking '\(xmlValue)' should be standard")
        }
    }

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

        let owner = document.diver?.owner
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

        let tank = document.diver?.owner?.equipment?.tank?.first
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

        let suit = document.diver?.owner?.equipment?.suit?.first
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

        let tank = document.diver?.owner?.equipment?.tank?.first
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

        let regulator = document.diver?.owner?.equipment?.regulator?.first
        XCTAssertEqual(regulator?.id, "reg1")
        XCTAssertEqual(regulator?.name, "MK25/S620Ti")
        XCTAssertNotNil(regulator?.purchase)
        XCTAssertEqual(regulator?.purchase?.price?.value, 899.00)
        XCTAssertEqual(regulator?.purchase?.price?.currency, "EUR")
        XCTAssertEqual(regulator?.purchase?.shop?.name, "Dive Shop Munich")
    }
}
