import Foundation

/// Temperature measurement with automatic unit conversion
///
/// UDDF stores temperatures in Kelvin. This type provides automatic conversion
/// to Celsius and Fahrenheit.
public struct UDDFTemperature: Codable, Equatable, Hashable {
    /// Temperature in Kelvin (UDDF standard unit)
    public var kelvin: Double

    public init(kelvin: Double) {
        self.kelvin = kelvin
    }

    public init(celsius: Double) {
        self.kelvin = celsius + 273.15
    }

    public init(fahrenheit: Double) {
        self.kelvin = (fahrenheit - 32) * 5/9 + 273.15
    }

    /// Temperature in Celsius
    public var celsius: Double {
        kelvin - 273.15
    }

    /// Temperature in Fahrenheit
    public var fahrenheit: Double {
        (kelvin - 273.15) * 9/5 + 32
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        kelvin = try container.decode(Double.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(kelvin)
    }
}

// MARK: - Comparable

extension UDDFTemperature: Comparable {
    public static func < (lhs: UDDFTemperature, rhs: UDDFTemperature) -> Bool {
        lhs.kelvin < rhs.kelvin
    }
}

// MARK: - CustomStringConvertible

extension UDDFTemperature: CustomStringConvertible {
    public var description: String {
        "\(celsius)°C"
    }
}
