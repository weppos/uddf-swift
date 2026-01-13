import Foundation

/// Issue date wrapper containing datetime
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/issuedate.html
public struct IssueDate: Codable, Equatable, Sendable {
    /// Date and time of issue
    public var datetime: Date?

    public init(datetime: Date? = nil) {
        self.datetime = datetime
    }
}
