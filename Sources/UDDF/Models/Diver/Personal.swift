import Foundation

/// Personal information about a diver
public struct Personal: Codable, Equatable, Sendable {
    /// First name
    public var firstname: String?

    /// Last name
    public var lastname: String?

    /// Middle name
    public var middlename: String?

    /// Birth date
    public var birthdate: Date?

    /// Birth name (maiden name)
    public var birthname: String?

    /// Contact information
    public var contact: Contact?

    public init(
        firstname: String? = nil,
        lastname: String? = nil,
        middlename: String? = nil,
        birthdate: Date? = nil,
        birthname: String? = nil,
        contact: Contact? = nil
    ) {
        self.firstname = firstname
        self.lastname = lastname
        self.middlename = middlename
        self.birthdate = birthdate
        self.birthname = birthname
        self.contact = contact
    }
}
