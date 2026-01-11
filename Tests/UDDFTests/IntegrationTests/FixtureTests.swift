import XCTest
@testable import UDDF

/// Integration tests using real UDDF fixture files
final class FixtureTests: XCTestCase {
    // MARK: - Helper Methods

    private func fixtureURL(_ filename: String) -> URL {
        let fileURL = URL(fileURLWithPath: #file)
        let testsDir = fileURL.deletingLastPathComponent().deletingLastPathComponent()
        return testsDir.appendingPathComponent("Fixtures").appendingPathComponent(filename)
    }

    // MARK: - Valid Fixture Tests

    func testMinimalFixture() throws {
        let url = fixtureURL("minimal.uddf")
        let document = try UDDFSerialization.parse(contentsOf: url)

        XCTAssertEqual(document.version, "3.2.1")
        XCTAssertEqual(document.generator.name, "TestApp")
        XCTAssertEqual(document.generator.version, "1.0.0")

        // Validate
        let validation = UDDFSerialization.validate(document)
        XCTAssertTrue(validation.isValid, "Minimal fixture should be valid")
    }

    func testFullProfileFixture() throws {
        let url = fixtureURL("full_profile.uddf")
        let document = try UDDFSerialization.parse(contentsOf: url)

        // Verify generator
        XCTAssertEqual(document.generator.name, "DiveLogPro")
        XCTAssertEqual(document.generator.version, "2.5.0")
        XCTAssertEqual(document.generator.manufacturer?.name, "DiveSoft Inc")

        // Verify divers
        XCTAssertEqual(document.diver?.owner?.count, 1)
        XCTAssertEqual(document.diver?.owner?.first?.id, "owner1")
        XCTAssertEqual(document.diver?.owner?.first?.personal?.firstname, "John")
        XCTAssertEqual(document.diver?.buddy?.count, 1)
        XCTAssertEqual(document.diver?.buddy?.first?.id, "buddy1")

        // Verify dive site
        XCTAssertEqual(document.divesite?.count, 1)
        XCTAssertEqual(document.divesite?.first?.id, "site1")
        XCTAssertEqual(document.divesite?.first?.name, "Blue Hole")
        XCTAssertEqual(document.divesite?.first?.geography?.gps?.latitude, 28.123456)

        // Verify gas definitions
        XCTAssertEqual(document.gasdefinitions?.mix?.count, 2)
        let mixes = document.gasdefinitions?.mix ?? []
        XCTAssertTrue(mixes.contains { $0.id == "air" })
        XCTAssertTrue(mixes.contains { $0.id == "ean32" })

        // Verify dive profile
        XCTAssertNotNil(document.profiledata)
        XCTAssertEqual(document.profiledata?.repetitiongroup?.count, 1)

        let dive = document.profiledata?.repetitiongroup?.first?.dive?.first
        XCTAssertNotNil(dive)
        XCTAssertEqual(dive?.id, "dive1")

        // Verify dive samples
        let waypoints = dive?.samples?.waypoint ?? []
        XCTAssertEqual(waypoints.count, 5)
        XCTAssertEqual(waypoints[0].divetime?.seconds, 0.0)
        XCTAssertEqual(waypoints[0].depth?.meters, 0.0)
        XCTAssertEqual(waypoints[2].depth?.meters, 18.5)

        // Verify dive stats
        XCTAssertEqual(dive?.informationafterdive?.greatestdepth?.meters, 18.5)
        XCTAssertEqual(dive?.informationafterdive?.averagedepth?.meters, 12.3)
        XCTAssertEqual(dive?.informationafterdive?.diveduration?.seconds, 1500.0)

        // Validate
        let validation = UDDFSerialization.validate(document)
        XCTAssertTrue(validation.isValid, "Full profile fixture should be valid")
    }

    func testCrossReferencesFixture() throws {
        let url = fixtureURL("cross_references.uddf")
        let (document, resolution) = try UDDFSerialization.parseAndResolve(contentsOf: url)

        // Should have no resolution errors
        XCTAssertTrue(resolution.isValid, "All references should resolve")
        XCTAssertEqual(resolution.errors.count, 0)

        // Verify multiple owners
        XCTAssertEqual(document.diver?.owner?.count, 2)
        XCTAssertEqual(document.diver?.buddy?.count, 1)

        // Verify multiple sites
        XCTAssertEqual(document.divesite?.count, 2)

        // Verify multiple gas mixes
        XCTAssertEqual(document.gasdefinitions?.mix?.count, 3)

        // Verify multiple dives in same repetition group
        let dives = document.profiledata?.repetitiongroup?.first?.dive ?? []
        XCTAssertEqual(dives.count, 2)

        // Verify dive information
        XCTAssertEqual(dives[0].informationbeforedive?.divenumber, 1)
        XCTAssertEqual(dives[0].id, "dive1")
        XCTAssertEqual(dives[0].informationafterdive?.greatestdepth?.meters, 15.0)

        XCTAssertEqual(dives[1].informationbeforedive?.divenumber, 2)
        XCTAssertEqual(dives[1].id, "dive2")
        XCTAssertEqual(dives[1].informationafterdive?.greatestdepth?.meters, 20.0)
    }

    func testGasDefinitionsFixture() throws {
        let url = fixtureURL("gas_definitions.uddf")
        let document = try UDDFSerialization.parse(contentsOf: url)

        let mixes = document.gasdefinitions?.mix ?? []
        XCTAssertEqual(mixes.count, 6)

        // Verify air
        let air = mixes.first { $0.id == "air" }
        XCTAssertNotNil(air)
        XCTAssertTrue(air?.isAir ?? false)

        // Verify nitrox
        let ean32 = mixes.first { $0.id == "ean32" }
        XCTAssertNotNil(ean32)
        XCTAssertTrue(ean32?.isNitrox ?? false)
        XCTAssertEqual(ean32?.o2, 0.32)

        // Verify trimix
        let tx1845 = mixes.first { $0.id == "tx1845" }
        XCTAssertNotNil(tx1845)
        XCTAssertTrue(tx1845?.isTrimix ?? false)
        XCTAssertEqual(tx1845?.o2, 0.18)
        XCTAssertEqual(tx1845?.he, 0.45)

        // Verify pure oxygen
        let o2 = mixes.first { $0.id == "o2" }
        XCTAssertNotNil(o2)
        XCTAssertEqual(o2?.o2, 1.0)

        // Validate all gas mixes
        let validation = UDDFSerialization.validate(document)
        XCTAssertTrue(validation.isValid)
    }

    func testAllSectionsFixture() throws {
        let url = fixtureURL("all_sections.uddf")
        let document = try UDDFSerialization.parse(contentsOf: url)

        // Verify all 13 sections are present
        XCTAssertNotNil(document.generator) // required
        XCTAssertNotNil(document.mediadata)
        XCTAssertNotNil(document.maker)
        XCTAssertNotNil(document.business)
        XCTAssertNotNil(document.diver)
        XCTAssertNotNil(document.divesite)
        XCTAssertNotNil(document.gasdefinitions)
        XCTAssertNotNil(document.decomodel)
        XCTAssertNotNil(document.profiledata)
        XCTAssertNotNil(document.tablegeneration)
        XCTAssertNotNil(document.divetrip)
        XCTAssertNotNil(document.divecomputercontrol)

        // Verify each section has content
        XCTAssertEqual(document.mediadata?.image?.count, 1)
        XCTAssertEqual(document.maker?.count, 1)
        XCTAssertEqual(document.business?.count, 1)
        XCTAssertEqual(document.diver?.owner?.count, 1)
        XCTAssertEqual(document.divesite?.count, 1)
        XCTAssertEqual(document.gasdefinitions?.mix?.count, 1)
        XCTAssertEqual(document.decomodel?.buehlmann?.count, 1)
        XCTAssertEqual(document.profiledata?.repetitiongroup?.count, 1)
        XCTAssertEqual(document.divetrip?.count, 1)

        // Validate
        let validation = UDDFSerialization.validate(document)
        XCTAssertTrue(validation.isValid)
    }

    // MARK: - Invalid Fixture Tests

    func testMissingGeneratorFixture() throws {
        let url = fixtureURL("invalid/missing_generator.uddf")

        // Should throw during parsing (generator is required)
        XCTAssertThrowsError(try UDDFSerialization.parse(contentsOf: url)) { error in
            // XMLCoder will throw a decoding error for missing required field
            XCTAssertTrue(error is DecodingError || error is UDDFError, "Expected DecodingError or UDDFError, got: \(type(of: error))")
        }
    }

    func testBadXMLFixture() throws {
        let url = fixtureURL("invalid/bad_xml.uddf")

        // Should throw during parsing
        XCTAssertThrowsError(try UDDFSerialization.parse(contentsOf: url)) { error in
            guard case UDDFError.invalidXML = error else {
                XCTFail("Expected invalidXML error")
                return
            }
        }
    }

    func testUnresolvedReferenceFixture() throws {
        let url = fixtureURL("invalid/unresolved_reference.uddf")

        // Parsing should succeed
        let document = try UDDFSerialization.parse(contentsOf: url)
        XCTAssertNotNil(document)

        // Document structure is valid
        XCTAssertEqual(document.diver?.owner?.count, 1)
        XCTAssertEqual(document.profiledata?.repetitiongroup?.count, 2)

        // Validation should pass (basic structure is fine)
        let validation = UDDFSerialization.validate(document)
        XCTAssertTrue(validation.isValid)
    }

    // MARK: - Round-Trip Tests

    func testRoundTripMinimal() throws {
        let url = fixtureURL("minimal.uddf")
        let original = try UDDFSerialization.parse(contentsOf: url)

        // Write and re-parse
        let xmlData = try UDDFSerialization.write(original)
        let reparsed = try UDDFSerialization.parse(xmlData)

        // Should be identical
        XCTAssertEqual(reparsed.version, original.version)
        XCTAssertEqual(reparsed.generator.name, original.generator.name)
        XCTAssertEqual(reparsed.generator.version, original.generator.version)
    }

    func testRoundTripFullProfile() throws {
        let url = fixtureURL("full_profile.uddf")
        let original = try UDDFSerialization.parse(contentsOf: url)

        // Write and re-parse
        let xmlData = try UDDFSerialization.write(original)
        let reparsed = try UDDFSerialization.parse(xmlData)

        // Verify key data preserved
        XCTAssertEqual(reparsed.generator.name, original.generator.name)
        XCTAssertEqual(reparsed.diver?.owner?.count, original.diver?.owner?.count)
        XCTAssertEqual(reparsed.divesite?.count, original.divesite?.count)
        XCTAssertEqual(reparsed.gasdefinitions?.mix?.count, original.gasdefinitions?.mix?.count)

        let originalDive = original.profiledata?.repetitiongroup?.first?.dive?.first
        let reparsedDive = reparsed.profiledata?.repetitiongroup?.first?.dive?.first

        XCTAssertEqual(reparsedDive?.id, originalDive?.id)
        XCTAssertEqual(
            reparsedDive?.informationafterdive?.greatestdepth?.meters,
            originalDive?.informationafterdive?.greatestdepth?.meters
        )
        XCTAssertEqual(
            reparsedDive?.samples?.waypoint?.count,
            originalDive?.samples?.waypoint?.count
        )
    }

    func testRoundTripAllSections() throws {
        let url = fixtureURL("all_sections.uddf")
        let original = try UDDFSerialization.parse(contentsOf: url)

        // Write and re-parse
        let xmlData = try UDDFSerialization.write(original)
        let reparsed = try UDDFSerialization.parse(xmlData)

        // All sections should still be present
        XCTAssertNotNil(reparsed.mediadata)
        XCTAssertNotNil(reparsed.maker)
        XCTAssertNotNil(reparsed.business)
        XCTAssertNotNil(reparsed.diver)
        XCTAssertNotNil(reparsed.divesite)
        XCTAssertNotNil(reparsed.gasdefinitions)
        XCTAssertNotNil(reparsed.decomodel)
        XCTAssertNotNil(reparsed.profiledata)
        XCTAssertNotNil(reparsed.tablegeneration)
        XCTAssertNotNil(reparsed.divetrip)
        XCTAssertNotNil(reparsed.divecomputercontrol)
    }
}
