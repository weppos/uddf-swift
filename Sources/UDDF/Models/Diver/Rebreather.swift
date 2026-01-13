import Foundation
import XMLCoder

/// Rebreather (closed-circuit breathing apparatus)
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/rebreather.html
public struct Rebreather: Codable, Equatable, Sendable {
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

    // MARK: - Rebreather-specific fields

    /// Oxygen sensors in the rebreather
    public var o2sensor: [O2Sensor]?

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
        o2sensor: [O2Sensor]? = nil
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
        self.o2sensor = o2sensor
    }

    enum CodingKeys: String, CodingKey {
        case id, name, aliasname, manufacturer, model, serialnumber
        case purchase, serviceinterval, nextservicedate, notes, link
        case o2sensor
    }
}

extension Rebreather: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}

// MARK: - O2Sensor

/// Oxygen sensor for rebreathers
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/o2sensor.html
public struct O2Sensor: Codable, Equatable, Sendable {
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
        notes: Notes? = nil
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
    }

    enum CodingKeys: String, CodingKey {
        case id, name, aliasname, manufacturer, model, serialnumber
        case purchase, serviceinterval, nextservicedate, notes
    }
}

extension O2Sensor: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}
