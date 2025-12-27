import Foundation

/// Depth measurement with automatic unit conversion
///
/// UDDF stores depths in meters. This type provides automatic conversion
/// to feet and other common depth units.
public struct UDDFDepth: Codable, Equatable, Hashable {
    /// Depth in meters (UDDF standard unit)
    public var meters: Double

    public init(meters: Double) {
        self.meters = meters
    }

    public init(feet: Double) {
        self.meters = feet / 3.28084
    }

    /// Depth in feet
    public var feet: Double {
        meters * 3.28084
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

extension UDDFDepth: Comparable {
    public static func < (lhs: UDDFDepth, rhs: UDDFDepth) -> Bool {
        lhs.meters < rhs.meters
    }
}

// MARK: - CustomStringConvertible

extension UDDFDepth: CustomStringConvertible {
    public var description: String {
        "\(meters)m"
    }
}
