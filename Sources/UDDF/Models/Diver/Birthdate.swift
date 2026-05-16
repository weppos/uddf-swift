import Foundation

/// Birth date wrapper containing datetime
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/birthdate.html
public struct Birthdate: Codable, Equatable, Sendable {
    /// Date and time of birth
    public var datetime: Date?

    public init(datetime: Date? = nil) {
        self.datetime = datetime
    }
}
