import Foundation

/// Profile data section containing recorded dive profiles
///
/// This section contains one or more repetition groups, which group dives
/// that were performed in sequence (same day or dive trip).
public struct UDDFProfileData: Codable, Equatable {
    /// One or more repetition groups
    public var repetitiongroup: [UDDFRepetitionGroup]?

    public init(repetitiongroup: [UDDFRepetitionGroup]? = nil) {
        self.repetitiongroup = repetitiongroup
    }
}
