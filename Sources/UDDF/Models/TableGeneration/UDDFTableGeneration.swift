import Foundation

/// Dive table generation parameters
///
/// Parameters used to generate dive tables.
public struct UDDFTableGeneration: Codable, Equatable {
    /// Link to decompression model
    public var link: UDDFLink?

    public init(link: UDDFLink? = nil) {
        self.link = link
    }
}
