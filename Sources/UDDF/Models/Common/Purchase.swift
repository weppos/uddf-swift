import Foundation

/// Purchase information for equipment
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/purchase.html
public struct Purchase: Codable, Equatable, Sendable {
    /// Date of purchase
    public var datetime: Date?

    /// Purchase price
    public var price: Price?

    /// Shop where the item was purchased
    public var shop: Shop?

    /// Link to shop defined elsewhere
    public var link: Link?

    public init(
        datetime: Date? = nil,
        price: Price? = nil,
        shop: Shop? = nil,
        link: Link? = nil
    ) {
        self.datetime = datetime
        self.price = price
        self.shop = shop
        self.link = link
    }
}
