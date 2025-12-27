import XCTest
@testable import UDDF

final class UDDFBuilderTests: XCTestCase {
    // MARK: - Basic Builder Tests

    func testMinimalDocument() throws {
        let document = try UDDFBuilder()
            .generator(name: "TestApp", version: "1.0.0")
            .build()

        XCTAssertEqual(document.version, "3.2.1")
        XCTAssertEqual(document.generator.name, "TestApp")
        XCTAssertEqual(document.generator.version, "1.0.0")
    }

    func testBuilderWithoutGenerator() {
        XCTAssertThrowsError(try UDDFBuilder().build()) { error in
            guard case UDDFError.missingGenerator = error else {
                XCTFail("Expected missingGenerator error")
                return
            }
        }
    }

    func testBuilderWithDiver() throws {
        let owner = Owner(
            id: "owner1",
            personal: Personal(firstname: "John", lastname: "Doe")
        )

        let document = try UDDFBuilder()
            .generator(name: "TestApp")
            .addOwner(owner)
            .build()

        XCTAssertNotNil(document.diver)
        XCTAssertEqual(document.diver?.owner?.count, 1)
        XCTAssertEqual(document.diver?.owner?.first?.id, "owner1")
        XCTAssertEqual(document.diver?.owner?.first?.personal?.firstname, "John")
    }

    func testBuilderWithMultipleBuddies() throws {
        let buddy1 = Buddy(id: "buddy1", personal: Personal(firstname: "Jane"))
        let buddy2 = Buddy(id: "buddy2", personal: Personal(firstname: "Bob"))

        let document = try UDDFBuilder()
            .generator(name: "TestApp")
            .addBuddy(buddy1)
            .addBuddy(buddy2)
            .build()

        XCTAssertEqual(document.diver?.buddy?.count, 2)
        XCTAssertEqual(document.diver?.buddy?[0].id, "buddy1")
        XCTAssertEqual(document.diver?.buddy?[1].id, "buddy2")
    }

    // MARK: - Gas Mix Builder Tests

    func testBuilderWithAir() throws {
        let document = try UDDFBuilder()
            .generator(name: "TestApp")
            .addAir()
            .build()

        XCTAssertNotNil(document.gasdefinitions)
        XCTAssertEqual(document.gasdefinitions?.mix?.count, 1)

        let air = document.gasdefinitions?.mix?.first
        XCTAssertEqual(air?.id, "air")
        XCTAssertTrue(air?.isAir ?? false)
    }

    func testBuilderWithNitrox() throws {
        let document = try UDDFBuilder()
            .generator(name: "TestApp")
            .addNitrox(id: "ean32", oxygenPercent: 32)
            .build()

        let nitrox = document.gasdefinitions?.mix?.first
        XCTAssertEqual(nitrox?.id, "ean32")
        XCTAssertEqual(nitrox?.name, "EAN32")
        XCTAssertEqual(nitrox?.o2 ?? 0, 0.32, accuracy: 0.001)
        XCTAssertTrue(nitrox?.isNitrox ?? false)
    }

    func testBuilderWithMultipleGases() throws {
        let trimix = Mix(id: "tx1845", name: "Trimix 18/45", o2: 0.18, n2: 0.37, he: 0.45)

        let document = try UDDFBuilder()
            .generator(name: "TestApp")
            .addAir()
            .addNitrox(id: "ean32", oxygenPercent: 32)
            .addGasMix(trimix)
            .build()

        XCTAssertEqual(document.gasdefinitions?.mix?.count, 3)
    }

    // MARK: - Dive Site Builder Tests

    func testBuilderWithDiveSite() throws {
        let site = DiveSite(
            id: "site1",
            name: "Blue Hole",
            geography: Geography(
                location: "Red Sea",
                gps: GPS(latitude: 28.0, longitude: 34.0)
            )
        )

        let document = try UDDFBuilder()
            .generator(name: "TestApp")
            .addDiveSite(site)
            .build()

        XCTAssertEqual(document.divesite?.count, 1)
        XCTAssertEqual(document.divesite?.first?.name, "Blue Hole")
        XCTAssertEqual(document.divesite?.first?.geography?.gps?.latitude, 28.0)
    }

    // MARK: - Dive Builder Tests

    func testBuilderWithDive() throws {
        let dive = Dive(
            id: "dive1",
            informationafterdive: InformationAfterDive(
                greatestdepth: Depth(meters: 18.5),
                diveduration: Duration(minutes: 45)
            )
        )

        let document = try UDDFBuilder()
            .generator(name: "TestApp")
            .addDive(dive)
            .build()

        XCTAssertNotNil(document.profiledata)
        XCTAssertEqual(document.profiledata?.repetitiongroup?.count, 1)

        let savedDive = document.profiledata?.repetitiongroup?.first?.dive?.first
        XCTAssertEqual(savedDive?.id, "dive1")
        XCTAssertEqual(savedDive?.informationafterdive?.greatestdepth?.meters, 18.5)
    }

    // MARK: - Complex Builder Tests

    func testComplexDocument() throws {
        let owner = Owner(id: "owner1", personal: Personal(firstname: "John"))
        let site = DiveSite(id: "site1", name: "Reef Dive")
        let dive = Dive(
            id: "dive1",
            informationafterdive: InformationAfterDive(
                greatestdepth: Depth(meters: 20)
            )
        )

        let document = try UDDFBuilder()
            .generator(name: "MyDiveApp", version: "2.0.0")
            .addOwner(owner)
            .addDiveSite(site)
            .addAir()
            .addNitrox(id: "ean32", oxygenPercent: 32)
            .addDive(dive)
            .build()

        // Verify all sections
        XCTAssertEqual(document.generator.name, "MyDiveApp")
        XCTAssertNotNil(document.diver?.owner)
        XCTAssertNotNil(document.divesite)
        XCTAssertEqual(document.gasdefinitions?.mix?.count, 2)
        XCTAssertNotNil(document.profiledata)
    }

    // MARK: - Round-Trip Tests

    func testBuilderRoundTrip() throws {
        let originalDoc = try UDDFBuilder()
            .generator(name: "TestApp", version: "1.0")
            .addAir()
            .build()

        let xmlData = try UDDF.write(originalDoc)
        let parsedDoc = try UDDF.parse(xmlData)

        XCTAssertEqual(parsedDoc.generator.name, originalDoc.generator.name)
        XCTAssertEqual(parsedDoc.generator.version, originalDoc.generator.version)
        XCTAssertEqual(parsedDoc.gasdefinitions?.mix?.count, 1)
    }
}
