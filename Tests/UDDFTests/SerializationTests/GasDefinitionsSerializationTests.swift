import XCTest
@testable import UDDF

final class GasDefinitionsSerializationTests: XCTestCase {

    func testRoundTrip() throws {
        let generator = Generator(name: "TestApp")
        let gasDefs = GasDefinitions(mix: [
            Mix(id: "back", name: "Air", o2: 0.21, usage: .bottom),
            Mix(id: "deco1", name: "EAN50", o2: 0.5, usage: .deco),
            Mix(id: "diluent", name: "Air", o2: 0.21, usage: .diluent),
            Mix(id: "o2", name: "Oxygen", o2: 1.0, usage: .oxygen),
            Mix(id: "sm1", name: "EAN32", o2: 0.32, usage: .sidemount),
            Mix(id: "bo", name: "EAN32", o2: 0.32, usage: .bailout),
            Mix(id: "nousage", name: "Air", o2: 0.21)
        ])

        var document = UDDFDocument(version: "3.2.1", generator: generator)
        document.gasdefinitions = gasDefs

        let xmlData = try UDDFSerialization.write(document, prettyPrinted: true)
        let reparsed = try UDDFSerialization.parse(xmlData)

        XCTAssertEqual(reparsed.gasdefinitions?.mix?.count, 7)

        let reparsedBottom = reparsed.gasdefinitions?.mix?.first { $0.id == "back" }
        XCTAssertEqual(reparsedBottom?.usage, .bottom)

        let reparsedDeco = reparsed.gasdefinitions?.mix?.first { $0.id == "deco1" }
        XCTAssertEqual(reparsedDeco?.usage, .deco)

        let reparsedDiluent = reparsed.gasdefinitions?.mix?.first { $0.id == "diluent" }
        XCTAssertEqual(reparsedDiluent?.usage, .diluent)

        let reparsedOxygen = reparsed.gasdefinitions?.mix?.first { $0.id == "o2" }
        XCTAssertEqual(reparsedOxygen?.usage, .oxygen)

        let reparsedSidemount = reparsed.gasdefinitions?.mix?.first { $0.id == "sm1" }
        XCTAssertEqual(reparsedSidemount?.usage, .sidemount)

        let reparsedBailout = reparsed.gasdefinitions?.mix?.first { $0.id == "bo" }
        XCTAssertEqual(reparsedBailout?.usage, .bailout)

        let reparsedNoUsage = reparsed.gasdefinitions?.mix?.first { $0.id == "nousage" }
        XCTAssertNil(reparsedNoUsage?.usage)
    }
}
