import Foundation

/// Contact information
///
/// Used for storing contact details for individuals, businesses, and manufacturers.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/contact.html
public struct Contact: Codable, Equatable, Sendable {
    /// Preferred language
    public var language: String?

    /// Phone number
    public var phone: String?

    /// Mobile phone number
    public var mobilephone: String?

    /// Fax number
    public var fax: String?

    /// Email address
    public var email: String?

    /// Website URL
    public var homepage: String?

    public init(
        language: String? = nil,
        phone: String? = nil,
        mobilephone: String? = nil,
        fax: String? = nil,
        email: String? = nil,
        homepage: String? = nil
    ) {
        self.language = language
        self.phone = phone
        self.mobilephone = mobilephone
        self.fax = fax
        self.email = email
        self.homepage = homepage
    }
}
