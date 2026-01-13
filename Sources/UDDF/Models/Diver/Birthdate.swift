import Foundation

/// Birth date wrapper containing datetime
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/birthdate.html
public struct Birthdate: Codable, Equatable, Sendable {
    /// Date and time of birth
    public var datetime: Date?

    public init(datetime: Date? = nil) {
        self.datetime = datetime
    }
}
