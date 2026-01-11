import Foundation
import XMLCoder

/// Shop/vendor information for equipment purchases
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/shop.html
public struct Shop: Codable, Equatable, Sendable {
    /// Unique identifier for this shop
    public var id: String

    /// Name of the shop
    public var name: String?

    /// Alternative names
    public var aliasname: [String]?

    /// Postal address
    public var address: Address?

    /// Contact information
    public var contact: Contact?

    /// Additional notes
    public var notes: Notes?

    public init(
        id: String,
        name: String? = nil,
        aliasname: [String]? = nil,
        address: Address? = nil,
        contact: Contact? = nil,
        notes: Notes? = nil
    ) {
        self.id = id
        self.name = name
        self.aliasname = aliasname
        self.address = address
        self.contact = contact
        self.notes = notes
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case aliasname
        case address
        case contact
        case notes
    }
}

// MARK: - DynamicNodeEncoding

extension Shop: DynamicNodeEncoding {
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
