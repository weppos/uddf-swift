import Foundation
import XMLCoder

/// Business entities (dive shops, training organizations)
///
/// Information about commercial diving businesses.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/business.html
public struct Business: Codable, Equatable, Sendable {
    /// Unique identifier
    public var id: String?

    /// Business name
    public var name: String?

    /// Alternative names
    public var aliasname: [String]?

    /// Postal address
    public var address: Address?

    /// Contact information
    public var contact: Contact?

    public init(
        id: String? = nil,
        name: String? = nil,
        aliasname: [String]? = nil,
        address: Address? = nil,
        contact: Contact? = nil
    ) {
        self.id = id
        self.name = name
        self.aliasname = aliasname
        self.address = address
        self.contact = contact
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case aliasname
        case address
        case contact
    }
}

// MARK: - DynamicNodeEncoding

extension Business: DynamicNodeEncoding {
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
