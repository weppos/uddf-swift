import Foundation

/// Smoking habits (cigarettes per day)
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/smoking.html
public enum Smoking: Equatable, Sendable {
    /// Non-smoker (0 cigarettes per day)
    case nonSmoker

    /// 0-3 cigarettes per day
    case zeroToThree

    /// 4-10 cigarettes per day
    case fourToTen

    /// 11-20 cigarettes per day
    case elevenToTwenty

    /// 21-40 cigarettes per day
    case twentyOneToForty

    /// More than 40 cigarettes per day
    case fortyPlus

    /// Non-standard or unknown smoking value
    case unknown(String)

    /// The raw string value
    public var rawValue: String {
        switch self {
        case .nonSmoker: return "0"
        case .zeroToThree: return "0-3"
        case .fourToTen: return "4-10"
        case .elevenToTwenty: return "11-20"
        case .twentyOneToForty: return "21-40"
        case .fortyPlus: return "40+"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    ///
    /// Standard UDDF values map to known cases, all others to `.unknown(String)`
    public init(rawValue: String) {
        switch rawValue {
        case "0": self = .nonSmoker
        case "0-3": self = .zeroToThree
        case "4-10": self = .fourToTen
        case "11-20": self = .elevenToTwenty
        case "21-40": self = .twentyOneToForty
        case "40+": self = .fortyPlus
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard UDDF smoking value
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

// MARK: - Codable

extension Smoking: Codable {
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
