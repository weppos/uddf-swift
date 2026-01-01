import Foundation

/// Time duration in seconds
///
/// UDDF stores durations in seconds. This type provides convenient
/// conversion to minutes and hours.
public struct Duration: Codable, Equatable, Hashable, Sendable {
    /// Duration in seconds (UDDF standard unit)
    public var seconds: Double

    public init(seconds: Double) {
        self.seconds = seconds
    }

    public init(minutes: Double) {
        self.seconds = minutes * 60
    }

    public init(hours: Double) {
        self.seconds = hours * 3600
    }

    /// Duration in minutes
    public var minutes: Double {
        seconds / 60
    }

    /// Duration in hours
    public var hours: Double {
        seconds / 3600
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        seconds = try container.decode(Double.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(seconds)
    }
}

// MARK: - Comparable

extension Duration: Comparable {
    public static func < (lhs: Duration, rhs: Duration) -> Bool {
        lhs.seconds < rhs.seconds
    }
}

// MARK: - CustomStringConvertible

extension Duration: CustomStringConvertible {
    public var description: String {
        if seconds < 60 {
            return "\(Int(seconds))s"
        } else if seconds < 3600 {
            return "\(Int(minutes))m"
        } else {
            return "\(hours)h"
        }
    }
}
