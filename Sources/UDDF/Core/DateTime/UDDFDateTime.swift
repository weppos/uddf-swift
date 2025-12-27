import Foundation

/// UDDF date/time with optional timezone support
///
/// UDDF uses ISO 8601 format for dates and times. This type wraps Foundation's
/// Date and optionally preserves timezone information.
public struct UDDFDateTime: Codable, Equatable, Hashable {
    /// The date and time
    public var date: Date

    /// Optional timezone (if specified in the UDDF file)
    public var timezone: TimeZone?

    public init(date: Date, timezone: TimeZone? = nil) {
        self.date = date
        self.timezone = timezone
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        // Try ISO 8601 with timezone first
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let parsedDate = formatter.date(from: dateString) {
            self.date = parsedDate
            self.timezone = extractTimezone(from: dateString)
            return
        }

        // Try without fractional seconds
        formatter.formatOptions = [.withInternetDateTime]
        if let parsedDate = formatter.date(from: dateString) {
            self.date = parsedDate
            self.timezone = extractTimezone(from: dateString)
            return
        }

        // Try just date (no time)
        formatter.formatOptions = [.withFullDate]
        if let parsedDate = formatter.date(from: dateString) {
            self.date = parsedDate
            self.timezone = nil
            return
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Invalid date format: \(dateString). Expected ISO 8601 format."
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        if let tz = timezone {
            formatter.timeZone = tz
        }

        let dateString = formatter.string(from: date)
        try container.encode(dateString)
    }

    // MARK: - Private Helpers

    private func extractTimezone(from dateString: String) -> TimeZone? {
        // Extract timezone from ISO 8601 string
        // Examples:
        //   2025-12-27T14:00:00Z -> UTC
        //   2025-12-27T14:00:00+01:00 -> GMT+1
        //   2025-12-27T14:00:00-05:00 -> GMT-5

        if dateString.hasSuffix("Z") {
            return TimeZone(identifier: "UTC")
        }

        // Look for +/- timezone offset
        let patterns = [
            #"([+-]\d{2}:\d{2})$"#,
            #"([+-]\d{4})$"#
        ]

        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(
                in: dateString,
                range: NSRange(dateString.startIndex..., in: dateString)
               ) {
                let offsetString = String(dateString[Range(match.range, in: dateString)!])

                // Parse offset
                let cleanOffset = offsetString.replacingOccurrences(of: ":", with: "")
                if let hours = Int(cleanOffset.prefix(3)),
                   let minutes = Int(cleanOffset.suffix(2)) {
                    let totalSeconds = (hours * 3600) + (minutes * 60)
                    return TimeZone(secondsFromGMT: totalSeconds)
                }
            }
        }

        return nil
    }
}

// MARK: - Comparable

extension UDDFDateTime: Comparable {
    public static func < (lhs: UDDFDateTime, rhs: UDDFDateTime) -> Bool {
        lhs.date < rhs.date
    }
}

// MARK: - CustomStringConvertible

extension UDDFDateTime: CustomStringConvertible {
    public var description: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        if let tz = timezone {
            formatter.timeZone = tz
        }
        return formatter.string(from: date)
    }
}
