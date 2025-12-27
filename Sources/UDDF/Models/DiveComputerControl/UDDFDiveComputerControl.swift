import Foundation

/// Dive computer configuration and control
///
/// Contains settings and configuration for dive computers.
public struct UDDFDiveComputerControl: Codable, Equatable {
    /// Settings data (implementation-specific)
    public var settings: String?

    public init(settings: String? = nil) {
        self.settings = settings
    }
}
