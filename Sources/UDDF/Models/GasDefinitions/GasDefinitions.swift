import Foundation
import XMLCoder

/// Gas mixture definitions
///
/// Defines breathing gas mixtures used during dives, including air, nitrox,
/// trimix, and other gas blends.
public struct GasDefinitions: Codable, Equatable, Sendable {
    /// Individual gas mixtures
    public var mix: [Mix]?

    public init(mix: [Mix]? = nil) {
        self.mix = mix
    }
}

/// Gas usage type
///
/// Specifies the intended use of a gas mix in diving configurations.
///
/// - Note: EXTENSION libdivecomputer export
public enum GasUsage: Equatable, Sendable {
    /// Bottom/back gas
    case bottom

    /// Decompression gas
    case deco

    /// Sidemount configuration
    case sidemount

    /// Bailout gas
    case bailout

    /// Diluent gas for CCR
    case diluent

    /// Oxygen for CCR or deco
    case oxygen

    /// Non-standard or unknown usage type
    case unknown(String)

    /// The raw string value for this usage type
    public var rawValue: String {
        switch self {
        case .bottom: return "bottom"
        case .deco: return "deco"
        case .sidemount: return "sidemount"
        case .bailout: return "bailout"
        case .diluent: return "diluent"
        case .oxygen: return "oxygen"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    ///
    /// Standard values map to known cases, all others to `.unknown(String)`
    public init(rawValue: String) {
        switch rawValue {
        case "bottom": self = .bottom
        case "deco": self = .deco
        case "sidemount": self = .sidemount
        case "bailout": self = .bailout
        case "diluent": self = .diluent
        case "oxygen": self = .oxygen
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard libdivecomputer usage type
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

// MARK: - GasUsage Codable

extension GasUsage: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(rawValue: value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

/// A gas mixture (breathing gas)
///
/// Defines the composition of a breathing gas, typically oxygen, nitrogen,
/// and helium percentages.
public struct Mix: Codable, Equatable, Sendable {
    /// Unique identifier for this gas mix
    public var id: String?

    /// Name of the gas mix (e.g., "Air", "EAN32", "Trimix 18/45")
    public var name: String?

    /// Oxygen fraction (0.0 to 1.0, where 0.21 = 21%)
    ///
    /// - Unit: fraction (0.0–1.0)
    public var o2: Double?

    /// Nitrogen fraction (0.0 to 1.0)
    ///
    /// - Unit: fraction (0.0–1.0)
    public var n2: Double?

    /// Helium fraction (0.0 to 1.0)
    ///
    /// - Unit: fraction (0.0–1.0)
    public var he: Double?

    /// Argon fraction (0.0 to 1.0)
    ///
    /// - Unit: fraction (0.0–1.0)
    public var ar: Double?

    /// Hydrogen fraction (0.0 to 1.0)
    ///
    /// - Unit: fraction (0.0–1.0)
    public var h2: Double?

    /// Gas usage type (libdivecomputer extension)
    ///
    /// Specifies the intended use of this gas mix (oxygen, diluent, sidemount, etc.).
    ///
    /// - Note: This is a libdivecomputer de-facto extension, not part of the official UDDF specification.
    public var usage: GasUsage?

    public init(
        id: String? = nil,
        name: String? = nil,
        o2: Double? = nil,
        n2: Double? = nil,
        he: Double? = nil,
        ar: Double? = nil,
        h2: Double? = nil,
        usage: GasUsage? = nil
    ) {
        self.id = id
        self.name = name
        self.o2 = o2
        self.n2 = n2
        self.he = he
        self.ar = ar
        self.h2 = h2
        self.usage = usage
    }

    /// Convenience property: Oxygen percentage as percentage (0-100)
    public var oxygenPercentage: Double? {
        o2.map { $0 * 100 }
    }

    /// Convenience property: Is this air? (21% O2, 79% N2)
    public var isAir: Bool {
        guard let o2 = o2, let n2 = n2 else { return false }
        return abs(o2 - 0.21) < 0.01 && abs(n2 - 0.79) < 0.01
    }

    /// Convenience property: Is this nitrox? (>21% O2)
    public var isNitrox: Bool {
        guard let o2 = o2 else { return false }
        return o2 > 0.21
    }

    /// Convenience property: Is this trimix? (Contains helium)
    public var isTrimix: Bool {
        guard let he = he else { return false }
        return he > 0.0
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case o2
        case n2
        case he
        case ar
        case h2
        case usage
    }
}

// MARK: - DynamicNodeEncoding

extension Mix: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let codingKey = key as? CodingKeys else {
            return .element
        }

        switch codingKey {
        case .id:
            return .attribute
        default:
            return .element
        }
    }
}
