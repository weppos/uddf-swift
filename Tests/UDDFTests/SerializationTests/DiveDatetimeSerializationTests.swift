import XCTest
@testable import UDDF

/// Tests that the dive timezone offset survives serialization
/// of `InformationBeforeDive.datetime` (which uses `UDDFDateTime`).
final class DiveDatetimeSerializationTests: XCTestCase {

    private func makeDocument(datetime: UDDFDateTime?) -> UDDFDocument {
        let dive = Dive(
            id: "dive1",
            informationbeforedive: InformationBeforeDive(datetime: datetime)
        )
        let repetitionGroup = RepetitionGroup(dive: [dive])
        let profileData = ProfileData(repetitiongroup: [repetitionGroup])

        var document = UDDFDocument(
            version: "3.2.1",
            generator: Generator(name: "TestApp")
        )
        document.profiledata = profileData
        return document
    }

    private func writtenXML(for document: UDDFDocument) throws -> String {
        let data = try UDDFSerialization.write(document, prettyPrinted: true)
        return String(data: data, encoding: .utf8) ?? ""
    }

    // MARK: - Encoding

    func testEncodeDatetimeWithPositiveOffset() throws {
        let tz = TimeZone(secondsFromGMT: 2 * 3600)!  // +02:00
        let components = DateComponents(
            timeZone: tz,
            year: 2024, month: 3, day: 5, hour: 10, minute: 0, second: 0
        )
        let date = Calendar(identifier: .gregorian).date(from: components)!

        let document = makeDocument(datetime: UDDFDateTime(date: date, timezone: tz))
        let xml = try writtenXML(for: document)

        XCTAssertTrue(
            xml.contains("<datetime>2024-03-05T10:00:00+02:00</datetime>") ||
            xml.contains("<datetime>2024-03-05T10:00:00+0200</datetime>"),
            "Expected the +02:00 offset in <datetime>, got XML:\n\(xml)"
        )
    }

    func testEncodeDatetimeWithNegativeOffset() throws {
        let tz = TimeZone(secondsFromGMT: -5 * 3600)!  // -05:00
        let components = DateComponents(
            timeZone: tz,
            year: 2024, month: 7, day: 15, hour: 14, minute: 30, second: 0
        )
        let date = Calendar(identifier: .gregorian).date(from: components)!

        let document = makeDocument(datetime: UDDFDateTime(date: date, timezone: tz))
        let xml = try writtenXML(for: document)

        XCTAssertTrue(
            xml.contains("<datetime>2024-07-15T14:30:00-05:00</datetime>") ||
            xml.contains("<datetime>2024-07-15T14:30:00-0500</datetime>"),
            "Expected the -05:00 offset in <datetime>, got XML:\n\(xml)"
        )
    }

    func testEncodeDatetimeWithoutTimezoneEmitsUTC() throws {
        // 2024-03-05 08:00:00 UTC
        let date = Date(timeIntervalSince1970: 1709625600)

        let document = makeDocument(datetime: UDDFDateTime(date: date, timezone: nil))
        let xml = try writtenXML(for: document)

        XCTAssertTrue(
            xml.contains("<datetime>2024-03-05T08:00:00Z</datetime>"),
            "Expected UTC Z suffix when timezone is nil, got XML:\n\(xml)"
        )
    }

    // MARK: - Decoding

    func testDecodeDatetimeWithPositiveOffsetPreservesTimezone() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <uddf version="3.2.1">
            <generator><name>TestApp</name></generator>
            <profiledata>
                <repetitiongroup id="rg1">
                    <dive id="dive1">
                        <informationbeforedive>
                            <datetime>2024-03-05T10:00:00+02:00</datetime>
                        </informationbeforedive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """
        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)
        let datetime = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive?.datetime

        XCTAssertNotNil(datetime)
        XCTAssertEqual(datetime?.timezone?.secondsFromGMT(), 2 * 3600)
    }

    func testDecodeDatetimeWithZSuffix() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <uddf version="3.2.1">
            <generator><name>TestApp</name></generator>
            <profiledata>
                <repetitiongroup id="rg1">
                    <dive id="dive1">
                        <informationbeforedive>
                            <datetime>2024-03-05T08:00:00Z</datetime>
                        </informationbeforedive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """
        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)
        let datetime = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive?.datetime

        XCTAssertNotNil(datetime)
        // Both "UTC" and "GMT" are valid identifiers for the same zero-offset
        // timezone depending on Foundation version.
        XCTAssertEqual(datetime?.timezone?.secondsFromGMT(), 0)
    }

    /// Older versions of this library wrote `<datetime>` without any
    /// timezone suffix when `UDDFDateFormat.local` was used. Make sure
    /// such files still parse so consumers can migrate gradually.
    func testDecodeLegacyOffsetlessDatetime() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <uddf version="3.2.1">
            <generator><name>TestApp</name></generator>
            <profiledata>
                <repetitiongroup id="rg1">
                    <dive id="dive1">
                        <informationbeforedive>
                            <datetime>2024-03-05T10:00:00</datetime>
                        </informationbeforedive>
                    </dive>
                </repetitiongroup>
            </profiledata>
        </uddf>
        """
        let data = xml.data(using: .utf8)!
        let document = try UDDFSerialization.parse(data)
        let datetime = document.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive?.datetime

        XCTAssertNotNil(datetime)
        XCTAssertNil(datetime?.timezone)
    }

    // MARK: - Round-trip

    func testRoundTripPreservesOffset() throws {
        let tz = TimeZone(secondsFromGMT: 5 * 3600 + 30 * 60)!  // +05:30 (India)
        let components = DateComponents(
            timeZone: tz,
            year: 2024, month: 11, day: 2, hour: 7, minute: 15, second: 0
        )
        let date = Calendar(identifier: .gregorian).date(from: components)!

        let original = UDDFDateTime(date: date, timezone: tz)
        let document = makeDocument(datetime: original)
        let data = try UDDFSerialization.write(document)
        let reparsed = try UDDFSerialization.parse(data)
        let reparsedDatetime = reparsed.profiledata?.repetitiongroup?.first?.dive?.first?.informationbeforedive?.datetime

        XCTAssertNotNil(reparsedDatetime)
        XCTAssertEqual(reparsedDatetime?.timezone?.secondsFromGMT(), tz.secondsFromGMT())
        // The absolute instant should also survive the round-trip.
        XCTAssertEqual(reparsedDatetime?.date.timeIntervalSince1970 ?? -1, date.timeIntervalSince1970, accuracy: 1.0)
    }
}
