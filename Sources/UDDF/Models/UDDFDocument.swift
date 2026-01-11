import Foundation
import XMLCoder

/// Represents a complete UDDF document (version 3.2.1)
///
/// This is the root element of a UDDF file. Every UDDF file must have a version
/// attribute and a required generator section. All other sections are optional.
public struct UDDFDocument: Codable, Equatable, Sendable {
    /// UDDF namespace URI for version 3.2.x
    public static let namespaceURI = "http://www.streit.cc/uddf/3.2/"

    /// XML namespace attribute (always set to the UDDF 3.2 namespace)
    public var xmlns: String

    /// UDDF version number (e.g., "3.2.1")
    public var version: String

    /// REQUIRED: Information about the software that generated this file
    public var generator: Generator

    /// OPTIONAL: Multimedia data (images, audio, video)
    public var mediadata: MediaData?

    /// OPTIONAL: Manufacturer information
    public var maker: [Maker]?

    /// OPTIONAL: Business entities (dive shops, training organizations)
    public var business: [Business]?

    /// OPTIONAL: Diver profiles and certifications
    public var diver: DiverData?

    /// OPTIONAL: Dive site descriptions
    public var divesite: [DiveSite]?

    /// OPTIONAL: Gas mixture definitions
    public var gasdefinitions: GasDefinitions?

    /// OPTIONAL: Decompression model parameters
    public var decomodel: DecoModel?

    /// OPTIONAL: Recorded dive profiles
    public var profiledata: ProfileData?

    /// OPTIONAL: Dive table generation parameters
    public var tablegeneration: TableGeneration?

    /// OPTIONAL: Multi-dive trip information
    public var divetrip: [DiveTrip]?

    /// OPTIONAL: Dive computer configuration
    public var divecomputercontrol: DiveComputerControl?

    public init(
        version: String = "3.2.1",
        generator: Generator
    ) {
        self.xmlns = Self.namespaceURI
        self.version = version
        self.generator = generator
    }

    enum CodingKeys: String, CodingKey {
        case xmlns
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // xmlns may not be present in all UDDF files; default to standard namespace
        xmlns = try container.decodeIfPresent(String.self, forKey: .xmlns) ?? Self.namespaceURI
        version = try container.decode(String.self, forKey: .version)
        generator = try container.decode(Generator.self, forKey: .generator)
        mediadata = try container.decodeIfPresent(MediaData.self, forKey: .mediadata)
        maker = try container.decodeIfPresent([Maker].self, forKey: .maker)
        business = try container.decodeIfPresent([Business].self, forKey: .business)
        diver = try container.decodeIfPresent(DiverData.self, forKey: .diver)
        divesite = try container.decodeIfPresent([DiveSite].self, forKey: .divesite)
        gasdefinitions = try container.decodeIfPresent(GasDefinitions.self, forKey: .gasdefinitions)
        decomodel = try container.decodeIfPresent(DecoModel.self, forKey: .decomodel)
        profiledata = try container.decodeIfPresent(ProfileData.self, forKey: .profiledata)
        tablegeneration = try container.decodeIfPresent(TableGeneration.self, forKey: .tablegeneration)
        divetrip = try container.decodeIfPresent([DiveTrip].self, forKey: .divetrip)
        divecomputercontrol = try container.decodeIfPresent(DiveComputerControl.self, forKey: .divecomputercontrol)
    }
}

// MARK: - DynamicNodeEncoding Conformance

extension UDDFDocument: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let codingKey = key as? CodingKeys else {
            return .element
        }

        switch codingKey {
        case .xmlns, .version:
            return .attribute
        default:
            return .element
        }
    }
}
