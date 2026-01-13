import XCTest
@testable import UDDF

final class DiverWriterTests: XCTestCase {

    // MARK: - Owner Address and Contact

    func testWriteOwnerWithAddressAndContact() throws {
        let address = Address(
            street: "123 Dive Street",
            city: "Munich",
            postcode: "80331",
            country: "Germany",
            province: "Bavaria"
        )

        let contact = Contact(
            phone: "+49 89 123456",
            email: "diver@example.com",
            homepage: "https://example.com"
        )

        let personal = Personal(firstname: "John", lastname: "Diver")

        let owner = Owner(
            id: "owner1",
            personal: personal,
            address: address,
            contact: contact
        )

        var document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(
                name: "Test",
                manufacturer: Manufacturer(id: "test", name: "Test")
            )
        )
        document.diver = Diver(owner: owner)

        let data = try UDDFSerialization.write(document)
        let xml = String(data: data, encoding: .utf8)!

        XCTAssertTrue(xml.contains("<owner id=\"owner1\">"))

        // Address
        XCTAssertTrue(xml.contains("<address>"))
        XCTAssertTrue(xml.contains("<street>123 Dive Street</street>"))
        XCTAssertTrue(xml.contains("<city>Munich</city>"))
        XCTAssertTrue(xml.contains("<postcode>80331</postcode>"))
        XCTAssertTrue(xml.contains("<country>Germany</country>"))
        XCTAssertTrue(xml.contains("<province>Bavaria</province>"))

        // Contact
        XCTAssertTrue(xml.contains("<contact>"))
        XCTAssertTrue(xml.contains("<phone>+49 89 123456</phone>"))
        XCTAssertTrue(xml.contains("<email>diver@example.com</email>"))
        XCTAssertTrue(xml.contains("<homepage>https://example.com</homepage>"))

