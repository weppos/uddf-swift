import Foundation
import XMLCoder

/// Container for dive profile samples (waypoints)
///
/// Samples are waypoints recorded during the dive, typically at regular intervals.
/// Each waypoint contains depth, time, and optionally temperature and other data.
public struct Samples: Codable, Equatable, Sendable {
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
public struct Waypoint: Codable, Equatable, Sendable {
    /// Alarm or warning at this waypoint
    public var alarm: String?

    /// Battery charge/voltage at this waypoint
    public var batterychargecondition: Double?

    /// Calculated partial pressure of oxygen (PPO2)
    ///
    /// - Unit: pascals (SI)
    public var calculatedpo2: Pressure?

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

    /// Compass heading at this waypoint
    ///
    /// - Unit: degrees (0-360)
    ///
    /// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/heading.html
    public var heading: Double?

    /// Measured partial pressure of oxygen (PPO2) from sensors
    ///
    /// - Unit: pascals (SI)
    public var measuredpo2: [MeasuredPO2]

    /// No-decompression time remaining at this waypoint
    public var nodecotime: Duration?

    /// Oxygen Toxicity Units at this waypoint
    ///
    /// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/otu.html
    public var otu: Double?

    /// Remaining bottom time at this waypoint (time before ascent required)
    public var remainingbottomtime: Duration?

    /// Remaining time in seconds until oxygen becomes toxic at this waypoint
    ///
    /// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/remainingo2time.html
    public var remainingo2time: Duration?

    /// Rebreather setpoint (PPO2) at this waypoint
    ///
    /// - Unit: pascals (SI)
    public var setpo2: Pressure?

    /// Reference to gas mix being used (for gas switches)
    public var switchmix: SwitchMix?

    /// Tank pressure at this waypoint
    public var tankpressure: [TankPressure]

    /// Temperature at this waypoint
    public var temperature: Temperature?

    /// Time-to-surface at this waypoint (decompression time required)
    public var tts: Duration?

    // MARK: - Extensions

    /// Heart rate at this waypoint (beats per minute)
    ///
    /// - Note: EXTENSION - Not part of UDDF 3.2.1 specification.
    ///   Used by dive computers with heart rate monitoring (e.g., Garmin Descent series).
    public var heartrate: UInt?

    public init(
        alarm: String? = nil,
        batterychargecondition: Double? = nil,
        calculatedpo2: Pressure? = nil,
        cns: Double? = nil,
        decostop: DecoStop? = nil,
        depth: Depth? = nil,
        divemode: DiveMode? = nil,
        divetime: Duration? = nil,
        gradientfactor: Double? = nil,
        heading: Double? = nil,
        measuredpo2: [MeasuredPO2] = [],
        nodecotime: Duration? = nil,
        otu: Double? = nil,
        remainingbottomtime: Duration? = nil,
        remainingo2time: Duration? = nil,
        setpo2: Pressure? = nil,
        switchmix: SwitchMix? = nil,
        tankpressure: [TankPressure] = [],
        temperature: Temperature? = nil,
        tts: Duration? = nil,
        heartrate: UInt? = nil
    ) {
        self.alarm = alarm
        self.batterychargecondition = batterychargecondition
        self.calculatedpo2 = calculatedpo2
        self.cns = cns
        self.decostop = decostop
        self.depth = depth
        self.divemode = divemode
        self.divetime = divetime
        self.gradientfactor = gradientfactor
        self.heading = heading
        self.measuredpo2 = measuredpo2
        self.nodecotime = nodecotime
        self.otu = otu
        self.remainingbottomtime = remainingbottomtime
        self.remainingo2time = remainingo2time
        self.setpo2 = setpo2
        self.switchmix = switchmix
        self.tankpressure = tankpressure
        self.temperature = temperature
        self.tts = tts
        self.heartrate = heartrate
    }

