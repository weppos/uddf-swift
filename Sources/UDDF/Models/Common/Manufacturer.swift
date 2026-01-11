import Foundation
import XMLCoder

/// Manufacturer or developer information
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/manufacturer.html
public struct Manufacturer: Codable, Equatable, Sendable {
    /// Unique identifier for this manufacturer
    public var id: String

    /// Name of the manufacturer
    public var name: String?

    /// Alternative names
    public var aliasname: [String]?

    /// Postal address
    public var address: Address?

    /// Contact information
    public var contact: Contact?

    public init(
        id: String,
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

extension Manufacturer: DynamicNodeEncoding {
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
