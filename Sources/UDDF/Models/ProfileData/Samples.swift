import Foundation

/// Container for dive profile samples (waypoints)
///
/// Samples are waypoints recorded during the dive, typically at regular intervals.
/// Each waypoint contains depth, time, and optionally temperature and other data.
public struct Samples: Codable, Equatable {
    /// Individual waypoints
    public var waypoint: [Waypoint]?

    public init(waypoint: [Waypoint]? = nil) {
        self.waypoint = waypoint
    }
}

/// A single waypoint in the dive profile
///
/// Represents a point in time during the dive with depth and other measurements.
public struct Waypoint: Codable, Equatable {
    /// Time since dive start (in seconds)
    public var divetime: Duration?

    /// Depth at this waypoint
    public var depth: Depth?

    /// Temperature at this waypoint
    public var temperature: Temperature?

    /// Tank pressure at this waypoint
    public var tankpressure: Pressure?

    /// Alarm or warning at this waypoint
    public var alarm: String?

    public init(
        divetime: Duration? = nil,
        depth: Depth? = nil,
        temperature: Temperature? = nil,
        tankpressure: Pressure? = nil,
        alarm: String? = nil
    ) {
        self.divetime = divetime
        self.depth = depth
        self.temperature = temperature
        self.tankpressure = tankpressure
        self.alarm = alarm
    }
}
