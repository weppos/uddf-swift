import Foundation

/// Valid until date wrapper containing datetime
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/validdate.html
public struct ValidDate: Codable, Equatable, Sendable {
    /// Date and time until which certification is valid
    public var datetime: Date?

    public init(datetime: Date? = nil) {
        self.datetime = datetime
    }
}
