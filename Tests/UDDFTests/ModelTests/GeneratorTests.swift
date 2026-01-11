import XCTest
@testable import UDDF

final class GeneratorTests: XCTestCase {

    // MARK: - GeneratorType Tests

    func testGeneratorTypeRawValues() {
        XCTAssertEqual(GeneratorType.converter.rawValue, "converter")
        XCTAssertEqual(GeneratorType.divecomputer.rawValue, "divecomputer")
        XCTAssertEqual(GeneratorType.logbook.rawValue, "logbook")
        XCTAssertEqual(GeneratorType.unknown("custom").rawValue, "custom")
    }

    func testGeneratorTypeInitFromRawValue() {
        XCTAssertEqual(GeneratorType(rawValue: "converter"), .converter)
        XCTAssertEqual(GeneratorType(rawValue: "divecomputer"), .divecomputer)
        XCTAssertEqual(GeneratorType(rawValue: "logbook"), .logbook)
        XCTAssertEqual(GeneratorType(rawValue: "custom"), .unknown("custom"))
    }

    func testGeneratorTypeIsStandard() {
        XCTAssertTrue(GeneratorType.converter.isStandard)
        XCTAssertTrue(GeneratorType.divecomputer.isStandard)
        XCTAssertTrue(GeneratorType.logbook.isStandard)
        XCTAssertFalse(GeneratorType.unknown("custom").isStandard)
    }
}
