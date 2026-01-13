import XCTest
@testable import UDDF

final class DiverSerializationTests: XCTestCase {

    func testRoundTrip() throws {
        let diveComputer = DiveComputer(
            id: "dc1",
            name: "Perdix AI",
            manufacturer: Manufacturer(id: "shearwater", name: "Shearwater"),
            model: "Perdix AI",
            serialnumber: "ABC123"
        )

        let tank = Tank(
            id: "tank1",
            name: "Steel HP100",
            tankmaterial: .steel,
            tankvolume: Volume(liters: 12)
        )

        let suit = Suit(
            id: "suit1",
            name: "Fusion Drysuit",
            suittype: .drySuit
        )

        let equipment = Equipment(
            divecomputer: [diveComputer],
            suit: [suit],
            tank: [tank]
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
        let parsed = try UDDFSerialization.parse(data)

        let parsedEquipment = parsed.diver?.owner?.equipment
        XCTAssertEqual(parsedEquipment?.divecomputer?.first?.id, "dc1")
        XCTAssertEqual(parsedEquipment?.divecomputer?.first?.name, "Perdix AI")
        XCTAssertEqual(parsedEquipment?.tank?.first?.tankmaterial, .steel)
        XCTAssertEqual(parsedEquipment?.suit?.first?.suittype, .drySuit)
    }
}
