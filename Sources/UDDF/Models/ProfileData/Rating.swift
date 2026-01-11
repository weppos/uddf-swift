import Foundation

/// Dive rating
///
/// Represents the diver's rating of the dive, including the rating value
/// and optionally when it was assigned.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/rating.html
public struct Rating: Codable, Equatable, Sendable {
    /// The rating value (typically 0-10)
    ///
    /// Required when rating element is present.
    public var ratingvalue: Int

    /// Date when the rating was assigned
    public var datetime: Date?

    public init(
        ratingvalue: Int,
        datetime: Date? = nil
    ) {
        self.ratingvalue = ratingvalue
        self.datetime = datetime
    }
}
