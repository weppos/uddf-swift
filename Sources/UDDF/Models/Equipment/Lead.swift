import Foundation
import XMLCoder

/// Diving lead/weights
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/lead.html
public struct Lead: Codable, Equatable, Sendable {
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

    // MARK: - Lead-specific fields

    /// Quantity of lead
    ///
    /// - Unit: kilograms (kg)
    public var leadquantity: Double?

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
        leadquantity: Double? = nil
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
        self.leadquantity = leadquantity
    }

    enum CodingKeys: String, CodingKey {
        case id, name, aliasname, manufacturer, model, serialnumber
        case purchase, serviceinterval, nextservicedate, notes, link
        case leadquantity
    }
}

extension Lead: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}
