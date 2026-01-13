import Foundation
import XMLCoder

/// Diver information
///
/// Contains information about divers, including the owner (primary diver),
/// buddies, and dive instructors.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/diver.html
public struct Diver: Codable, Equatable, Sendable {
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
///
/// https://www.streit.cc/extern/uddf_v321/en/owner.html
public struct Owner: Codable, Equatable, Sendable {
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
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/buddy.html
public struct Buddy: Codable, Equatable, Sendable {
    /// Unique identifier
    public var id: String?

    /// Personal information
    public var personal: Personal?

    /// Equipment used by this buddy
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