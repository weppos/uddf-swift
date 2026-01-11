import Foundation

/// Postal address information
///
/// Used for storing location information for divers, businesses, manufacturers,
/// and other entities.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/address.html
public struct Address: Codable, Equatable, Sendable {
    /// Street address
    public var street: String?

    /// City name
    public var city: String?

    /// Postal code
    public var postcode: String?

    /// Country name
    public var country: String?

    /// Province or state
    public var province: String?

    public init(
        street: String? = nil,
        city: String? = nil,
        postcode: String? = nil,
        country: String? = nil,
        province: String? = nil
    ) {
        self.street = street
        self.city = city
        self.postcode = postcode
        self.country = country
        self.province = province
    }
}
