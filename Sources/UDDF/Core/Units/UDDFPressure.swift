import Foundation

/// Pressure measurement with automatic unit conversion
///
/// UDDF stores pressure in bar. This type provides automatic conversion
/// to PSI and other common pressure units.
public struct UDDFPressure: Codable, Equatable, Hashable {
    /// Pressure in bar (UDDF standard unit)
    public var bar: Double

    public init(bar: Double) {
        self.bar = bar
    }

    public init(psi: Double) {
        self.bar = psi / 14.5038
    }

    public init(atmospheres: Double) {
        self.bar = atmospheres * 1.01325
    }

    /// Pressure in PSI (pounds per square inch)
    public var psi: Double {
        bar * 14.5038
    }

    /// Pressure in atmospheres
    public var atmospheres: Double {
        bar / 1.01325
    }

    /// Pressure in pascals
    public var pascals: Double {
        bar * 100000
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        bar = try container.decode(Double.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(bar)
    }
}

// MARK: - Comparable

extension UDDFPressure: Comparable {
    public static func < (lhs: UDDFPressure, rhs: UDDFPressure) -> Bool {
        lhs.bar < rhs.bar
    }
}

// MARK: - CustomStringConvertible

extension UDDFPressure: CustomStringConvertible {
    public var description: String {
        "\(bar) bar"
    }
}
