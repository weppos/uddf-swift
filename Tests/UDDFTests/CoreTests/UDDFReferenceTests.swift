import XCTest
@testable import UDDF

final class UDDFReferenceTests: XCTestCase {
    private struct DummyElement: Codable, Equatable {
        let id: String
    }

    func testUDDFReferenceCodableRoundTrip() throws {
        let reference = UDDFReference<DummyElement>(ref: "mix-1")
        let data = try JSONEncoder().encode(reference)
        let decoded = try JSONDecoder().decode(UDDFReference<DummyElement>.self, from: data)

        XCTAssertEqual(decoded.ref, "mix-1")
    }

    func testResolvedReferenceInlineProperties() {
        let inline = ResolvedReference.inline(DummyElement(id: "mix-1"))

        XCTAssertEqual(inline.value, DummyElement(id: "mix-1"))
        XCTAssertTrue(inline.isResolved)
        XCTAssertNil(inline.referenceID)
    }

    func testResolvedReferenceResolvedProperties() {
        let resolved = ResolvedReference.reference(id: "mix-1", resolved: DummyElement(id: "mix-1"))

        XCTAssertEqual(resolved.value, DummyElement(id: "mix-1"))
        XCTAssertTrue(resolved.isResolved)
        XCTAssertEqual(resolved.referenceID, "mix-1")
    }

    func testResolvedReferenceUnresolvedProperties() {
        let unresolved = ResolvedReference<DummyElement>.reference(id: "mix-1", resolved: nil)

        XCTAssertNil(unresolved.value)
        XCTAssertFalse(unresolved.isResolved)
        XCTAssertEqual(unresolved.referenceID, "mix-1")
    }
}
