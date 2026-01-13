import Foundation

/// Biological sex
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/sex.html
public enum Sex: Equatable, Sendable {
    /// Undetermined sex
    case undetermined

    /// Male
    case male

    /// Female
    case female

    /// Hermaphrodite
    case hermaphrodite

    /// Non-standard or unknown sex value
    case unknown(String)

    /// The raw string value
    public var rawValue: String {
        switch self {
        case .undetermined: return "undetermined"
        case .male: return "male"
        case .female: return "female"
        case .hermaphrodite: return "hermaphrodite"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    ///
    /// Standard UDDF values map to known cases, all others to `.unknown(String)`
    public init(rawValue: String) {
        switch rawValue {
        case "undetermined": self = .undetermined
        case "male": self = .male
        case "female": self = .female
        case "hermaphrodite": self = .hermaphrodite
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard UDDF sex value
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

// MARK: - Codable

extension Sex: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(rawValue: value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
