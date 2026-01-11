import Foundation
import XMLCoder

/// Surface interval before a dive
///
/// Represents the time spent on the surface before starting the dive,
/// including any altitude changes during travel to the dive site.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/surfaceintervalbeforedive.html
public struct SurfaceIntervalBeforeDive: Codable, Equatable, Sendable {
    /// Time elapsed on the surface before this dive
    ///
    /// - Unit: seconds (SI)
    public var passedtime: Duration?

    /// Indicates unlimited/infinite surface interval (e.g., first dive of the day)
    ///
    /// When true, encoded as `<infinity/>` empty element.
    public var infinity: Bool?

    /// Altitude exposure during the surface interval
    public var exposuretoaltitude: ExposureToAltitude?

    /// Altitude waypoints during travel to dive site
    public var wayaltitude: [WayAltitude]?

    public init(
        passedtime: Duration? = nil,
        infinity: Bool? = nil,
        exposuretoaltitude: ExposureToAltitude? = nil,
        wayaltitude: [WayAltitude]? = nil
    ) {
        self.passedtime = passedtime
        self.infinity = infinity
        self.exposuretoaltitude = exposuretoaltitude
        self.wayaltitude = wayaltitude
    }

    enum CodingKeys: String, CodingKey {
        case passedtime
        case infinity
        case exposuretoaltitude
        case wayaltitude
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        passedtime = try container.decodeIfPresent(Duration.self, forKey: .passedtime)

        // Decode infinity as an empty element - if the key exists, it's true
        if container.contains(.infinity) {
            infinity = true
        } else {
            infinity = nil
        }

        exposuretoaltitude = try container.decodeIfPresent(ExposureToAltitude.self, forKey: .exposuretoaltitude)
        wayaltitude = try container.decodeIfPresent([WayAltitude].self, forKey: .wayaltitude)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(passedtime, forKey: .passedtime)

        // Encode infinity as empty element only if true
        if infinity == true {
            try container.encode("", forKey: .infinity)
        }

        try container.encodeIfPresent(exposuretoaltitude, forKey: .exposuretoaltitude)
        try container.encodeIfPresent(wayaltitude, forKey: .wayaltitude)
    }
}

/// Altitude exposure information during surface interval
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/exposuretoaltitude.html
public struct ExposureToAltitude: Codable, Equatable, Sendable {
    /// Altitude exposed to
    ///
    /// - Unit: meters (SI)
    public var altitude: Altitude?

    /// Duration of exposure at this altitude
    ///
    /// - Unit: seconds (SI)
    public var exposuretime: Duration?

    public init(
        altitude: Altitude? = nil,
        exposuretime: Duration? = nil
    ) {
        self.altitude = altitude
        self.exposuretime = exposuretime
    }
}

/// Altitude waypoint during travel to dive site
///
/// Records altitude changes during travel, with time and altitude values.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/wayaltitude.html
public struct WayAltitude: Codable, Equatable, Sendable {
    /// Time since start of travel
    ///
    /// - Unit: seconds (SI)
    public var waytime: Duration?

    /// Altitude at this waypoint
    ///
    /// - Unit: meters (SI)
    public var altitude: Altitude?

    public init(
        waytime: Duration? = nil,
        altitude: Altitude? = nil
    ) {
        self.waytime = waytime
        self.altitude = altitude
    }

    enum CodingKeys: String, CodingKey {
        case waytime
        case altitude
    }
}

// MARK: - DynamicNodeEncoding

extension WayAltitude: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let codingKey = key as? CodingKeys else {
            return .element
        }

        switch codingKey {
        case .waytime:
            return .attribute
        case .altitude:
            return .element
        }
    }
}
