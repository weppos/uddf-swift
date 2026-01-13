import XCTest
@testable import UDDF

final class DecoModelSerializationTests: XCTestCase {

    func testRoundTrip() throws {
        // Generate unique IDs for each parameter set
        let buehlmannId1 = UUID().uuidString
        let buehlmannId2 = UUID().uuidString
        let vpmId = UUID().uuidString

        // Create first Bühlmann parameter set (conservative GF 30/70)
        let buehlmann1 = Buehlmann(
            id: buehlmannId1,
            tissue: [
                Tissue(gas: .n2, number: 1, halflife: 300, a: 1.1696, b: 0.5578),
                Tissue(gas: .n2, number: 2, halflife: 480, a: 1.0, b: 0.6514),
            ],
            gradientfactorlow: 0.3,
            gradientfactorhigh: 0.7
        )

        // Create second Bühlmann parameter set (aggressive GF 50/90)
        let buehlmann2 = Buehlmann(
            id: buehlmannId2,
            tissue: [
                Tissue(gas: .n2, number: 1, halflife: 300, a: 1.1696, b: 0.5578),
            ],
            gradientfactorlow: 0.5,
            gradientfactorhigh: 0.9
        )

        // Create VPM-B parameter set
        let vpm = VPM(
            id: vpmId,
            conservatism: 1.0,
            gamma: 0.0179,
            gc: 0.0114,
            lambda: 7500.0,
            r0: 0.8,
            tissue: [
                Tissue(gas: .n2, number: 1, halflife: 300, a: 1.1696, b: 0.5578),
            ]
        )

        // Build document with multiple parameter sets
        var document = UDDFDocument(
            generator: Generator(
                name: "DecoPlanner",
                manufacturer: Manufacturer(id: "decoplanner", name: "DecoPlanner Software")
            )
        )
        document.decomodel = DecoModel(
            buehlmann: [buehlmann1, buehlmann2],
            vpm: [vpm]
        )

        // Write to XML
        let data = try UDDFSerialization.write(document)

        // Verify XML structure contains multiple buehlmann elements
        let xmlString = String(data: data, encoding: .utf8)!
        XCTAssertTrue(xmlString.contains("<buehlmann id=\"\(buehlmannId1)\""))
        XCTAssertTrue(xmlString.contains("<buehlmann id=\"\(buehlmannId2)\""))
        XCTAssertTrue(xmlString.contains("<vpm id=\"\(vpmId)\""))

        // Parse back and verify
        let parsed = try UDDFSerialization.parse(data)

        // Verify we got all parameter sets back
        XCTAssertEqual(parsed.decomodel?.buehlmann?.count, 2)
        XCTAssertEqual(parsed.decomodel?.vpm?.count, 1)
        XCTAssertNil(parsed.decomodel?.rgbm)

        // Verify first Bühlmann parameter set
        let parsedBuehlmann1 = parsed.decomodel?.buehlmann?.first { $0.id == buehlmannId1 }
        XCTAssertNotNil(parsedBuehlmann1)
        XCTAssertEqual(parsedBuehlmann1?.gradientfactorlow, 0.3)
        XCTAssertEqual(parsedBuehlmann1?.gradientfactorhigh, 0.7)
        XCTAssertEqual(parsedBuehlmann1?.tissue?.count, 2)

        // Verify second Bühlmann parameter set
        let parsedBuehlmann2 = parsed.decomodel?.buehlmann?.first { $0.id == buehlmannId2 }
        XCTAssertNotNil(parsedBuehlmann2)
        XCTAssertEqual(parsedBuehlmann2?.gradientfactorlow, 0.5)
        XCTAssertEqual(parsedBuehlmann2?.gradientfactorhigh, 0.9)
        XCTAssertEqual(parsedBuehlmann2?.tissue?.count, 1)

        // Verify VPM parameter set
        let parsedVPM = parsed.decomodel?.vpm?.first
        XCTAssertEqual(parsedVPM?.id, vpmId)
        XCTAssertEqual(parsedVPM?.conservatism, 1.0)
        XCTAssertEqual(parsedVPM?.gamma, 0.0179)
    }
}