    enum CodingKeys: String, CodingKey {
        case alarm
        case batterychargecondition
        case calculatedpo2
        case cns
        case decostop
        case depth
        case divemode
        case divetime
        case gradientfactor
        case heading
        case measuredpo2
        case nodecotime
        case otu
        case remainingbottomtime
        case remainingo2time
        case setpo2
        case switchmix
        case tankpressure
        case temperature
        case tts
        case heartrate
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alarm = try container.decodeIfPresent(String.self, forKey: .alarm)
        batterychargecondition = try container.decodeIfPresent(Double.self, forKey: .batterychargecondition)
        calculatedpo2 = try container.decodeIfPresent(Pressure.self, forKey: .calculatedpo2)
        cns = try container.decodeIfPresent(Double.self, forKey: .cns)
        decostop = try container.decodeIfPresent(DecoStop.self, forKey: .decostop)
        depth = try container.decodeIfPresent(Depth.self, forKey: .depth)
        divemode = try container.decodeIfPresent(DiveMode.self, forKey: .divemode)
        divetime = try container.decodeIfPresent(Duration.self, forKey: .divetime)
        gradientfactor = try container.decodeIfPresent(Double.self, forKey: .gradientfactor)
        heading = try container.decodeIfPresent(Double.self, forKey: .heading)
        measuredpo2 = try container.decodeIfPresent([MeasuredPO2].self, forKey: .measuredpo2) ?? []
        nodecotime = try container.decodeIfPresent(Duration.self, forKey: .nodecotime)
        otu = try container.decodeIfPresent(Double.self, forKey: .otu)
        remainingbottomtime = try container.decodeIfPresent(Duration.self, forKey: .remainingbottomtime)
        remainingo2time = try container.decodeIfPresent(Duration.self, forKey: .remainingo2time)
        setpo2 = try container.decodeIfPresent(Pressure.self, forKey: .setpo2)
        switchmix = try container.decodeIfPresent(SwitchMix.self, forKey: .switchmix)
        tankpressure = try container.decodeIfPresent([TankPressure].self, forKey: .tankpressure) ?? []
        temperature = try container.decodeIfPresent(Temperature.self, forKey: .temperature)
        tts = try container.decodeIfPresent(Duration.self, forKey: .tts)
        heartrate = try container.decodeIfPresent(UInt.self, forKey: .heartrate)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(alarm, forKey: .alarm)
        try container.encodeIfPresent(batterychargecondition, forKey: .batterychargecondition)
        try container.encodeIfPresent(calculatedpo2, forKey: .calculatedpo2)
        try container.encodeIfPresent(cns, forKey: .cns)
        try container.encodeIfPresent(decostop, forKey: .decostop)
        try container.encodeIfPresent(depth, forKey: .depth)
        try container.encodeIfPresent(divemode, forKey: .divemode)
        try container.encodeIfPresent(divetime, forKey: .divetime)
        try container.encodeIfPresent(gradientfactor, forKey: .gradientfactor)
        try container.encodeIfPresent(heading, forKey: .heading)
        for reading in measuredpo2 {
            let encoder = container.superEncoder(forKey: .measuredpo2)
            try reading.encode(to: encoder)
        }
        try container.encodeIfPresent(nodecotime, forKey: .nodecotime)
        try container.encodeIfPresent(otu, forKey: .otu)
        try container.encodeIfPresent(remainingbottomtime, forKey: .remainingbottomtime)
        try container.encodeIfPresent(remainingo2time, forKey: .remainingo2time)
        try container.encodeIfPresent(setpo2, forKey: .setpo2)
        try container.encodeIfPresent(switchmix, forKey: .switchmix)
        for pressure in tankpressure {
            let encoder = container.superEncoder(forKey: .tankpressure)
            try pressure.encode(to: encoder)
        }
        try container.encodeIfPresent(temperature, forKey: .temperature)
        try container.encodeIfPresent(tts, forKey: .tts)
        try container.encodeIfPresent(heartrate, forKey: .heartrate)
    }
}

/// Reference to a gas mix (for gas switches during dive)
public struct SwitchMix: Codable, Equatable, Sendable {
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
///
/// See: https://www.streit.cc/resources/UDDF/v3.2.3/en/divemode.html
public struct DiveMode: Codable, Equatable, Sendable {
    /// Type of dive mode
    ///
    /// Specifies the breathing apparatus mode used at this waypoint.
    /// Uses a hybrid enum to gracefully handle unknown values while providing
    /// type safety for standard UDDF values.
    public enum ModeType: Equatable, Sendable {
        /// Freediving (breath-hold diving)
        case apnoe

        /// Closed-circuit rebreather
        case closedCircuit

        /// Open-circuit scuba
        case openCircuit

        /// Semi-closed rebreather
        case semiClosedCircuit

        /// Non-standard or unknown dive mode
        case unknown(String)

        /// The raw string value for this mode type
        public var rawValue: String {
            switch self {
            case .apnoe: return "apnoe"
            case .closedCircuit: return "closedcircuit"
            case .openCircuit: return "opencircuit"
            case .semiClosedCircuit: return "semiclosedcircuit"
            case .unknown(let value): return value
            }
        }

        /// Initialize from a raw string value
        ///
        /// Standard UDDF values map to known cases, all others to `.unknown(String)`
        public init(rawValue: String) {
            switch rawValue {
            case "apnoe": self = .apnoe
            case "closedcircuit": self = .closedCircuit
            case "opencircuit": self = .openCircuit
            case "semiclosedcircuit": self = .semiClosedCircuit
            default: self = .unknown(rawValue)
            }
        }

        /// Returns true if this is a standard UDDF dive mode
        public var isStandard: Bool {
            if case .unknown = self {
                return false
            }
            return true
        }
    }

    /// The dive mode type at this waypoint
    public var type: ModeType?

    public init(type: ModeType? = nil) {
        self.type = type
    }

    enum CodingKeys: String, CodingKey {
        case type
    }
}

// MARK: - ModeType Codable

extension DiveMode.ModeType: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(rawValue: value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
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
///
/// Represents a required or recommended decompression stop during ascent.
public struct DecoStop: Codable, Equatable, Sendable {
    /// Kind of decompression stop
    ///
    /// Specifies whether the stop is mandatory (required for safety)
    /// or a safety stop (recommended but not required).
    /// Uses a hybrid enum to gracefully handle unknown values.
    public enum StopKind: Equatable, Sendable {
        /// Mandatory decompression stop (required)
        case mandatory

        /// Safety stop (recommended)
        case safety

        /// Non-standard or unknown stop kind
        case unknown(String)

        /// The raw string value for this stop kind
        public var rawValue: String {
            switch self {
            case .mandatory: return "mandatory"
            case .safety: return "safety"
            case .unknown(let value): return value
            }
        }

        /// Initialize from a raw string value
        ///
        /// Standard UDDF values map to known cases, all others to `.unknown(String)`
        public init(rawValue: String) {
            switch rawValue {
            case "mandatory": self = .mandatory
            case "safety": self = .safety
            default: self = .unknown(rawValue)
            }
        }

        /// Returns true if this is a standard UDDF stop kind
        public var isStandard: Bool {
            if case .unknown = self {
                return false
            }
            return true
        }
    }

    /// The kind of decompression stop
    public var kind: StopKind?

    /// Depth of the decompression stop (in meters)
    public var decodepth: Double?

    /// Duration of the decompression stop (in seconds)
    public var duration: Double?

    public init(
        kind: StopKind? = nil,
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

// MARK: - StopKind Codable

extension DecoStop.StopKind: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(rawValue: value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
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
