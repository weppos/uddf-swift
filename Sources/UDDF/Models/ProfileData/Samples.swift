import Foundation
import XMLCoder

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
/// Fields are alphabetically ordered to match UDDF spec.
public struct Waypoint: Codable, Equatable {
    /// Alarm or warning at this waypoint
    public var alarm: String?

    /// Battery charge/voltage at this waypoint
    public var batterychargecondition: Double?

    /// Calculated partial pressure of oxygen (PPO2)
    public var calculatedpo2: Double?

    /// Decompression ceiling depth at this waypoint
    public var ceiling: Depth?

    /// Central Nervous System (CNS) oxygen toxicity percentage at this waypoint
    public var cns: Double?

    /// Decompression stop information at this waypoint
    public var decostop: DecoStop?

    /// Depth at this waypoint
    public var depth: Depth?

    /// Dive mode at this waypoint (e.g., open circuit, closed circuit)
    public var divemode: DiveMode?

    /// Time since dive start (in seconds)
    public var divetime: Duration?

    /// Gradient factor at this waypoint (decompression calculation)
    public var gradientfactor: Double?

    /// Heart rate at this waypoint (beats per minute)
    public var heartrate: UInt?

    /// No-decompression time remaining at this waypoint
    public var nodecotime: Duration?

    /// Reference to gas mix being used (for gas switches)
    public var switchmix: SwitchMix?

    /// Tank pressure at this waypoint
    public var tankpressure: Pressure?

    /// Temperature at this waypoint
    public var temperature: Temperature?

    /// Time-to-surface at this waypoint (decompression time required)
    public var tts: Duration?

    public init(
        alarm: String? = nil,
        batterychargecondition: Double? = nil,
        calculatedpo2: Double? = nil,
        ceiling: Depth? = nil,
        cns: Double? = nil,
        decostop: DecoStop? = nil,
        depth: Depth? = nil,
        divemode: DiveMode? = nil,
        divetime: Duration? = nil,
        gradientfactor: Double? = nil,
        heartrate: UInt? = nil,
        nodecotime: Duration? = nil,
        switchmix: SwitchMix? = nil,
        tankpressure: Pressure? = nil,
        temperature: Temperature? = nil,
        tts: Duration? = nil
    ) {
        self.alarm = alarm
        self.batterychargecondition = batterychargecondition
        self.calculatedpo2 = calculatedpo2
        self.ceiling = ceiling
        self.cns = cns
        self.decostop = decostop
        self.depth = depth
        self.divemode = divemode
        self.divetime = divetime
        self.gradientfactor = gradientfactor
        self.heartrate = heartrate
        self.nodecotime = nodecotime
        self.switchmix = switchmix
        self.tankpressure = tankpressure
        self.temperature = temperature
        self.tts = tts
    }
}

/// Reference to a gas mix (for gas switches during dive)
public struct SwitchMix: Codable, Equatable {
    /// Reference to a mix ID from gasdefinitions
    public var ref: String?

    public init(ref: String? = nil) {
        self.ref = ref
    }

    enum CodingKeys: String, CodingKey {
        case ref
    }
}

// MARK: - DynamicNodeEncoding

extension SwitchMix: DynamicNodeEncoding {
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

/// Dive mode at a waypoint (open circuit, closed circuit, etc.)
public struct DiveMode: Codable, Equatable {
    /// Type of dive mode (e.g., "opencircuit", "closedcircuit", "gauge")
    public var type: String?

    public init(type: String? = nil) {
        self.type = type
    }

    enum CodingKeys: String, CodingKey {
        case type
    }
}

// MARK: - DynamicNodeEncoding

extension DiveMode: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let codingKey = key as? CodingKeys else {
            return .element
        }

        switch codingKey {
        case .type:
            return .attribute
        }
    }
}

/// Decompression stop information at a waypoint
public struct DecoStop: Codable, Equatable {
    /// Kind of decompression stop (e.g., "mandatory", "safety")
    public var kind: String?

    /// Depth of the decompression stop (in meters)
    public var decodepth: Double?

    /// Duration of the decompression stop (in seconds)
    public var duration: Double?

    public init(
        kind: String? = nil,
        decodepth: Double? = nil,
        duration: Double? = nil
    ) {
        self.kind = kind
        self.decodepth = decodepth
        self.duration = duration
    }

    enum CodingKeys: String, CodingKey {
        case kind
        case decodepth
        case duration
    }
}

// MARK: - DynamicNodeEncoding

extension DecoStop: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let codingKey = key as? CodingKeys else {
            return .element
        }

        switch codingKey {
        case .kind, .decodepth, .duration:
            return .attribute
        }
    }
}
