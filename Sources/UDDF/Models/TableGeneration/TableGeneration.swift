import Foundation

/// Dive table generation parameters
///
/// Parameters used to generate dive tables.
public struct TableGeneration: Codable, Equatable {
    /// Link to decompression model
    public var link: Link?

    public init(link: Link? = nil) {
        self.link = link
    }
}
