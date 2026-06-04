import XCTest
@testable import UDDF

final class ReferenceResolutionTests: XCTestCase {
    // MARK: - Basic Resolution Tests

    func testResolveSimpleDiverReference() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>Test</name>
            </generator>
            <diver>
                <owner id="owner1">
                    <personal>
                        <firstname>John</firstname>
                        <lastname>Doe</lastname>
                    </personal>
                </owner>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let (document, result) = try UDDFSerialization.parseAndResolve(data)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.errors.count, 0)
        XCTAssertEqual(result.registry.count, 1)
        XCTAssertTrue(result.registry.keys.contains("owner1"))

        // Verify the owner was parsed correctly
        XCTAssertNotNil(document.diver?.owner)
        XCTAssertEqual(document.diver?.owner?.id, "owner1")
        XCTAssertEqual(document.diver?.owner?.personal?.firstname, "John")
    }

    func testResolveMultipleDivers() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>Test</name>
            </generator>
            <diver>
                <owner id="owner1">
                    <personal>
                        <firstname>John</firstname>
                    </personal>
                </owner>
                <buddy id="buddy1">
                    <personal>
                        <firstname>Jane</firstname>
                    </personal>
                </buddy>
                <buddy id="buddy2">
                    <personal>
                        <firstname>Bob</firstname>
                    </personal>
                </buddy>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let (_, result) = try UDDFSerialization.parseAndResolve(data)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.registry.count, 3)
        XCTAssertTrue(result.registry.keys.contains("owner1"))
        XCTAssertTrue(result.registry.keys.contains("buddy1"))
        XCTAssertTrue(result.registry.keys.contains("buddy2"))
    }

    func testResolveGasMixes() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>Test</name>
            </generator>
            <gasdefinitions>
                <mix id="air">
                    <name>Air</name>
                    <o2>0.21</o2>
                    <n2>0.79</n2>
                </mix>
                <mix id="ean32">
                    <name>EAN32</name>
                    <o2>0.32</o2>
                    <n2>0.68</n2>
                </mix>
            </gasdefinitions>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let (_, result) = try UDDFSerialization.parseAndResolve(data)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.registry.count, 2)
        XCTAssertTrue(result.registry.keys.contains("air"))
        XCTAssertTrue(result.registry.keys.contains("ean32"))
    }

    func testResolveDiveSites() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>Test</name>
            </generator>
            <divesite id="site1">
                <name>Blue Hole</name>
                <geography>
                    <location>Red Sea</location>
                </geography>
            </divesite>
            <divesite id="site2">
                <name>Wreck Dive</name>
            </divesite>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let (_, result) = try UDDFSerialization.parseAndResolve(data)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.registry.count, 2)
        XCTAssertTrue(result.registry.keys.contains("site1"))
        XCTAssertTrue(result.registry.keys.contains("site2"))
    }

    func testResolveDivesAndRepetitionGroups() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>Test</name>
            </generator>
            <profiledata>
                <repetitiongroup id="rg1">
                    <dive id="dive1">
                        <informationafterdive>
                            <greatestdepth>20</greatestdepth>
                        </informationafterdive>
                    </dive>
                    <dive id="dive2">
                        <informationafterdive>
                            <greatestdepth>15</greatestdepth>
                        </informationafterdive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let (_, result) = try UDDFSerialization.parseAndResolve(data)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.registry.count, 3)
        XCTAssertTrue(result.registry.keys.contains("rg1"))
        XCTAssertTrue(result.registry.keys.contains("dive1"))
        XCTAssertTrue(result.registry.keys.contains("dive2"))
    }

    // MARK: - Error Detection Tests

    func testDetectDuplicateID() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>Test</name>
            </generator>
            <diver>
                <owner id="diver1">
                    <personal>
                        <firstname>John</firstname>
                    </personal>
                </owner>
                <buddy id="diver1">
                    <personal>
                        <firstname>Jane</firstname>
                    </personal>
                </buddy>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!

        XCTAssertThrowsError(try UDDFSerialization.parseAndResolve(data)) { error in
            guard case UDDFError.duplicateID(let id) = error else {
                XCTFail("Expected duplicateID error, got \(error)")
                return
            }
            XCTAssertEqual(id, "diver1")
        }
    }

    func testDetectUnresolvedReference() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>Test</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive>
                        <informationafterdive>
                            <notes>
                                <link ref="nonexistent"/>
                            </notes>
                        </informationafterdive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!

        XCTAssertThrowsError(try UDDFSerialization.parseAndResolve(data)) { error in
            guard case UDDFError.unresolvedReference = error else {
                XCTFail("Expected unresolvedReference error, got \(error)")
                return
            }
        }
    }

    // MARK: - Complex Resolution Tests

    func testResolveComplexDocument() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>Test</name>
            </generator>
            <diver>
                <owner id="owner1">
                    <personal>
                        <firstname>John</firstname>
                    </personal>
                </owner>
            </diver>
            <divesite id="site1">
                <name>Reef Dive</name>
            </divesite>
            <gasdefinitions>
                <mix id="air">
                    <name>Air</name>
                    <o2>0.21</o2>
                </mix>
            </gasdefinitions>
            <profiledata>
                <repetitiongroup id="trip1">
                    <dive id="dive1">
                        <informationafterdive>
                            <greatestdepth>18</greatestdepth>
                        </informationafterdive>
                    </dive>
                </repetitiongroup>
            </profiledata>
            <mediadata>
                <image id="photo1">
                    <title>Underwater Photo</title>
                </image>
            </mediadata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let (_, result) = try UDDFSerialization.parseAndResolve(data)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.registry.count, 6)

        // Verify all IDs are registered
        XCTAssertTrue(result.registry.keys.contains("owner1"))
        XCTAssertTrue(result.registry.keys.contains("site1"))
        XCTAssertTrue(result.registry.keys.contains("air"))
        XCTAssertTrue(result.registry.keys.contains("trip1"))
        XCTAssertTrue(result.registry.keys.contains("dive1"))
        XCTAssertTrue(result.registry.keys.contains("photo1"))
    }

    // MARK: - Resolver Query Tests

    func testResolverContainsMethod() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>Test</name>
            </generator>
            <diver>
                <owner id="owner1">
                    <personal>
                        <firstname>John</firstname>
                    </personal>
                </owner>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let resolver = ReferenceResolver()
        _ = try resolver.resolve(document)

        XCTAssertTrue(resolver.contains(id: "owner1"))
        XCTAssertFalse(resolver.contains(id: "nonexistent"))
    }

    func testResolverAllIDsMethod() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>Test</name>
            </generator>
            <diver>
                <owner id="owner1">
                    <personal>
                        <firstname>John</firstname>
                    </personal>
                </owner>
                <buddy id="buddy1">
                    <personal>
                        <firstname>Jane</firstname>
                    </personal>
                </buddy>
            </diver>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let resolver = ReferenceResolver()
        _ = try resolver.resolve(document)

        let allIDs = resolver.allIDs
        XCTAssertEqual(allIDs.count, 2)
        XCTAssertTrue(allIDs.contains("owner1"))
        XCTAssertTrue(allIDs.contains("buddy1"))
    }

    // MARK: - Equipment & Waypoint Reference Tests

    func testResolveWaypointEquipmentReferences() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.3">
            <generator>
                <name>Test</name>
            </generator>
            <diver>
                <owner id="owner1">
                    <personal>
                        <firstname>John</firstname>
                    </personal>
                    <equipment>
                        <divecomputer id="dc1">
                            <name>Petrel</name>
                        </divecomputer>
                        <tank id="tank1">
                            <name>AL80</name>
                        </tank>
                    </equipment>
                </owner>
            </diver>
            <profiledata>
                <repetitiongroup id="rg1">
                    <dive id="dive1">
                        <samples>
                            <waypoint>
                                <depth>10.0</depth>
                                <divetime>60</divetime>
                                <batterychargecondition deviceref="dc1" tankref="tank1">3.7</batterychargecondition>
                            </waypoint>
                        </samples>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let resolver = ReferenceResolver()
        let result = try resolver.resolve(document)

        // The equipment IDs must be registered and resolve to their typed elements.
        XCTAssertTrue(result.isValid)
        XCTAssertTrue(result.registry.keys.contains("dc1"))
        XCTAssertTrue(result.registry.keys.contains("tank1"))

        if case .diveComputer(let computer)? = result.registry["dc1"] {
            XCTAssertEqual(computer.id, "dc1")
        } else {
            XCTFail("dc1 should resolve to a divecomputer")
        }

        if case .tank(let tank)? = result.registry["tank1"] {
            XCTAssertEqual(tank.id, "tank1")
        } else {
            XCTFail("tank1 should resolve to a tank")
        }

        // The waypoint references must resolve against the registered equipment.
        XCTAssertTrue(resolver.contains(id: "dc1"))
        XCTAssertTrue(resolver.contains(id: "tank1"))
    }

    func testDetectUnresolvedWaypointEquipmentReferences() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.3">
            <generator>
                <name>Test</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive>
                        <samples>
                            <waypoint>
                                <depth>10.0</depth>
                                <divetime>60</divetime>
                                <batterychargecondition deviceref="ghostdc" tankref="ghosttank">3.7</batterychargecondition>
                            </waypoint>
                        </samples>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let resolver = ReferenceResolver()
        let result = try resolver.resolve(document)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errors.count, 2)

        let locations = Set(result.errors.map(\.location))
        XCTAssertTrue(locations.contains("waypoint.batterychargecondition.deviceref"))
        XCTAssertTrue(locations.contains("waypoint.batterychargecondition.tankref"))

        let unresolved = Set(result.errors.map(\.referenceID))
        XCTAssertEqual(unresolved, ["ghostdc", "ghosttank"])
    }
}
