import Foundation

/// REQUIRED section identifying the software that created the UDDF file
///
/// Every UDDF file must contain a generator section that identifies the
/// application that created or last modified the file.
public struct UDDFGenerator: Codable, Equatable {
    /// Name of the generating application
    public var name: String

    /// Manufacturer or developer of the application
    public var manufacturer: UDDFManufacturerInfo?

    /// Contact information for the software developer
    public var contact: UDDFContact?

    /// Version of the generating software
    public var version: String?

    /// Date and time when the file was created or last modified
    public var datetime: Date?

    public init(
        name: String,
        manufacturer: UDDFManufacturerInfo? = nil,
        contact: UDDFContact? = nil,
        version: String? = nil,
        datetime: Date? = nil
    ) {
        self.name = name
        self.manufacturer = manufacturer
        self.contact = contact
        self.version = version
        self.datetime = datetime
    }

    enum CodingKeys: String, CodingKey {
        case name
        case manufacturer
        case contact
        case version
        case datetime
    }
}

/// Manufacturer or developer information
public struct UDDFManufacturerInfo: Codable, Equatable {
    /// Name of the manufacturer
    public var name: String

    /// Contact information
    public var contact: UDDFContact?

    public init(name: String, contact: UDDFContact? = nil) {
        self.name = name
        self.contact = contact
    }
}

/// Contact information
public struct UDDFContact: Codable, Equatable {
    /// Website URL
    public var homepage: String?

    /// Email address
    public var email: String?

    /// Phone number
    public var phone: String?

    public init(homepage: String? = nil, email: String? = nil, phone: String? = nil) {
        self.homepage = homepage
        self.email = email
        self.phone = phone
    }
}
