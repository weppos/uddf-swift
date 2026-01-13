import XCTest
@testable import UDDF

final class GeneratorParserTests: XCTestCase {

    // MARK: - Parsing Tests

    func testParseMinimal() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
                <version>1.0.0</version>
            </generator>
        </uddf>
        """

        let document = try UDDFSerialization.parse(xml.data(using: .utf8)!)

        XCTAssertEqual(document.generator.name, "TestApp")
        XCTAssertEqual(document.generator.version, "1.0.0")
        XCTAssertNil(document.generator.aliasname)
        XCTAssertNil(document.generator.manufacturer)
        XCTAssertNil(document.generator.datetime)
        XCTAssertNil(document.generator.type)
        XCTAssertNil(document.generator.link)
    }

    func testParseComplete() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>DiveLogPro</name>
                <aliasname>DLP</aliasname>
                <aliasname>Dive Log Professional</aliasname>
                <manufacturer id="acme">
                    <name>Acme Dive Software</name>
                    <aliasname>ADS</aliasname>
                    <address>
                        <street>123 Ocean Drive</street>
                        <city>Monterey</city>
                        <postcode>93940</postcode>
                        <country>USA</country>
                        <province>California</province>
                    </address>
                    <contact>
                        <language>en</language>
                        <phone>+1-555-123-4567</phone>
                        <mobilephone>+1-555-987-6543</mobilephone>
                        <fax>+1-555-123-4568</fax>
                        <email>support@acmedive.example.com</email>
                        <homepage>https://acmedive.example.com</homepage>
                    </contact>
                </manufacturer>
                <version>2.5.1</version>
                <datetime>2024-06-15T10:30:00Z</datetime>
                <type>logbook</type>
                <link ref="some-reference" />
            </generator>
        </uddf>
        """

        let document = try UDDFSerialization.parse(xml.data(using: .utf8)!)

        // Generator
        XCTAssertEqual(document.generator.name, "DiveLogPro")
        XCTAssertEqual(document.generator.aliasname, ["DLP", "Dive Log Professional"])
        XCTAssertEqual(document.generator.version, "2.5.1")
        XCTAssertNotNil(document.generator.datetime)
        XCTAssertEqual(document.generator.type, .logbook)
        XCTAssertEqual(document.generator.link?.ref, "some-reference")

        // Manufacturer
        let manufacturer = document.generator.manufacturer
        XCTAssertEqual(manufacturer?.id, "acme")
        XCTAssertEqual(manufacturer?.name, "Acme Dive Software")
        XCTAssertEqual(manufacturer?.aliasname, ["ADS"])

        // Address
        let address = manufacturer?.address
        XCTAssertEqual(address?.street, "123 Ocean Drive")
        XCTAssertEqual(address?.city, "Monterey")
        XCTAssertEqual(address?.postcode, "93940")
        XCTAssertEqual(address?.country, "USA")
        XCTAssertEqual(address?.province, "California")

        // Contact
        let contact = manufacturer?.contact
        XCTAssertEqual(contact?.language, "en")
        XCTAssertEqual(contact?.phone, "+1-555-123-4567")
        XCTAssertEqual(contact?.mobilephone, "+1-555-987-6543")
        XCTAssertEqual(contact?.fax, "+1-555-123-4568")
        XCTAssertEqual(contact?.email, "support@acmedive.example.com")
        XCTAssertEqual(contact?.homepage, "https://acmedive.example.com")
    }

    // MARK: - Round Trip Tests

    func testRoundTrip() throws {
        let generator = Generator(
            name: "TestApp",
            version: "1.0.0"
        )
        let document = UDDFDocument(generator: generator)

        let data = try UDDFSerialization.write(document)
        let parsed = try UDDFSerialization.parse(data)

        XCTAssertEqual(parsed.generator.name, "TestApp")
        XCTAssertEqual(parsed.generator.version, "1.0.0")
        XCTAssertNil(parsed.generator.aliasname)
        XCTAssertNil(parsed.generator.manufacturer)
        XCTAssertNil(parsed.generator.type)
    }
}
