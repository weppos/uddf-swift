import XCTest
@testable import UDDF

final class ValidationTests: XCTestCase {
    // MARK: - Basic Validation Tests

    func testValidMinimalDocument() throws {
        let document = makeDocument()

        let result = UDDFSerialization.validate(document)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.errors.count, 0)
    }

    func testMissingGeneratorNameProducesWarning() throws {
        var document = makeDocument(name: "TestApp")

        document.generator.name = nil

        let result = UDDFSerialization.validate(document)

        // Should be valid with warning in default mode
        XCTAssertTrue(result.isValid)
        XCTAssertTrue(result.hasWarnings)
        XCTAssertTrue(result.warnings.contains { $0.field == "generator.name" })
    }

    func testEmptyGeneratorNameProducesWarning() throws {
        var document = makeDocument(name: "TestApp")

        document.generator.name = ""

        let result = UDDFSerialization.validate(document)

        // Should be valid with warning in default mode
        XCTAssertTrue(result.isValid)
        XCTAssertTrue(result.hasWarnings)
        XCTAssertTrue(result.warnings.contains { $0.field == "generator.name" })
    }

    func testMissingGeneratorNameBecomesErrorInStrictMode() throws {
        var document = makeDocument(name: "TestApp")

        document.generator.name = nil

        var options = UDDFValidator.Options()
        options.strictMode = true

        let result = UDDFSerialization.validate(document, options: options)

        // Should fail in strict mode
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.errors.contains { $0.field == "generator.name" })
    }

    // MARK: - Depth Validation Tests

    func testInvalidNegativeDepth() throws {
        let dive = Dive(
            id: "dive1",
            informationafterdive: InformationAfterDive(
                greatestdepth: Depth(meters: -5)
            )
        )

        let document = makeDocument(dive: dive)

        let result = UDDFSerialization.validate(document)

        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.errors.contains { $0.message.contains("negative") })
    }

    func testValidDepthRange() throws {
        let dive = Dive(
            id: "dive1",
            informationafterdive: InformationAfterDive(
                averagedepth: Depth(meters: 15),
                greatestdepth: Depth(meters: 30)
            )
        )

        let document = makeDocument(dive: dive)

        let result = UDDFSerialization.validate(document)

        XCTAssertTrue(result.isValid)
    }

    // MARK: - Gas Mix Validation Tests

    func testInvalidGasPercentage() throws {
        let invalidMix = Mix(id: "bad", name: "Invalid", o2: 1.5, n2: 0.5)

        let document = makeDocument(gasMixes: [invalidMix])

        let result = UDDFSerialization.validate(document)

        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.errors.contains { $0.message.contains("between 0 and 1") })
    }

    func testGasMixPercentageWarning() throws {
        let mix = Mix(id: "test", name: "Test", o2: 0.21, n2: 0.70) // Total = 0.91

        let document = makeDocument(gasMixes: [mix])

        let result = UDDFSerialization.validate(document)

        XCTAssertTrue(result.isValid) // Still valid (just a warning)
        XCTAssertTrue(result.hasWarnings)
        XCTAssertTrue(result.warnings.contains { $0.message.contains("sum to 1.0") })
    }

    // MARK: - GPS Validation Tests

    func testInvalidLatitude() throws {
        let site = DiveSite(
            id: "site1",
            geography: Geography(
                gps: GPS(latitude: 95.0, longitude: 0.0)
            )
        )

        let document = makeDocument(diveSites: [site])

        let result = UDDFSerialization.validate(document)

        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.errors.contains { $0.message.contains("Latitude") })
    }

    func testInvalidLongitude() throws {
        let site = DiveSite(
            id: "site1",
            geography: Geography(
                gps: GPS(latitude: 0.0, longitude: 200.0)
            )
        )

        let document = makeDocument(diveSites: [site])

        let result = UDDFSerialization.validate(document)

        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.errors.contains { $0.message.contains("Longitude") })
    }

    func testValidGPS() throws {
        let site = DiveSite(
            id: "site1",
            geography: Geography(
                gps: GPS(latitude: 28.0, longitude: 34.0)
            )
        )

        let document = makeDocument(diveSites: [site])

        let result = UDDFSerialization.validate(document)

        XCTAssertTrue(result.isValid)
    }

    // MARK: - ID Validation Tests

    func testEmptyIDError() throws {
        var document = makeDocument(diver: Diver(owner: Owner(id: "owner1")))

        document.diver?.owner?.id = ""

        let result = UDDFSerialization.validate(document)

        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.errors.contains { $0.message.contains("ID cannot be empty") })
    }

    // MARK: - Reference Validation Tests

    func testValidReferences() throws {
        let owner = Owner(id: "owner1", personal: Personal(firstname: "John"))

        let document = makeDocument(diver: Diver(owner: owner))

        let result = UDDFSerialization.validate(document)

        XCTAssertTrue(result.isValid)
    }

    // MARK: - Validation Options Tests

    func testStrictMode() throws {
        let mix = Mix(id: "test", name: "Test", o2: 0.21, n2: 0.70) // Total = 0.91

        let document = makeDocument(gasMixes: [mix])

        var options = UDDFValidator.Options()
        options.strictMode = true

        let result = UDDFSerialization.validate(document, options: options)

        // In strict mode, warnings become errors
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.errors.contains { $0.message.contains("sum to 1.0") })
    }

    func testDisableRangeValidation() throws {
        let dive = Dive(
            id: "dive1",
            informationafterdive: InformationAfterDive(
                greatestdepth: Depth(meters: -5)
            )
        )

        let document = makeDocument(dive: dive)

        var options = UDDFValidator.Options()
        options.validateRanges = false

        let result = UDDFSerialization.validate(document, options: options)

        // With range validation disabled, negative depth is allowed
        XCTAssertTrue(result.isValid)
    }

    // MARK: - Parse and Validate Tests

    func testParseAndValidate() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
        </uddf>
        """

        let (document, validation) = try UDDFSerialization.parseAndValidate(xml.data(using: .utf8)!)

        XCTAssertEqual(document.generator.name, "TestApp")
        XCTAssertTrue(validation.isValid)
    }

    private func makeDocument(
        name: String? = "TestApp",
        version: String? = "1.0.0",
        diver: Diver? = nil,
        diveSites: [DiveSite]? = nil,
        gasMixes: [Mix]? = nil,
        dive: Dive? = nil
    ) -> UDDFDocument {
        var document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(name: name, version: version)
        )
        document.diver = diver
        document.divesite = diveSites
        document.gasdefinitions = gasMixes.map { GasDefinitions(mix: $0) }
        document.profiledata = dive.map { ProfileData(repetitiongroup: [RepetitionGroup(dive: [$0])]) }
        return document
    }
}
