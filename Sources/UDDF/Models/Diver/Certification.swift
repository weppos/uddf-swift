import Foundation

/// Dive certification record
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/certification.html
public struct Certification: Codable, Equatable, Sendable {
    /// Certification level (e.g., OWD, AOWD, Divemaster)
    public var level: String?

    /// Certifying organization (e.g., PADI, SSI, CMAS)
    public var organization: String?

    /// Instructor who issued the certification
    public var instructor: Instructor?

    /// Date when the certification was issued
    public var issuedate: IssueDate?

    /// Cross-reference link to instructor defined elsewhere
    public var link: Link?

    /// Specialty certification name (e.g., Nitrox, Deep Diver)
    public var specialty: String?

    /// Date until which the certification is valid
    public var validdate: ValidDate?

    public init(
        level: String? = nil,
        organization: String? = nil,
        instructor: Instructor? = nil,
        issuedate: IssueDate? = nil,
        link: Link? = nil,
        specialty: String? = nil,
        validdate: ValidDate? = nil
    ) {
        self.level = level
        self.organization = organization
        self.instructor = instructor
        self.issuedate = issuedate
        self.link = link
        self.specialty = specialty
        self.validdate = validdate
    }
}
