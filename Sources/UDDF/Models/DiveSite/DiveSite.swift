import Foundation
import XMLCoder

/// Dive site information
///
/// Contains location and environmental information about a dive site.
public struct DiveSite: Codable, Equatable, Sendable {
    /// Unique identifier
    public var id: String?

    /// Name of the dive site
    public var name: String?

    /// Geographic information (coordinates, location)
    public var geography: Geography?

    /// Description and notes
    public var notes: Notes?

    /// Site ratings or information
    public var sitedata: SiteData?

    public init(
        id: String? = nil,
        name: String? = nil,
        geography: Geography? = nil,
        notes: Notes? = nil,
        sitedata: SiteData? = nil
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

extension DiveSite: DynamicNodeEncoding {
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
public struct Geography: Codable, Equatable, Sendable {
    /// Location description
    public var location: String?

    /// GPS coordinates
    public var gps: GPS?

    /// Timezone
    public var timezone: String?

    /// Altitude (meters above sea level)
    public var altitude: Double?

    public init(
        location: String? = nil,
        gps: GPS? = nil,
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
public struct GPS: Codable, Equatable, Sendable {
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
public struct SiteData: Codable, Equatable, Sendable {
    /// Difficulty rating
    public var difficulty: String?

    /// Maximum depth at the site
    public var maximumdepth: Depth?

    /// Average depth at the site
    public var averagedepth: Depth?

    public init(
        difficulty: String? = nil,
        maximumdepth: Depth? = nil,
        averagedepth: Depth? = nil
    ) {
        self.difficulty = difficulty
        self.maximumdepth = maximumdepth
        self.averagedepth = averagedepth
    }
}
