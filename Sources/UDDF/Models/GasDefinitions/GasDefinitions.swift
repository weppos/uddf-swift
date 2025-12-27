import Foundation
import XMLCoder

/// Gas mixture definitions
///
/// Defines breathing gas mixtures used during dives, including air, nitrox,
/// trimix, and other gas blends.
public struct GasDefinitions: Codable, Equatable {
    /// Individual gas mixtures
    public var mix: [Mix]?

    public init(mix: [Mix]? = nil) {
        self.mix = mix
    }
}

/// A gas mixture (breathing gas)
///
/// Defines the composition of a breathing gas, typically oxygen, nitrogen,
/// and helium percentages.
public struct Mix: Codable, Equatable {
    /// Unique identifier for this gas mix
    public var id: String?

    /// Name of the gas mix (e.g., "Air", "EAN32", "Trimix 18/45")
    public var name: String?

    /// Oxygen percentage (0.0 to 1.0, where 0.21 = 21%)
    public var o2: Double?

    /// Nitrogen percentage (0.0 to 1.0)
    public var n2: Double?

    /// Helium percentage (0.0 to 1.0)
    public var he: Double?

    /// Argon percentage (0.0 to 1.0)
    public var ar: Double?

    /// Hydrogen percentage (0.0 to 1.0)
    public var h2: Double?

    public init(
        id: String? = nil,
        name: String? = nil,
        o2: Double? = nil,
        n2: Double? = nil,
        he: Double? = nil,
        ar: Double? = nil,
        h2: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.o2 = o2
        self.n2 = n2
        self.he = he
        self.ar = ar
        self.h2 = h2
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
