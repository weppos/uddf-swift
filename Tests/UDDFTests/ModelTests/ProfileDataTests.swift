import XCTest
@testable import UDDF

final class ProfileDataTests: XCTestCase {
    func testParseProfileData() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <profiledata>
                <repetitiongroup id="rg1">
                    <dive id="dive1">
                        <informationafterdive>
                            <greatestdepth>18.5</greatestdepth>
                            <diveduration>2700</diveduration>
                        </informationafterdive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        XCTAssertNotNil(document.profiledata)
        XCTAssertEqual(document.profiledata?.repetitiongroup?.count, 1)

        let dive = document.profiledata?.repetitiongroup?.first?.dive?.first
        XCTAssertNotNil(dive)
        XCTAssertEqual(dive?.id, "dive1")
        XCTAssertEqual(dive?.informationafterdive?.greatestdepth?.meters, 18.5)
        XCTAssertEqual(dive?.informationafterdive?.diveduration?.seconds, 2700)
    }

    func testParseWaypoints() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <uddf version="3.2.1">
            <generator>
                <name>TestApp</name>
            </generator>
            <profiledata>
                <repetitiongroup>
                    <dive>
                        <samples>
                            <waypoint>
                                <divetime>0</divetime>
                                <depth>0</depth>
                            </waypoint>
                            <waypoint>
                                <divetime>60</divetime>
                                <depth>10.5</depth>
                                <temperature>293.15</temperature>
                            </waypoint>
                        </samples>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """

        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)

        let waypoints = document.profiledata?.repetitiongroup?.first?.dive?.first?.samples?.waypoint
        XCTAssertNotNil(waypoints)
        XCTAssertEqual(waypoints?.count, 2)

        let waypoint1 = waypoints?[0]
        XCTAssertEqual(waypoint1?.divetime?.seconds, 0)
        XCTAssertEqual(waypoint1?.depth?.meters, 0)

        let waypoint2 = waypoints?[1]
        XCTAssertEqual(waypoint2?.divetime?.seconds, 60)
        XCTAssertEqual(waypoint2?.depth?.meters, 10.5)
        XCTAssertNotNil(waypoint2?.temperature)
        XCTAssertEqual(waypoint2?.temperature?.celsius ?? 0, 20, accuracy: 0.01)
    }
}
