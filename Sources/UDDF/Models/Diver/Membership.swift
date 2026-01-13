import Foundation
import XMLCoder

/// Organization membership information
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/membership.html
public struct Membership: Codable, Equatable, Sendable {
    /// Name of the organization (compulsory)
    public var organisation: String

    /// Member identification number (optional)
    public var memberid: String?

    public init(organisation: String, memberid: String? = nil) {
        self.organisation = organisation
        self.memberid = memberid
    }

    enum CodingKeys: String, CodingKey {
        case organisation
        case memberid
    }
}

// MARK: - DynamicNodeEncoding

extension Membership: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}
