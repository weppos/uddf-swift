import Foundation
import XMLCoder

/// Diving tank/cylinder
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/tank.html
public struct Tank: Codable, Equatable, Sendable {
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

    // MARK: - Tank-specific fields

    /// Tank material (aluminium, carbon, steel)
    public var tankmaterial: TankMaterial?

    /// Tank volume
    ///
    /// - Unit: cubic meters (m³)
    public var tankvolume: Volume?

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
        tankmaterial: TankMaterial? = nil,
        tankvolume: Volume? = nil
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
        self.tankmaterial = tankmaterial
        self.tankvolume = tankvolume
    }

    enum CodingKeys: String, CodingKey {
        case id, name, aliasname, manufacturer, model, serialnumber
        case purchase, serviceinterval, nextservicedate, notes, link
        case tankmaterial, tankvolume
    }
}

extension Tank: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}

// MARK: - TankMaterial

/// Tank construction material
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/tankmaterial.html
public enum TankMaterial: Equatable, Sendable {
    case aluminium
    case carbon
    case steel
    case unknown(String)

    public var rawValue: String {
        switch self {
        case .aluminium: return "aluminium"
        case .carbon: return "carbon"
        case .steel: return "steel"
        case .unknown(let value): return value
        }
    }

    public init(rawValue: String) {
        switch rawValue.lowercased() {
        case "aluminium", "aluminum": self = .aluminium
        case "carbon": self = .carbon
        case "steel": self = .steel
        default: self = .unknown(rawValue)
        }
    }

    /// Whether this is a standard UDDF tank material value
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

// MARK: - Codable

extension TankMaterial: Codable {
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
