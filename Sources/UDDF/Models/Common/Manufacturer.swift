import Foundation

/// Manufacturer or developer information
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/manufacturer.html
public struct Manufacturer: Codable, Equatable, Sendable {
    /// Name of the manufacturer
    public var name: String?

    /// Alternative names
    public var aliasname: [String]?

    /// Postal address
    public var address: Address?

    /// Contact information
    public var contact: Contact?

    public init(
        name: String? = nil,
        aliasname: [String]? = nil,
        address: Address? = nil,
        contact: Contact? = nil
    ) {
        self.name = name
        self.aliasname = aliasname
        self.address = address
        self.contact = contact
    }
}
