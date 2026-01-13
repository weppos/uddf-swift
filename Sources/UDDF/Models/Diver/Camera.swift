import Foundation
import XMLCoder

/// Photo camera with body, lenses, flash, and housing
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/camera.html
public struct Camera: Codable, Equatable, Sendable {
    /// Unique identifier
    public var id: String?

    /// Camera body (compulsory)
    public var body: CameraBody?

    /// Camera lenses (optional, multiple)
    public var lens: [Lens]?

    /// Flash units (optional, multiple)
    public var flash: [Flash]?

    /// Underwater housing (optional)
    public var housing: Housing?

    public init(
        id: String? = nil,
        body: CameraBody? = nil,
        lens: [Lens]? = nil,
        flash: [Flash]? = nil,
        housing: Housing? = nil
    ) {
        self.id = id
        self.body = body
        self.lens = lens
        self.flash = flash
        self.housing = housing
    }

    enum CodingKeys: String, CodingKey {
        case id, body, lens, flash, housing
    }
}

extension Camera: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}

// MARK: - CameraBody

/// Camera body
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/body.html
public struct CameraBody: Codable, Equatable, Sendable {
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
        link: Link? = nil
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
    }

    enum CodingKeys: String, CodingKey {
        case id, name, aliasname, manufacturer, model, serialnumber
        case purchase, serviceinterval, nextservicedate, notes, link
    }
}

extension CameraBody: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}

// MARK: - Lens

/// Camera lens
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/lens.html
public struct Lens: Codable, Equatable, Sendable {
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
        link: Link? = nil
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
    }

    enum CodingKeys: String, CodingKey {
        case id, name, aliasname, manufacturer, model, serialnumber
        case purchase, serviceinterval, nextservicedate, notes, link
    }
}

extension Lens: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}

// MARK: - Flash

/// Camera flash/strobe
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/flash.html
public struct Flash: Codable, Equatable, Sendable {
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
        link: Link? = nil
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
    }

    enum CodingKeys: String, CodingKey {
        case id, name, aliasname, manufacturer, model, serialnumber
        case purchase, serviceinterval, nextservicedate, notes, link
    }
}

extension Flash: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}

// MARK: - Housing

/// Underwater housing for camera/video equipment
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/housing.html
public struct Housing: Codable, Equatable, Sendable {
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
        link: Link? = nil
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
    }

    enum CodingKeys: String, CodingKey {
        case id, name, aliasname, manufacturer, model, serialnumber
        case purchase, serviceinterval, nextservicedate, notes, link
    }
}

extension Housing: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}
