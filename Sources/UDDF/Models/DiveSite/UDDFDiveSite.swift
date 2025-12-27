import Foundation
import XMLCoder

/// Dive site information
///
/// Contains location and environmental information about a dive site.
public struct UDDFDiveSite: Codable, Equatable {
    /// Unique identifier
    public var id: String?

    /// Name of the dive site
    public var name: String?

    /// Geographic information (coordinates, location)
    public var geography: UDDFGeography?

    /// Description and notes
    public var notes: UDDFNotes?

    /// Site ratings or information
    public var sitedata: UDDFSiteData?

    public init(
        id: String? = nil,
        name: String? = nil,
        geography: UDDFGeography? = nil,
        notes: UDDFNotes? = nil,
        sitedata: UDDFSiteData? = nil
    ) {
        self.id = id
        self.name = name
        self.geography = geography
        self.notes = notes
        self.sitedata = sitedata
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case geography
        case notes
        case sitedata
    }
}

// MARK: - DynamicNodeEncoding

extension UDDFDiveSite: DynamicNodeEncoding {
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

/// Geographic location information
public struct UDDFGeography: Codable, Equatable {
    /// Location description
    public var location: String?

    /// GPS coordinates
    public var gps: UDDFGPS?

    /// Timezone
    public var timezone: String?

    /// Altitude (meters above sea level)
    public var altitude: Double?

    public init(
        location: String? = nil,
        gps: UDDFGPS? = nil,
        timezone: String? = nil,
        altitude: Double? = nil
    ) {
        self.location = location
        self.gps = gps
        self.timezone = timezone
        self.altitude = altitude
    }
}

/// GPS coordinates
public struct UDDFGPS: Codable, Equatable {
    /// Latitude in decimal degrees
    public var latitude: Double?

    /// Longitude in decimal degrees
    public var longitude: Double?

    public init(latitude: Double? = nil, longitude: Double? = nil) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

/// Site data and ratings
public struct UDDFSiteData: Codable, Equatable {
    /// Difficulty rating
    public var difficulty: String?

    /// Maximum depth at the site
    public var maximumdepth: UDDFDepth?

    /// Average depth at the site
    public var averagedepth: UDDFDepth?

    public init(
        difficulty: String? = nil,
        maximumdepth: UDDFDepth? = nil,
        averagedepth: UDDFDepth? = nil
    ) {
        self.difficulty = difficulty
        self.maximumdepth = maximumdepth
        self.averagedepth = averagedepth
    }
}
