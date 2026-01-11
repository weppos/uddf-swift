import Foundation
import XMLCoder

/// Decompression table used to plan a dive
///
/// Indicates which decompression table was used for dive planning.
/// From DAN Project Dive Exploration standard.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/divetable.html
public struct DiveTable: Equatable, Sendable {
    /// PADI decompression tables
    public static let padi = DiveTable(rawValue: "PADI")
    /// NAUI decompression tables
    public static let naui = DiveTable(rawValue: "NAUI")
    /// BSAC decompression tables
    public static let bsac = DiveTable(rawValue: "BSAC")
    /// Buehlmann decompression algorithm
    public static let buehlmann = DiveTable(rawValue: "Buehlmann")
    /// DCIEM decompression tables
    public static let dciem = DiveTable(rawValue: "DCIEM")
    /// US Navy decompression tables
    public static let usNavy = DiveTable(rawValue: "US-Navy")
    /// CSMD decompression tables
    public static let csmd = DiveTable(rawValue: "CSMD")
    /// COMEX decompression tables
    public static let comex = DiveTable(rawValue: "COMEX")
    /// Other decompression table
    public static let other = DiveTable(rawValue: "other")

    /// The raw string value
    public let rawValue: String

    /// Whether this is a standard UDDF value
    public var isStandard: Bool {
        switch rawValue {
        case "PADI", "NAUI", "BSAC", "Buehlmann", "DCIEM", "US-Navy", "CSMD", "COMEX", "other":
            return true
        default:
            return false
        }
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension DiveTable: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

/// Hyperbaric recompression treatment after a dive
///
/// Documents hyperbaric chamber treatment for decompression sickness.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/hyperbaricfacilitytreatment.html
public struct HyperbaricFacilityTreatment: Codable, Equatable, Sendable {
    /// Cross-reference to hyperbaric facility
    public var link: Link?

    /// Date when recompression treatment started
    public var dateofrecompressiontreatment: DateOfRecompressionTreatment?

    /// Number of recompression treatments required
    public var numberofrecompressiontreatments: Int?

    /// Additional notes about the treatment
    public var notes: Notes?

    /// Cross-references to related dives
    public var relateddives: RelatedDives?

    public init(
        link: Link? = nil,
        dateofrecompressiontreatment: DateOfRecompressionTreatment? = nil,
        numberofrecompressiontreatments: Int? = nil,
        notes: Notes? = nil,
        relateddives: RelatedDives? = nil
    ) {
        self.link = link
        self.dateofrecompressiontreatment = dateofrecompressiontreatment
        self.numberofrecompressiontreatments = numberofrecompressiontreatments
        self.notes = notes
        self.relateddives = relateddives
    }
}

/// Date of recompression treatment
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/dateofrecompressiontreatment.html
public struct DateOfRecompressionTreatment: Codable, Equatable, Sendable {
    /// Date and time of the treatment
    public var datetime: Date?

    public init(datetime: Date? = nil) {
        self.datetime = datetime
    }
}

/// Related dives container
///
/// Contains cross-references to related dive records.
public struct RelatedDives: Codable, Equatable, Sendable {
    /// Links to related dives
    public var link: [Link]?

    public init(link: [Link]? = nil) {
        self.link = link
    }
}

/// Empty element indicating no suit was worn
///
/// A marker element indicating the dive was conducted without protective suit.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/nosuit.html
public struct NoSuit: Codable, Equatable, Sendable {
    public init() {}

    public init(from decoder: Decoder) throws {
        // Empty element, nothing to decode
    }

    public func encode(to encoder: Encoder) throws {
        // Empty element - just needs to exist
        var container = encoder.singleValueContainer()
        try container.encode("")
    }
}

/// Container for global alarms triggered during a dive
///
/// Lists alarms given only once, global for the whole dive.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/globalalarmsgiven.html
public struct GlobalAlarmsGiven: Codable, Equatable, Sendable {
    /// List of global alarms triggered during the dive
    ///
    /// Common values: `ascent-warning-too-long`, `sos-mode`, `work-too-hard`
    public var globalalarm: [String]?

    public init(globalalarm: [String]? = nil) {
        self.globalalarm = globalalarm
    }
}
