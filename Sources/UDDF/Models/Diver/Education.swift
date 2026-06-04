import Foundation

/// Diver education and certification records
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/education.html
public struct Education: Codable, Equatable, Sendable {
    /// Certification records
    public var certification: [Certification]?

    public init(certification: [Certification]? = nil) {
        self.certification = certification
    }
}
