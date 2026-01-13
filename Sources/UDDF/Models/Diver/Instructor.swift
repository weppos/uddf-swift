import Foundation
import XMLCoder

/// Dive instructor information
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/instructor.html
public struct Instructor: Codable, Equatable, Sendable {
    /// Unique identifier (compulsory)
    public var id: String?

    /// Personal information
    public var personal: Personal?

    /// Postal address
    public var address: Address?

    /// Contact information
    public var contact: Contact?

    /// Notes or comments
    public var notes: Notes?

    public init(
        id: String? = nil,
        personal: Personal? = nil,
        address: Address? = nil,
        contact: Contact? = nil,
        notes: Notes? = nil
    ) {
        self.id = id
        self.personal = personal
        self.address = address
        self.contact = contact
        self.notes = notes
    }

    enum CodingKeys: String, CodingKey {
        case id
        case personal
        case address
        case contact
        case notes
    }
}

// MARK: - DynamicNodeEncoding

extension Instructor: DynamicNodeEncoding {
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
