import Foundation

/// Profile data section containing recorded dive profiles
///
/// This section contains one or more repetition groups, which group dives
/// that were performed in sequence (same day or dive trip).
public struct ProfileData: Codable, Equatable, Sendable {
    /// One or more repetition groups
    public var repetitiongroup: [RepetitionGroup]?

    public init(repetitiongroup: [RepetitionGroup]? = nil) {
        self.repetitiongroup = repetitiongroup
    }
}
