import Foundation
import XMLCoder

/// Represents a complete UDDF document (version 3.2.1)
///
/// This is the root element of a UDDF file. Every UDDF file must have a version
/// attribute and a required generator section. All other sections are optional.
public struct UDDFDocument: Codable, Equatable {
    /// UDDF version number (e.g., "3.2.1")
    public var version: String

    /// REQUIRED: Information about the software that generated this file
    public var generator: Generator

    /// OPTIONAL: Multimedia data (images, audio, video)
    public var mediadata: String? // Placeholder for Phase 2

    /// OPTIONAL: Manufacturer information
    public var maker: String? // Placeholder for Phase 2

    /// OPTIONAL: Business entities (dive shops, training organizations)
    public var business: String? // Placeholder for Phase 2

    /// OPTIONAL: Diver profiles and certifications
    public var diver: String? // Placeholder for Phase 2

    /// OPTIONAL: Dive site descriptions
    public var divesite: String? // Placeholder for Phase 2

    /// OPTIONAL: Gas mixture definitions
    public var gasdefinitions: String? // Placeholder for Phase 2

    /// OPTIONAL: Decompression model parameters
    public var decomodel: String? // Placeholder for Phase 2

    /// OPTIONAL: Recorded dive profiles
    public var profiledata: String? // Placeholder for Phase 2

    /// OPTIONAL: Dive table generation parameters
    public var tablegeneration: String? // Placeholder for Phase 2

    /// OPTIONAL: Multi-dive trip information
    public var divetrip: String? // Placeholder for Phase 2

    /// OPTIONAL: Dive computer configuration
    public var divecomputercontrol: String? // Placeholder for Phase 2

    public init(
        version: String = "3.2.1",
        generator: Generator
    ) {
        self.version = version
        self.generator = generator
    }

    enum CodingKeys: String, CodingKey {
        case version
        case generator
        case mediadata
        case maker
        case business
        case diver
        case divesite
        case gasdefinitions
        case decomodel
        case profiledata
        case tablegeneration
        case divetrip
        case divecomputercontrol
    }

}

// MARK: - DynamicNodeEncoding Conformance

extension UDDFDocument: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let codingKey = key as? CodingKeys else {
            return .element
        }

        switch codingKey {
        case .version:
            return .attribute
        default:
            return .element
        }
    }
}
