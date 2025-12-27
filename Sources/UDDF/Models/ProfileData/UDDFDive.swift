import Foundation
import XMLCoder

/// A single dive with profile data
///
/// Contains information before, during, and after the dive, including
/// samples (waypoints) recorded during the dive.
public struct UDDFDive: Codable, Equatable {
    /// Unique identifier for this dive
    public var id: String?

    /// Information recorded before the dive started
    public var informationbeforedive: UDDFInformationBeforeDive?

    /// Information recorded after the dive ended
    public var informationafterdive: UDDFInformationAfterDive?

    /// Dive profile samples (waypoints)
    public var samples: UDDFSamples?

    public init(
        id: String? = nil,
        informationbeforedive: UDDFInformationBeforeDive? = nil,
        informationafterdive: UDDFInformationAfterDive? = nil,
        samples: UDDFSamples? = nil
    ) {
        self.id = id
        self.informationbeforedive = informationbeforedive
        self.informationafterdive = informationafterdive
        self.samples = samples
    }

    enum CodingKeys: String, CodingKey {
        case id
        case informationbeforedive
        case informationafterdive
        case samples
    }
}

// MARK: - DynamicNodeEncoding

extension UDDFDive: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let codingKey = key as? CodingKeys else {
            return .element
        }

        switch codingKey {
        case .id:
            return .attribute
        default:
            return .element
        }
    }
}

/// Information recorded before the dive
public struct UDDFInformationBeforeDive: Codable, Equatable {
    /// Date and time when the dive started
    public var datetime: Date?

    /// Air temperature at surface
    public var airtemperature: UDDFTemperature?

    /// Reference to dive site
    public var divenumber: Int?

    /// Notes or comments before the dive
    public var notes: UDDFNotes?

    public init(
        datetime: Date? = nil,
        airtemperature: UDDFTemperature? = nil,
        divenumber: Int? = nil,
        notes: UDDFNotes? = nil
    ) {
        self.datetime = datetime
        self.airtemperature = airtemperature
        self.divenumber = divenumber
        self.notes = notes
    }
}

/// Information recorded after the dive
public struct UDDFInformationAfterDive: Codable, Equatable {
    /// Lowest temperature during the dive
    public var lowesttemperature: UDDFTemperature?

    /// Greatest depth reached during the dive
    public var greatestdepth: UDDFDepth?

    /// Average depth during the dive
    public var averagedepth: UDDFDepth?

    /// Total dive time
    public var diveduration: UDDFDuration?

    /// Notes or comments after the dive
    public var notes: UDDFNotes?

    public init(
        lowesttemperature: UDDFTemperature? = nil,
        greatestdepth: UDDFDepth? = nil,
        averagedepth: UDDFDepth? = nil,
        diveduration: UDDFDuration? = nil,
        notes: UDDFNotes? = nil
    ) {
        self.lowesttemperature = lowesttemperature
        self.greatestdepth = greatestdepth
        self.averagedepth = averagedepth
        self.diveduration = diveduration
        self.notes = notes
    }
}

/// Notes or comments (text content)
public struct UDDFNotes: Codable, Equatable {
    /// Link to related note/media
    public var link: UDDFLink?

    /// Text content of the note
    public var para: [String]?

    public init(link: UDDFLink? = nil, para: [String]? = nil) {
        self.link = link
        self.para = para
    }
}

/// Reference link
public struct UDDFLink: Codable, Equatable {
    /// Reference ID
    public var ref: String?

    public init(ref: String? = nil) {
        self.ref = ref
    }

    enum CodingKeys: String, CodingKey {
        case ref
    }
}

// MARK: - DynamicNodeEncoding

extension UDDFLink: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let codingKey = key as? CodingKeys else {
            return .element
        }

        switch codingKey {
        case .ref:
            return .attribute
        }
    }
}
