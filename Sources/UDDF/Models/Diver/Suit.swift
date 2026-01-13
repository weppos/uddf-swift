import Foundation
import XMLCoder

/// Diving exposure suit (wetsuit, drysuit, etc.)
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/suit.html
public struct Suit: Codable, Equatable, Sendable {
    /// Unique identifier
    public var id: String?

    /// Equipment name
    public var name: String?

    /// Alternative names
    public var aliasname: [String]?

    /// Manufacturer information
    public var manufacturer: Manufacturer?

    /// Model designation
    public var model: String?

    /// Serial number
    public var serialnumber: String?

    /// Purchase information
    public var purchase: Purchase?

    /// Service interval in days
    public var serviceinterval: Int?

    /// Next service date
    public var nextservicedate: Date?

    /// Additional notes
    public var notes: Notes?

    /// Link to manufacturer defined elsewhere
    public var link: Link?

    // MARK: - Suit-specific fields

    /// Type of suit
    public var suittype: SuitType?

    public init(
        id: String? = nil,
        name: String? = nil,
        aliasname: [String]? = nil,
        manufacturer: Manufacturer? = nil,
        model: String? = nil,
        serialnumber: String? = nil,
        purchase: Purchase? = nil,
        serviceinterval: Int? = nil,
        nextservicedate: Date? = nil,
        notes: Notes? = nil,
        link: Link? = nil,
        suittype: SuitType? = nil
    ) {
        self.id = id
        self.name = name
        self.aliasname = aliasname
        self.manufacturer = manufacturer
        self.model = model
        self.serialnumber = serialnumber
        self.purchase = purchase
        self.serviceinterval = serviceinterval
        self.nextservicedate = nextservicedate
        self.notes = notes
        self.link = link
        self.suittype = suittype
    }

    enum CodingKeys: String, CodingKey {
        case id, name, aliasname, manufacturer, model, serialnumber
        case purchase, serviceinterval, nextservicedate, notes, link
        case suittype
    }
}

extension Suit: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}

// MARK: - SuitType

/// Type of diving suit
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/suittype.html
public enum SuitType: Equatable, Sendable {
    case diveSkin
    case wetSuit
    case drySuit
    case hotWaterSuit
    case other
    case unknown(String)

    public var rawValue: String {
        switch self {
        case .diveSkin: return "dive-skin"
        case .wetSuit: return "wet-suit"
        case .drySuit: return "dry-suit"
        case .hotWaterSuit: return "hot-water-suit"
        case .other: return "other"
        case .unknown(let value): return value
        }
    }

    public init(rawValue: String) {
        switch rawValue.lowercased() {
        case "dive-skin": self = .diveSkin
        case "wet-suit": self = .wetSuit
        case "dry-suit": self = .drySuit
        case "hot-water-suit": self = .hotWaterSuit
        case "other": self = .other
        default: self = .unknown(rawValue)
        }
    }

    /// Whether this is a standard UDDF suit type value
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

// MARK: - Codable

extension SuitType: Codable {
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
