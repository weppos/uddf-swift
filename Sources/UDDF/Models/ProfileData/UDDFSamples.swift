import Foundation

/// Container for dive profile samples (waypoints)
///
/// Samples are waypoints recorded during the dive, typically at regular intervals.
/// Each waypoint contains depth, time, and optionally temperature and other data.
public struct UDDFSamples: Codable, Equatable {
    /// Individual waypoints
    public var waypoint: [UDDFWaypoint]?

    public init(waypoint: [UDDFWaypoint]? = nil) {
        self.waypoint = waypoint
    }
}

/// A single waypoint in the dive profile
///
/// Represents a point in time during the dive with depth and other measurements.
public struct UDDFWaypoint: Codable, Equatable {
    /// Time since dive start (in seconds)
    public var divetime: UDDFDuration?

    /// Depth at this waypoint
    public var depth: UDDFDepth?

    /// Temperature at this waypoint
    public var temperature: UDDFTemperature?

    /// Tank pressure at this waypoint
    public var tankpressure: UDDFPressure?

    /// Alarm or warning at this waypoint
    public var alarm: String?

    public init(
        divetime: UDDFDuration? = nil,
        depth: UDDFDepth? = nil,
        temperature: UDDFTemperature? = nil,
        tankpressure: UDDFPressure? = nil,
        alarm: String? = nil
    ) {
        self.divetime = divetime
        self.depth = depth
        self.temperature = temperature
        self.tankpressure = tankpressure
        self.alarm = alarm
    }
}
