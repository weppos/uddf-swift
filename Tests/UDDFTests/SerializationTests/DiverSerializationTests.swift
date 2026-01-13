import XCTest
@testable import UDDF

final class DiverSerializationTests: XCTestCase {

    func testRoundTripOwnerWithAddressAndContact() throws {
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
        let parsed = try UDDFSerialization.parse(data)

        let parsedOwner = parsed.diver?.owner
        XCTAssertEqual(parsedOwner?.id, "owner1")

        // Address
        XCTAssertEqual(parsedOwner?.address?.street, "123 Dive Street")
        XCTAssertEqual(parsedOwner?.address?.city, "Munich")
        XCTAssertEqual(parsedOwner?.address?.postcode, "80331")
        XCTAssertEqual(parsedOwner?.address?.country, "Germany")
        XCTAssertEqual(parsedOwner?.address?.province, "Bavaria")

        // Contact
        XCTAssertEqual(parsedOwner?.contact?.phone, "+49 89 123456")
        XCTAssertEqual(parsedOwner?.contact?.email, "diver@example.com")
        XCTAssertEqual(parsedOwner?.contact?.homepage, "https://example.com")

        // Personal
        XCTAssertEqual(parsedOwner?.personal?.firstname, "John")
        XCTAssertEqual(parsedOwner?.personal?.lastname, "Diver")
    }

    func testRoundTripBuddyWithAddressAndContact() throws {
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
        let parsed = try UDDFSerialization.parse(data)

        let parsedBuddy = parsed.diver?.buddy?.first
        XCTAssertEqual(parsedBuddy?.id, "buddy1")

        // Address
        XCTAssertEqual(parsedBuddy?.address?.street, "456 Ocean Ave")
        XCTAssertEqual(parsedBuddy?.address?.city, "Hamburg")
        XCTAssertEqual(parsedBuddy?.address?.postcode, "20095")
        XCTAssertEqual(parsedBuddy?.address?.country, "Germany")

        // Contact
        XCTAssertEqual(parsedBuddy?.contact?.mobilephone, "+49 171 9876543")
        XCTAssertEqual(parsedBuddy?.contact?.email, "buddy@example.com")

        // Personal
        XCTAssertEqual(parsedBuddy?.personal?.firstname, "Jane")
        XCTAssertEqual(parsedBuddy?.personal?.lastname, "Buddy")
    }

    func testRoundTripPersonalComplete() throws {
        let personal = Personal(
            firstname: "John",
            middlename: "Michael",
            lastname: "Diver",
            birthname: "Smith",
            honorific: "Dr.",
            sex: .male,
            height: 1.82,
            weight: 78.6,
            smoking: .nonSmoker,
            passport: "AB123456",
            bloodgroup: "A+",
            membership: [
                Membership(organisation: "DAN", memberid: "123456"),
                Membership(organisation: "PADI", memberid: "789012")
            ],
            numberofdives: NumberOfDives(startdate: "2010-01-01", enddate: "2024-01-01", dives: 500)
        )

        let owner = Owner(id: "owner1", personal: personal)

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

        let parsedPersonal = parsed.diver?.owner?.personal
        XCTAssertEqual(parsedPersonal?.firstname, "John")
        XCTAssertEqual(parsedPersonal?.middlename, "Michael")
        XCTAssertEqual(parsedPersonal?.lastname, "Diver")
        XCTAssertEqual(parsedPersonal?.birthname, "Smith")
        XCTAssertEqual(parsedPersonal?.honorific, "Dr.")
        XCTAssertEqual(parsedPersonal?.sex, .male)
        XCTAssertEqual(parsedPersonal?.height, 1.82)
        XCTAssertEqual(parsedPersonal?.weight, 78.6)
        XCTAssertEqual(parsedPersonal?.smoking, .nonSmoker)
        XCTAssertEqual(parsedPersonal?.passport, "AB123456")
        XCTAssertEqual(parsedPersonal?.bloodgroup, "A+")

        // Memberships
        XCTAssertEqual(parsedPersonal?.membership?.count, 2)
        XCTAssertEqual(parsedPersonal?.membership?[0].organisation, "DAN")
        XCTAssertEqual(parsedPersonal?.membership?[0].memberid, "123456")

        // Number of dives
        XCTAssertEqual(parsedPersonal?.numberofdives?.startdate, "2010-01-01")
        XCTAssertEqual(parsedPersonal?.numberofdives?.enddate, "2024-01-01")
        XCTAssertEqual(parsedPersonal?.numberofdives?.dives, 500)
    }

    func testRoundTripEquipment() throws {
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