        // Personal
        XCTAssertTrue(xml.contains("<personal>"))
        XCTAssertTrue(xml.contains("<firstname>John</firstname>"))
        XCTAssertTrue(xml.contains("<lastname>Diver</lastname>"))
    }

    // MARK: - Buddy Address and Contact

    func testWriteBuddyWithAddressAndContact() throws {
        let address = Address(
            street: "456 Ocean Ave",
            city: "Hamburg",
            postcode: "20095",
            country: "Germany"
        )

        let contact = Contact(
            mobilephone: "+49 171 9876543",
            email: "buddy@example.com"
        )

        let personal = Personal(firstname: "Jane", lastname: "Buddy")

        let buddy = Buddy(
            id: "buddy1",
            personal: personal,
            address: address,
            contact: contact
        )

        var document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(
                name: "Test",
                manufacturer: Manufacturer(id: "test", name: "Test")
            )
        )
        document.diver = Diver(buddy: [buddy])

        let data = try UDDFSerialization.write(document)
        let xml = String(data: data, encoding: .utf8)!

        XCTAssertTrue(xml.contains("<buddy id=\"buddy1\">"))

        // Address
        XCTAssertTrue(xml.contains("<address>"))
        XCTAssertTrue(xml.contains("<street>456 Ocean Ave</street>"))
        XCTAssertTrue(xml.contains("<city>Hamburg</city>"))
        XCTAssertTrue(xml.contains("<postcode>20095</postcode>"))
        XCTAssertTrue(xml.contains("<country>Germany</country>"))

        // Contact
        XCTAssertTrue(xml.contains("<contact>"))
        XCTAssertTrue(xml.contains("<mobilephone>+49 171 9876543</mobilephone>"))
        XCTAssertTrue(xml.contains("<email>buddy@example.com</email>"))

        // Personal
        XCTAssertTrue(xml.contains("<personal>"))
        XCTAssertTrue(xml.contains("<firstname>Jane</firstname>"))
        XCTAssertTrue(xml.contains("<lastname>Buddy</lastname>"))
    }

    // MARK: - Equipment

    func testWriteEquipmentWithDiveComputer() throws {
        let diveComputer = DiveComputer(
            id: "dc1",
            name: "Perdix AI",
            manufacturer: Manufacturer(id: "shearwater", name: "Shearwater"),
            model: "Perdix AI"
        )

        let equipment = Equipment(divecomputer: [diveComputer])
        let owner = Owner(id: "owner1", equipment: equipment)

        var document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(
                name: "Test",
                manufacturer: Manufacturer(id: "test", name: "Test")
            )
        )
        document.diver = Diver(owner: owner)

        let data = try UDDFSerialization.write(document)
        let xml = String(data: data, encoding: .utf8)!

        XCTAssertTrue(xml.contains("<divecomputer id=\"dc1\">"))
        XCTAssertTrue(xml.contains("<name>Perdix AI</name>"))
        XCTAssertTrue(xml.contains("<model>Perdix AI</model>"))
    }

    func testWriteTankWithMaterial() throws {
        let tank = Tank(
            id: "tank1",
            name: "Steel HP100",
            tankmaterial: .steel,
            tankvolume: Volume(liters: 12)
        )

        let equipment = Equipment(tank: [tank])
        let owner = Owner(id: "owner1", equipment: equipment)

        var document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(
                name: "Test",
                manufacturer: Manufacturer(id: "test", name: "Test")
            )
        )
        document.diver = Diver(owner: owner)

        let data = try UDDFSerialization.write(document)
        let xml = String(data: data, encoding: .utf8)!

        XCTAssertTrue(xml.contains("<tank id=\"tank1\">"))
        XCTAssertTrue(xml.contains("<tankmaterial>steel</tankmaterial>"))
        XCTAssertTrue(xml.contains("<tankvolume>"))
    }

    func testWriteSuitWithType() throws {
        let suit = Suit(
            id: "suit1",
            name: "Fusion Drysuit",
            suittype: .drySuit
        )

        let equipment = Equipment(suit: [suit])
        let owner = Owner(id: "owner1", equipment: equipment)

        var document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(
                name: "Test",
                manufacturer: Manufacturer(id: "test", name: "Test")
            )
        )
        document.diver = Diver(owner: owner)

        let data = try UDDFSerialization.write(document)
        let xml = String(data: data, encoding: .utf8)!

        XCTAssertTrue(xml.contains("<suit id=\"suit1\">"))
        XCTAssertTrue(xml.contains("<suittype>dry-suit</suittype>"))
    }

    func testWriteEquipmentWithPurchase() throws {
        let purchase = Purchase(
            price: Price(value: 499.99, currency: "EUR"),
            shop: Shop(id: "shop1", name: "Dive Shop")
        )

        let regulator = Regulator(
            id: "reg1",
            name: "MK25/S620Ti",
            purchase: purchase
        )

        let equipment = Equipment(regulator: [regulator])
        let owner = Owner(id: "owner1", equipment: equipment)

        var document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(
                name: "Test",
                manufacturer: Manufacturer(id: "test", name: "Test")
            )
        )
        document.diver = Diver(owner: owner)

        let data = try UDDFSerialization.write(document)
        let xml = String(data: data, encoding: .utf8)!

        XCTAssertTrue(xml.contains("<regulator id=\"reg1\">"))
        XCTAssertTrue(xml.contains("<purchase>"))
        // Price with currency attribute
        XCTAssertTrue(xml.contains("<price"), "XML should contain price element")
        XCTAssertTrue(xml.contains("499.99"), "XML should contain price value")
        XCTAssertTrue(xml.contains("<shop id=\"shop1\">"))
    }

    func testWriteMultipleEquipmentTypes() throws {
        let equipment = Equipment(
            boots: [Boots(id: "boots1", name: "Dive Boots")],
            fins: [Fins(id: "fins1", name: "Jet Fins")],
            gloves: [Gloves(id: "gloves1", name: "Dive Gloves")],
            mask: [Mask(id: "mask1", name: "Dive Mask")]
        )

        let owner = Owner(id: "owner1", equipment: equipment)

        var document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(
                name: "Test",
                manufacturer: Manufacturer(id: "test", name: "Test")
            )
        )
        document.diver = Diver(owner: owner)

        let data = try UDDFSerialization.write(document)
        let xml = String(data: data, encoding: .utf8)!

        XCTAssertTrue(xml.contains("<boots id=\"boots1\">"))
        XCTAssertTrue(xml.contains("<fins id=\"fins1\">"))
        XCTAssertTrue(xml.contains("<mask id=\"mask1\">"))
        XCTAssertTrue(xml.contains("<gloves id=\"gloves1\">"))
    }
}
