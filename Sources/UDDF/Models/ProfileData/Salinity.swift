import Foundation
import XMLCoder

/// Water salinity (fresh/salt) with an optional density attribute.
///
/// EXTENSION: libdivecomputer export
public struct Salinity: Codable, Equatable, Sendable {
    /// Optional density in kg/m^3 when provided by the source.
    @Attribute public var density: Double?

    /// Water type (fresh, salt, or non-standard value).
    public var type: WaterType

    public init(type: WaterType, density: Double? = nil) {
        self.type = type
        self._density = Attribute(density)
    }

    enum CodingKeys: String, CodingKey {
        case density
        case type = ""
    }
}

/// Supported water types for salinity reporting.
public enum WaterType: Equatable, Sendable {
    case fresh
    case salt
    case unknown(String)

    public var rawValue: String {
        switch self {
        case .fresh: return "fresh"
        case .salt: return "salt"
        case .unknown(let value): return value
        }
    }

    public init(rawValue: String) {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        switch trimmed.lowercased() {
        case "fresh": self = .fresh
        case "salt": self = .salt
        default: self = .unknown(trimmed)
        }
    }
}

// MARK: - Codable

extension WaterType: Codable {
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
