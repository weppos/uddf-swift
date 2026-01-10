import Foundation

/// Pressure measurement with automatic unit conversion
///
/// UDDF stores pressure in pascals (Pa). This type provides automatic conversion
/// to bar, PSI, and atmospheres.
///
/// - SeeAlso: UDDF 3.2.1 specification for pressure units
public struct Pressure: Codable, Equatable, Hashable, Sendable {
    /// Pressure in pascals (UDDF standard unit)
    ///
    /// - Unit: Pa (pascals)
    public var pascals: Double

    /// Creates a pressure from pascals
    ///
    /// - Parameter pascals: Pressure in pascals (Pa)
    public init(pascals: Double) {
        self.pascals = pascals
    }

    /// Creates a pressure from bar
    ///
    /// - Parameter bar: Pressure in bar
    public init(bar: Double) {
        // 1 bar = 100,000 Pa
        self.pascals = bar * 100_000
    }

    /// Creates a pressure from PSI
    ///
    /// - Parameter psi: Pressure in pounds per square inch (PSI)
    public init(psi: Double) {
        // 1 PSI = 6894.76 Pa
        self.pascals = psi * 6894.76
    }

    /// Creates a pressure from atmospheres
    ///
    /// - Parameter atmospheres: Pressure in atmospheres (atm)
    public init(atmospheres: Double) {
        // 1 atm = 101,325 Pa
        self.pascals = atmospheres * 101_325
    }

    /// Pressure in bar
    ///
    /// - Unit: bar
    public var bar: Double {
        pascals / 100_000
    }

    /// Pressure in PSI (pounds per square inch)
    ///
    /// - Unit: PSI
    public var psi: Double {
        pascals / 6894.76
    }

    /// Pressure in atmospheres
    ///
    /// - Unit: atm
    public var atmospheres: Double {
        pascals / 101_325
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        pascals = try container.decode(Double.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(pascals)
    }
}

// MARK: - Comparable

extension Pressure: Comparable {
    public static func < (lhs: Pressure, rhs: Pressure) -> Bool {
        lhs.pascals < rhs.pascals
    }
}

// MARK: - CustomStringConvertible

extension Pressure: CustomStringConvertible {
    public var description: String {
        "\(bar) bar"
    }
}
