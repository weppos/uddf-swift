import Foundation

/// Valid until date wrapper containing datetime
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/validdate.html
public struct ValidDate: Codable, Equatable, Sendable {
    /// Date and time until which certification is valid
    public var datetime: Date?

    public init(datetime: Date? = nil) {
        self.datetime = datetime
    }
}
