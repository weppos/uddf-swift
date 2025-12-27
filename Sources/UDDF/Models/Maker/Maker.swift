import Foundation
import XMLCoder

/// Manufacturer information
///
/// Information about manufacturers of diving equipment and software.
public struct Maker: Codable, Equatable {
    /// Unique identifier
    public var id: String?

    /// Manufacturer name
    public var name: String?

    /// Contact information
    public var contact: Contact?

    public init(id: String? = nil, name: String? = nil, contact: Contact? = nil) {
        self.id = id
        self.name = name
        self.contact = contact
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case contact
    }
}

// MARK: - DynamicNodeEncoding

extension Maker: DynamicNodeEncoding {
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
