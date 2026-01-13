import Foundation

/// Personal information about a diver
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/personal.html
public struct Personal: Codable, Equatable, Sendable {
    /// First name
    public var firstname: String?

    /// Middle name
    public var middlename: String?

    /// Last name
    public var lastname: String?

    /// Birth name (maiden name)
    public var birthname: String?

    /// Honorific or title (e.g., Dr., Prof.)
    public var honorific: String?

    /// Biological sex
    public var sex: Sex?

    /// Height in meters
    ///
    /// - Unit: meters
    public var height: Double?

    /// Weight in kilograms
    ///
    /// - Unit: kilograms
    public var weight: Double?

    /// Smoking habits
    public var smoking: Smoking?

    /// Birth date
    public var birthdate: Birthdate?

    /// Passport number
    public var passport: String?

    /// Blood group (e.g., A, B, AB, O with +/-)
    public var bloodgroup: String?

    /// Organization memberships
    public var membership: [Membership]?

    /// Number of dives in a time interval
    public var numberofdives: NumberOfDives?

    public init(
        firstname: String? = nil,
        middlename: String? = nil,
        lastname: String? = nil,
        birthname: String? = nil,
        honorific: String? = nil,
        sex: Sex? = nil,
        height: Double? = nil,
        weight: Double? = nil,
        smoking: Smoking? = nil,
        birthdate: Birthdate? = nil,
        passport: String? = nil,
        bloodgroup: String? = nil,
        membership: [Membership]? = nil,
        numberofdives: NumberOfDives? = nil
    ) {
        self.firstname = firstname
        self.middlename = middlename
        self.lastname = lastname
        self.birthname = birthname
        self.honorific = honorific
        self.sex = sex
        self.height = height
        self.weight = weight
        self.smoking = smoking
        self.birthdate = birthdate
        self.passport = passport
        self.bloodgroup = bloodgroup
        self.membership = membership
        self.numberofdives = numberofdives
    }
}
