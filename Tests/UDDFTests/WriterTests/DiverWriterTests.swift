import XCTest
@testable import UDDF

final class DiverWriterTests: XCTestCase {

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
