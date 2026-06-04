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
    /// Alarms or warnings recorded at this waypoint
    public var alarm: [Alarm]

    /// Battery charge conditions recorded at this waypoint
    public var batterychargecondition: [BatteryChargeCondition]

    /// Diver's body temperature at this waypoint
    ///
    /// - Unit: Kelvin (SI)
    ///
    /// Added in UDDF 3.2.2. The temperature persists until another
    /// `<bodytemperature>` is recorded.
    public var bodytemperature: Temperature?

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
    public var gradientfactor: GradientFactor?

    /// Compass heading at this waypoint
    ///
    /// - Unit: degrees (0-360)
    ///
    /// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/heading.html
    public var heading: Double?

    /// Diver's heart rate at this waypoint
    ///
    /// - Unit: beats per second (SI 1/s); divide BPM by 60 to convert.
    ///
    /// Added as a spec element in UDDF 3.2.3. Prior to 3.2.3 this library
    /// exposed `heartrate` as a `UInt?` BPM extension; consumers using that
    /// shape must migrate to the SI `Double` form.
    public var heartrate: Double?

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

    /// Diver's pulse rate at this waypoint
    ///
    /// - Unit: beats per second (SI 1/s); divide BPM by 60 to convert.
    ///
    /// Added in UDDF 3.2.2. The pulse rate persists until another
    /// `<pulserate>` is recorded.
    public var pulserate: Double?

    /// Remaining bottom time at this waypoint (time before ascent required)
    public var remainingbottomtime: Duration?

    /// Remaining time in seconds until oxygen becomes toxic at this waypoint
    ///
    /// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/remainingo2time.html
    public var remainingo2time: Duration?

    /// User-set markers recorded at this waypoint (e.g. dive computer "mark" button presses)
    ///
    /// Multiple markers may be recorded per waypoint. Free-form alphanumeric text.
    /// Added in UDDF 3.2.2.
    public var setmarker: [String]

    /// Rebreather setpoint (PPO2) at this waypoint
    ///
    /// - Unit: pascals (SI)
    public var setpo2: SetPO2?

    /// Reference to gas mix being used (for gas switches)
    public var switchmix: SwitchMix?

    /// Tank pressure at this waypoint
    public var tankpressure: [TankPressure]

    /// Temperature at this waypoint
    public var temperature: Temperature?

    // MARK: - Non-spec extensions

    /// Time-to-surface at this waypoint (decompression time required)
    ///
    /// - Note: EXTENSION — not part of UDDF 3.2.3 specification.
    ///   Emitted by Shearwater Cloud Desktop; preserved on round-trip.
    public var tts: Duration?

    public init(
        alarm: [Alarm] = [],
        batterychargecondition: [BatteryChargeCondition] = [],
        bodytemperature: Temperature? = nil,
        calculatedpo2: Pressure? = nil,
        cns: Double? = nil,
        decostop: DecoStop? = nil,
        depth: Depth? = nil,
        divemode: DiveMode? = nil,
        divetime: Duration? = nil,
        gradientfactor: GradientFactor? = nil,
        heading: Double? = nil,
        heartrate: Double? = nil,
        measuredpo2: [MeasuredPO2] = [],
        nodecotime: Duration? = nil,
        otu: Double? = nil,
        pulserate: Double? = nil,
        remainingbottomtime: Duration? = nil,
        remainingo2time: Duration? = nil,
        setmarker: [String] = [],
        setpo2: SetPO2? = nil,
        switchmix: SwitchMix? = nil,
        tankpressure: [TankPressure] = [],
        temperature: Temperature? = nil,
        tts: Duration? = nil
    ) {
        self.alarm = alarm
        self.batterychargecondition = batterychargecondition
        self.bodytemperature = bodytemperature
        self.calculatedpo2 = calculatedpo2
        self.cns = cns
        self.decostop = decostop
        self.depth = depth
        self.divemode = divemode
        self.divetime = divetime
        self.gradientfactor = gradientfactor
        self.heading = heading
        self.heartrate = heartrate
        self.measuredpo2 = measuredpo2
        self.nodecotime = nodecotime
        self.otu = otu
        self.pulserate = pulserate
        self.remainingbottomtime = remainingbottomtime
        self.remainingo2time = remainingo2time
        self.setmarker = setmarker
        self.setpo2 = setpo2
        self.switchmix = switchmix
        self.tankpressure = tankpressure
        self.temperature = temperature
        self.tts = tts
    }

    enum CodingKeys: String, CodingKey {
        case alarm
        case batterychargecondition
        case bodytemperature
        case calculatedpo2
        case cns
        case decostop
        case depth
        case divemode
        case divetime
        case gradientfactor
        case heading
        case heartrate
        case measuredpo2
        case nodecotime
        case otu
        case pulserate
        case remainingbottomtime
        case remainingo2time
        case setmarker
        case setpo2
        case switchmix
        case tankpressure
        case temperature
        case tts
    }

    /// Decoding is hand-written (encoding is synthesized) for one reason: the
    /// repeated-element arrays (`alarm`, `batterychargecondition`, `measuredpo2`,
    /// `setmarker`, `tankpressure`) are non-optional and must default to empty
    /// when the elements are absent, which synthesized `Decodable` cannot express
    /// (it throws on a missing key). Every field is still listed here, so
    /// `testWaypointEveryFieldRoundTrips` guards against a field being dropped.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alarm = try container.decodeIfPresent([Alarm].self, forKey: .alarm) ?? []
        batterychargecondition = try container.decodeIfPresent([BatteryChargeCondition].self, forKey: .batterychargecondition) ?? []
        bodytemperature = try container.decodeIfPresent(Temperature.self, forKey: .bodytemperature)
        calculatedpo2 = try container.decodeIfPresent(Pressure.self, forKey: .calculatedpo2)
        cns = try container.decodeIfPresent(Double.self, forKey: .cns)
        decostop = try container.decodeIfPresent(DecoStop.self, forKey: .decostop)
        depth = try container.decodeIfPresent(Depth.self, forKey: .depth)
        divemode = try container.decodeIfPresent(DiveMode.self, forKey: .divemode)
        divetime = try container.decodeIfPresent(Duration.self, forKey: .divetime)
        gradientfactor = try container.decodeIfPresent(GradientFactor.self, forKey: .gradientfactor)
        heading = try container.decodeIfPresent(Double.self, forKey: .heading)
        heartrate = try container.decodeIfPresent(Double.self, forKey: .heartrate)
        measuredpo2 = try container.decodeIfPresent([MeasuredPO2].self, forKey: .measuredpo2) ?? []
        nodecotime = try container.decodeIfPresent(Duration.self, forKey: .nodecotime)
        otu = try container.decodeIfPresent(Double.self, forKey: .otu)
        pulserate = try container.decodeIfPresent(Double.self, forKey: .pulserate)
        remainingbottomtime = try container.decodeIfPresent(Duration.self, forKey: .remainingbottomtime)
        remainingo2time = try container.decodeIfPresent(Duration.self, forKey: .remainingo2time)
        setmarker = try container.decodeIfPresent([String].self, forKey: .setmarker) ?? []
        setpo2 = try container.decodeIfPresent(SetPO2.self, forKey: .setpo2)
        switchmix = try container.decodeIfPresent(SwitchMix.self, forKey: .switchmix)
        tankpressure = try container.decodeIfPresent([TankPressure].self, forKey: .tankpressure) ?? []
        temperature = try container.decodeIfPresent(Temperature.self, forKey: .temperature)
        tts = try container.decodeIfPresent(Duration.self, forKey: .tts)
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
        ///
        /// Encoded as `"apnea"`. UDDF 3.2.2 renamed `"apnoe"` to `"apnea"`;
        /// the decoder accepts both spellings for backwards compatibility.
        case apnea

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
            case .apnea: return "apnea"
            case .closedCircuit: return "closedcircuit"
            case .openCircuit: return "opencircuit"
            case .semiClosedCircuit: return "semiclosedcircuit"
            case .unknown(let value): return value
            }
        }

        /// Initialize from a raw string value
        ///
        /// Standard UDDF values map to known cases, all others to `.unknown(String)`.
        /// The legacy `"apnoe"` spelling (pre-UDDF 3.2.2) decodes to `.apnea`.
        public init(rawValue: String) {
            switch rawValue {
            case "apnea", "apnoe": self = .apnea
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

// MARK: - Alarm

/// Alarm or warning recorded at a waypoint.
///
/// The element text is the alarm category. UDDF defines an `alarmType`
/// enumeration (`ascent`, `breath`, `deco`, `error`, `link`, `microbubbles`,
/// `rbt`, `skincooling`, `surface`), but dive computers emit non-spec values,
/// so the text is preserved verbatim as a `String`.
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/alarm.html
public struct Alarm: Codable, Equatable, Sendable {
    /// The alarm category text.
    public var value: String

    /// Optional severity or threshold level associated with the alarm.
    @Attribute public var level: Double?

    public init(_ value: String, level: Double? = nil) {
        self.value = value
        self._level = Attribute(level)
    }

    enum CodingKeys: String, CodingKey {
        case level
        case value = ""
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _level = try container.decodeIfPresent(Attribute<Double?>.self, forKey: .level) ?? Attribute(nil)
        value = try container.decodeTrimmedIntrinsicValue(forKey: .value)
    }
}

// MARK: - BatteryChargeCondition

/// Battery charge condition reading recorded at a waypoint.
///
/// The element text is the battery state (typically a voltage). The XSD marks
/// `deviceref` as required (it ties the reading to a `<divecomputer>`), but the
/// parser keeps it optional to tolerate real-world files that omit it.
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/batterychargecondition.html
public struct BatteryChargeCondition: Codable, Equatable, Sendable {
    /// The battery charge value (typically voltage).
    public var value: Double

    /// Reference to the device this reading belongs to (a `<divecomputer>` ID).
    @Attribute public var deviceref: String?

    /// Optional reference to the associated tank (a `<tank>` ID) for transmitters.
    @Attribute public var tankref: String?

    public init(_ value: Double, deviceref: String? = nil, tankref: String? = nil) {
        self.value = value
        self._deviceref = Attribute(deviceref)
        self._tankref = Attribute(tankref)
    }

    enum CodingKeys: String, CodingKey {
        case deviceref
        case tankref
        case value = ""
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _deviceref = try container.decodeIfPresent(Attribute<String?>.self, forKey: .deviceref) ?? Attribute(nil)
        _tankref = try container.decodeIfPresent(Attribute<String?>.self, forKey: .tankref) ?? Attribute(nil)
        value = try container.decodeTrimmedIntrinsicValue(forKey: .value)
    }
}

// MARK: - GradientFactor

/// Gradient factor recorded at a waypoint.
///
/// The element text is the gradient factor value; the optional `tissue`
/// attribute identifies the controlling tissue compartment.
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/gradientfactor.html
public struct GradientFactor: Codable, Equatable, Sendable {
    /// The gradient factor value.
    public var value: Double

    /// Optional index of the controlling tissue compartment.
    @Attribute public var tissue: Int?

    public init(_ value: Double, tissue: Int? = nil) {
        self.value = value
        self._tissue = Attribute(tissue)
    }

    enum CodingKeys: String, CodingKey {
        case tissue
        case value = ""
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _tissue = try container.decodeIfPresent(Attribute<Int?>.self, forKey: .tissue) ?? Attribute(nil)
        value = try container.decodeTrimmedIntrinsicValue(forKey: .value)
    }
}

// MARK: - SetPO2

/// Rebreather oxygen setpoint recorded at a waypoint.
///
/// The element text is the setpoint partial pressure (pascals, SI). The XSD
/// marks the `setby` attribute as required (it records whether the diver or
/// the computer chose the setpoint), but the parser keeps it optional to
/// tolerate files that omit it.
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setpo2.html
public struct SetPO2: Codable, Equatable, Sendable {
    /// Who established the setpoint.
    ///
    /// Uses a hybrid enum to gracefully handle unknown values while providing
    /// type safety for the standard UDDF values.
    public enum SetBy: Equatable, Sendable {
        /// The diver set the value manually.
        case user
        /// The dive computer set the value automatically.
        case computer
        /// Non-standard or unknown origin.
        case unknown(String)

        /// The raw string value for this origin.
        public var rawValue: String {
            switch self {
            case .user: return "user"
            case .computer: return "computer"
            case .unknown(let value): return value
            }
        }

        /// Initialize from a raw string value.
        ///
        /// Standard UDDF values map to known cases, all others to `.unknown(String)`.
        public init(rawValue: String) {
            switch rawValue {
            case "user": self = .user
            case "computer": self = .computer
            default: self = .unknown(rawValue)
            }
        }

        /// Whether this is a standard UDDF `setby` value.
        public var isStandard: Bool {
            if case .unknown = self {
                return false
            }
            return true
        }
    }

    /// Who established the setpoint (`user` or `computer`).
    @Attribute public var setby: SetBy?

    /// Setpoint partial pressure of oxygen, in pascals (SI).
    public var pascals: Double

    public init(pressure: Pressure, setby: SetBy? = nil) {
        self.pascals = pressure.pascals
        self._setby = Attribute(setby)
    }

    public init(pascals: Double, setby: SetBy? = nil) {
        self.pascals = pascals
        self._setby = Attribute(setby)
    }

    public init(bar: Double, setby: SetBy? = nil) {
        self.init(pascals: Pressure(bar: bar).pascals, setby: setby)
    }

    /// Setpoint as a `Pressure`.
    public var pressure: Pressure {
        get { Pressure(pascals: pascals) }
        set { pascals = newValue.pascals }
    }

    /// Setpoint in bar.
    public var bar: Double {
        pressure.bar
    }

    enum CodingKeys: String, CodingKey {
        case setby
        case pascals = ""
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _setby = try container.decodeIfPresent(Attribute<SetBy?>.self, forKey: .setby) ?? Attribute(nil)
        pascals = try container.decodeTrimmedIntrinsicValue(forKey: .pascals)
    }
}

// MARK: - SetBy Codable

extension SetPO2.SetBy: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(rawValue: value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
