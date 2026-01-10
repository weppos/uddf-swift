import Foundation
import XMLCoder

/// A single dive with profile data
///
/// Contains information before, during, and after the dive, including
/// samples (waypoints) recorded during the dive.
public struct Dive: Codable, Equatable, Sendable {
    /// Unique identifier for this dive
    public var id: String?

    /// Information recorded before the dive started
    public var informationbeforedive: InformationBeforeDive?

    /// Equipment used during this dive (tanks, weights, etc.)
    public var equipmentused: EquipmentUsed?

    /// Dive profile samples (waypoints)
    public var samples: Samples?

    /// Information recorded after the dive ended
    public var informationafterdive: InformationAfterDive?

    public init(
        id: String? = nil,
        informationbeforedive: InformationBeforeDive? = nil,
        equipmentused: EquipmentUsed? = nil,
        samples: Samples? = nil,
        informationafterdive: InformationAfterDive? = nil
    ) {
        self.id = id
        self.informationbeforedive = informationbeforedive
        self.equipmentused = equipmentused
        self.samples = samples
        self.informationafterdive = informationafterdive
    }

    enum CodingKeys: String, CodingKey {
        case id
        case informationbeforedive
        case equipmentused
        case samples
        case informationafterdive
    }
}

// MARK: - DynamicNodeEncoding

extension Dive: DynamicNodeEncoding {
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
public struct InformationBeforeDive: Codable, Equatable, Sendable {
    /// Date and time when the dive started
    public var datetime: Date?

    /// Air temperature at surface
    public var airtemperature: Temperature?

    /// Water salinity (fresh/salt) for the dive site.
    ///
    /// - Note: EXTENSION libdivecomputer export
    public var salinity: Salinity?

    /// Reference to dive site
    public var divenumber: Int?

    /// Notes or comments before the dive
    public var notes: Notes?

    public init(
        datetime: Date? = nil,
        airtemperature: Temperature? = nil,
        salinity: Salinity? = nil,
        divenumber: Int? = nil,
        notes: Notes? = nil
    ) {
        self.datetime = datetime
        self.airtemperature = airtemperature
        self.salinity = salinity
        self.divenumber = divenumber
        self.notes = notes
    }
}

/// Information recorded after the dive
public struct InformationAfterDive: Codable, Equatable, Sendable {
    /// Lowest temperature during the dive
    public var lowesttemperature: Temperature?

    /// Greatest depth reached during the dive
    public var greatestdepth: Depth?

    /// Average depth during the dive
    public var averagedepth: Depth?

    /// Total dive time
    public var diveduration: Duration?

    /// Notes or comments after the dive
    public var notes: Notes?

    public init(
        lowesttemperature: Temperature? = nil,
        greatestdepth: Depth? = nil,
        averagedepth: Depth? = nil,
        diveduration: Duration? = nil,
        notes: Notes? = nil
    ) {
        self.lowesttemperature = lowesttemperature
        self.greatestdepth = greatestdepth
        self.averagedepth = averagedepth
        self.diveduration = diveduration
        self.notes = notes
    }
}

/// Notes or comments (text content)
public struct Notes: Codable, Equatable, Sendable {
    /// Link to related note/media
    public var link: Link?

    /// Text content of the note
    public var para: [String]?

    public init(link: Link? = nil, para: [String]? = nil) {
        self.link = link
        self.para = para
    }
}

/// Reference link
public struct Link: Codable, Equatable, Sendable {
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

extension Link: DynamicNodeEncoding {
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
