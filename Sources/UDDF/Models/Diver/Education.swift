import Foundation

/// Diver education and certification records
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/education.html
public struct Education: Codable, Equatable, Sendable {
    /// Certification records
    public var certification: [Certification]?

    public init(certification: [Certification]? = nil) {
        self.certification = certification
    }
}
