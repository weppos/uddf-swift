import Foundation

/// Volume measurement with automatic unit conversion
///
/// UDDF stores volumes in cubic meters (m³). This type provides automatic conversion
/// to liters and cubic feet.
///
/// - SeeAlso: UDDF 3.2.1 specification for volume units
public struct Volume: Codable, Equatable, Hashable, Sendable {
    /// Volume in cubic meters (UDDF standard unit)
    ///
    /// - Unit: m³ (cubic meters)
    public var cubicMeters: Double

    /// Creates a volume from cubic meters
    ///
    /// - Parameter cubicMeters: Volume in cubic meters (m³)
    public init(cubicMeters: Double) {
        self.cubicMeters = cubicMeters
    }

    /// Creates a volume from liters
    ///
    /// - Parameter liters: Volume in liters (L)
    public init(liters: Double) {
        // 1 liter = 0.001 m³
        self.cubicMeters = liters / 1000
    }

    /// Creates a volume from cubic feet
    ///
    /// - Parameter cubicFeet: Volume in cubic feet (ft³)
    public init(cubicFeet: Double) {
        // 1 cubic foot = 0.0283168 m³
        self.cubicMeters = cubicFeet * 0.0283168
    }

    /// Volume in liters
    ///
    /// - Unit: L (liters)
    public var liters: Double {
        cubicMeters * 1000
    }

    /// Volume in cubic feet
    ///
    /// - Unit: ft³ (cubic feet)
    public var cubicFeet: Double {
        cubicMeters / 0.0283168
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        cubicMeters = try container.decode(Double.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(cubicMeters)
    }
}

// MARK: - Comparable

extension Volume: Comparable {
    public static func < (lhs: Volume, rhs: Volume) -> Bool {
        lhs.cubicMeters < rhs.cubicMeters
    }
}

// MARK: - CustomStringConvertible

extension Volume: CustomStringConvertible {
    public var description: String {
        "\(liters) L"
    }
}
