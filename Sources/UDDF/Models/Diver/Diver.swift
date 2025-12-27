import Foundation
import XMLCoder

/// Diver information
///
/// Contains information about divers, including the owner (primary diver),
/// buddies, and dive instructors.
public struct DiverData: Codable, Equatable {
    /// The primary diver (owner of the dive log)
    public var owner: [Owner]?

    /// Dive buddies
    public var buddy: [Buddy]?

    public init(owner: [Owner]? = nil, buddy: [Buddy]? = nil) {
        self.owner = owner
        self.buddy = buddy
    }
}

/// Primary diver (owner) information
public struct Owner: Codable, Equatable {
    /// Unique identifier
    public var id: String?

    /// Personal information
    public var personal: Personal?

    /// Equipment used by this diver
    public var equipment: Equipment?

    public init(id: String? = nil, personal: Personal? = nil, equipment: Equipment? = nil) {
        self.id = id
        self.personal = personal
        self.equipment = equipment
    }

    enum CodingKeys: String, CodingKey {
        case id
        case personal
        case equipment
    }
}

// MARK: - DynamicNodeEncoding

extension Owner: DynamicNodeEncoding {
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

/// Buddy (dive partner) information
public struct Buddy: Codable, Equatable {
    /// Unique identifier
    public var id: String?

    /// Personal information
    public var personal: Personal?

    public init(id: String? = nil, personal: Personal? = nil) {
        self.id = id
        self.personal = personal
    }

    enum CodingKeys: String, CodingKey {
        case id
        case personal
    }
}

// MARK: - DynamicNodeEncoding

extension Buddy: DynamicNodeEncoding {
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

/// Personal information about a diver
public struct Personal: Codable, Equatable {
    /// First name
    public var firstname: String?

    /// Last name
    public var lastname: String?

    /// Middle name
    public var middlename: String?

    /// Birth date
    public var birthdate: Date?

    /// Birth name (maiden name)
    public var birthname: String?

    /// Contact information
    public var contact: Contact?

    public init(
        firstname: String? = nil,
        lastname: String? = nil,
        middlename: String? = nil,
        birthdate: Date? = nil,
        birthname: String? = nil,
        contact: Contact? = nil
    ) {
        self.firstname = firstname
        self.lastname = lastname
        self.middlename = middlename
        self.birthdate = birthdate
        self.birthname = birthname
        self.contact = contact
    }
}

/// Equipment used by a diver
public struct Equipment: Codable, Equatable {
    /// Buoyancy control device
    public var bc: String?

    /// Fins
    public var fins: String?

    /// Mask
    public var mask: String?

    /// Wetsuit or drysuit
    public var suit: String?

    /// Weights
    public var weight: String?

    public init(
        bc: String? = nil,
        fins: String? = nil,
        mask: String? = nil,
        suit: String? = nil,
        weight: String? = nil
    ) {
        self.bc = bc
        self.fins = fins
        self.mask = mask
        self.suit = suit
        self.weight = weight
    }
}
