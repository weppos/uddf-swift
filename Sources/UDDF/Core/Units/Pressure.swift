import Foundation

/// Pressure measurement with automatic unit conversion
///
/// UDDF stores pressure in pascals in the XML format, but this type stores
/// values internally in bar for convenience and provides automatic conversion
/// to PSI, pascals, and other common pressure units.
public struct Pressure: Codable, Equatable, Hashable {
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
        let pascals = try container.decode(Double.self)
        // UDDF stores pressure in pascals, convert to bar for internal storage
        bar = pascals / 100000
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        // UDDF stores pressure in pascals, convert from bar
        try container.encode(bar * 100000)
    }
}

// MARK: - Comparable

extension Pressure: Comparable {
    public static func < (lhs: Pressure, rhs: Pressure) -> Bool {
        lhs.bar < rhs.bar
    }
}

// MARK: - CustomStringConvertible

extension Pressure: CustomStringConvertible {
    public var description: String {
        "\(bar) bar"
    }
}
