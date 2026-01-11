import Foundation

/// Altitude measurement with automatic unit conversion
///
/// UDDF stores altitude in meters above sea level. This type provides automatic
/// conversion to feet and other common altitude units.
///
/// - SeeAlso: UDDF 3.2.1 specification for altitude units
public struct Altitude: Codable, Equatable, Hashable, Sendable {
    /// Altitude in meters (UDDF standard unit)
    ///
    /// - Unit: m (meters above sea level)
    public var meters: Double

    /// Creates an altitude from meters
    ///
    /// - Parameter meters: Altitude in meters above sea level
    public init(meters: Double) {
        self.meters = meters
    }

    /// Creates an altitude from feet
    ///
    /// - Parameter feet: Altitude in feet above sea level
    public init(feet: Double) {
        // 1 foot = 0.3048 meters
        self.meters = feet * 0.3048
    }

    /// Altitude in feet
    ///
    /// - Unit: ft (feet above sea level)
    public var feet: Double {
        meters / 0.3048
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        meters = try container.decode(Double.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(meters)
    }
}

// MARK: - Comparable

extension Altitude: Comparable {
    public static func < (lhs: Altitude, rhs: Altitude) -> Bool {
        lhs.meters < rhs.meters
    }
}

// MARK: - CustomStringConvertible

extension Altitude: CustomStringConvertible {
    public var description: String {
        "\(meters)m"
    }
}
