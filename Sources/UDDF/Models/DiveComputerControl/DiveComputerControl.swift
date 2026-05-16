import Foundation
import XMLCoder

// MARK: - DiveComputerControl

/// Dive computer configuration and control
///
/// Container for dive computer programming, configuration, and data
/// download. The UDDF 3.2.3 spec defines three children of
/// `<divecomputercontrol>`:
///
/// - `<setdcdata>` — settings to transfer **to** the dive computer
/// - `<getdcdata>` — settings to fetch **from** the dive computer
/// - `<divecomputerdump>` — raw memory dumps
///
/// Only `<setdcdata>` is modeled in this release. The other two children
/// are spec-defined but not yet exposed.
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/divecomputercontrol.html
public struct DiveComputerControl: Codable, Equatable, Sendable {
    /// Configuration data transferred to the dive computer
    public var setdcdata: SetDCData?

    public init(setdcdata: SetDCData? = nil) {
        self.setdcdata = setdcdata
    }
}

// MARK: - SetDCData

/// Configuration data sent to a dive computer
///
/// Wraps all `<setdc*>` configuration sub-elements. UDDF 3.2.2 added
/// `<setdcgasdefinitionsdata>` children for transferring gas mix
/// definitions; the rest of the structure dates back to UDDF 3.2.0.
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcdata.html
public struct SetDCData: Codable, Equatable, Sendable {
    /// Absolute clock-time alarm triggers
    public var setdcalarmtime: [SetDCAlarmTime]

    /// Altitude configuration for the next dive (meters, SI)
    public var setdcaltitude: Altitude?

    /// Buddy data transfers (each references a `<buddy>` ID)
    public var setdcbuddydata: [SetDCBuddyData]

    /// Date/time to set on the dive computer
    public var setdcdatetime: SetDCDateTime?

    /// Decompression model selection
    public var setdcdecomodel: SetDCDecoModel?

    /// Depth-threshold alarms
    public var setdcdivedepthalarm: [SetDCDiveDepthAlarm]

    /// PO2-threshold alarms
    public var setdcdivepo2alarm: [SetDCDivePO2Alarm]

    /// Dive-site data transfers (each references a `<site>` ID)
    public var setdcdivesitedata: [SetDCDiveSiteData]

    /// Elapsed-dive-time alarms
    public var setdcdivetimealarm: [SetDCDiveTimeAlarm]

    /// No-decompression-time-exceeded alarm
    public var setdcendndtalarm: SetDCEndNDTAlarm?

    /// Gas-definition transfer to the dive computer
    public var setdcgasdefinitionsdata: SetDCGasDefinitionsData?

    /// Owner data transfer (presence flag, references `<owner>`)
    public var setdcownerdata: SetDCOwnerData?

    /// Password to set on the dive computer
    public var setdcpassword: String?

    /// Generator/manufacturer data transfer (presence flag)
    public var setdcgeneratordata: SetDCGeneratorData?

    public init(
        setdcalarmtime: [SetDCAlarmTime] = [],
        setdcaltitude: Altitude? = nil,
        setdcbuddydata: [SetDCBuddyData] = [],
        setdcdatetime: SetDCDateTime? = nil,
        setdcdecomodel: SetDCDecoModel? = nil,
        setdcdivedepthalarm: [SetDCDiveDepthAlarm] = [],
        setdcdivepo2alarm: [SetDCDivePO2Alarm] = [],
        setdcdivesitedata: [SetDCDiveSiteData] = [],
        setdcdivetimealarm: [SetDCDiveTimeAlarm] = [],
        setdcendndtalarm: SetDCEndNDTAlarm? = nil,
        setdcgasdefinitionsdata: SetDCGasDefinitionsData? = nil,
        setdcownerdata: SetDCOwnerData? = nil,
        setdcpassword: String? = nil,
        setdcgeneratordata: SetDCGeneratorData? = nil
    ) {
        self.setdcalarmtime = setdcalarmtime
        self.setdcaltitude = setdcaltitude
        self.setdcbuddydata = setdcbuddydata
        self.setdcdatetime = setdcdatetime
        self.setdcdecomodel = setdcdecomodel
        self.setdcdivedepthalarm = setdcdivedepthalarm
        self.setdcdivepo2alarm = setdcdivepo2alarm
        self.setdcdivesitedata = setdcdivesitedata
        self.setdcdivetimealarm = setdcdivetimealarm
        self.setdcendndtalarm = setdcendndtalarm
        self.setdcgasdefinitionsdata = setdcgasdefinitionsdata
        self.setdcownerdata = setdcownerdata
        self.setdcpassword = setdcpassword
        self.setdcgeneratordata = setdcgeneratordata
    }

    enum CodingKeys: String, CodingKey {
        case setdcalarmtime
        case setdcaltitude
        case setdcbuddydata
        case setdcdatetime
        case setdcdecomodel
        case setdcdivedepthalarm
        case setdcdivepo2alarm
        case setdcdivesitedata
        case setdcdivetimealarm
        case setdcendndtalarm
        case setdcgasdefinitionsdata
        case setdcownerdata
        case setdcpassword
        case setdcgeneratordata
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        setdcalarmtime = try container.decodeIfPresent([SetDCAlarmTime].self, forKey: .setdcalarmtime) ?? []
        setdcaltitude = try container.decodeIfPresent(Altitude.self, forKey: .setdcaltitude)
        setdcbuddydata = try container.decodeIfPresent([SetDCBuddyData].self, forKey: .setdcbuddydata) ?? []
        setdcdatetime = try container.decodeIfPresent(SetDCDateTime.self, forKey: .setdcdatetime)
        setdcdecomodel = try container.decodeIfPresent(SetDCDecoModel.self, forKey: .setdcdecomodel)
        setdcdivedepthalarm = try container.decodeIfPresent([SetDCDiveDepthAlarm].self, forKey: .setdcdivedepthalarm) ?? []
        setdcdivepo2alarm = try container.decodeIfPresent([SetDCDivePO2Alarm].self, forKey: .setdcdivepo2alarm) ?? []
        setdcdivesitedata = try container.decodeIfPresent([SetDCDiveSiteData].self, forKey: .setdcdivesitedata) ?? []
        setdcdivetimealarm = try container.decodeIfPresent([SetDCDiveTimeAlarm].self, forKey: .setdcdivetimealarm) ?? []
        setdcendndtalarm = try container.decodeIfPresent(SetDCEndNDTAlarm.self, forKey: .setdcendndtalarm)
        setdcgasdefinitionsdata = try container.decodeIfPresent(SetDCGasDefinitionsData.self, forKey: .setdcgasdefinitionsdata)
        setdcownerdata = try container.decodeIfPresent(SetDCOwnerData.self, forKey: .setdcownerdata)
        setdcpassword = try container.decodeIfPresent(String.self, forKey: .setdcpassword)
        setdcgeneratordata = try container.decodeIfPresent(SetDCGeneratorData.self, forKey: .setdcgeneratordata)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for entry in setdcalarmtime {
            let encoder = container.superEncoder(forKey: .setdcalarmtime)
            try entry.encode(to: encoder)
        }
        try container.encodeIfPresent(setdcaltitude, forKey: .setdcaltitude)
        for entry in setdcbuddydata {
            let encoder = container.superEncoder(forKey: .setdcbuddydata)
            try entry.encode(to: encoder)
        }
        try container.encodeIfPresent(setdcdatetime, forKey: .setdcdatetime)
        try container.encodeIfPresent(setdcdecomodel, forKey: .setdcdecomodel)
        for entry in setdcdivedepthalarm {
            let encoder = container.superEncoder(forKey: .setdcdivedepthalarm)
            try entry.encode(to: encoder)
        }
        for entry in setdcdivepo2alarm {
            let encoder = container.superEncoder(forKey: .setdcdivepo2alarm)
            try entry.encode(to: encoder)
        }
        for entry in setdcdivesitedata {
            let encoder = container.superEncoder(forKey: .setdcdivesitedata)
            try entry.encode(to: encoder)
        }
        for entry in setdcdivetimealarm {
            let encoder = container.superEncoder(forKey: .setdcdivetimealarm)
            try entry.encode(to: encoder)
        }
        try container.encodeIfPresent(setdcendndtalarm, forKey: .setdcendndtalarm)
        try container.encodeIfPresent(setdcgasdefinitionsdata, forKey: .setdcgasdefinitionsdata)
        try container.encodeIfPresent(setdcownerdata, forKey: .setdcownerdata)
        try container.encodeIfPresent(setdcpassword, forKey: .setdcpassword)
        try container.encodeIfPresent(setdcgeneratordata, forKey: .setdcgeneratordata)
    }
}

// MARK: - Shared sub-elements

/// Dive computer alarm signal definition
///
/// Defines the alarm pattern triggered for a specific event. Either
/// `<acknowledge/>` (sound until acknowledged) or `<period>` (sound for
/// a fixed duration) should be present, but both are optional.
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/dcalarm.html
public struct DCAlarm: Codable, Equatable, Sendable {
    /// Empty marker indicating the diver must acknowledge the alarm to silence it
    public var acknowledge: Acknowledge?

    /// Alarm pattern identifier (hardware-specific integer)
    public var alarmtype: Int

    /// Alarm duration in seconds (when `acknowledge` is not used)
    public var period: Duration?

    public init(
        acknowledge: Acknowledge? = nil,
        alarmtype: Int,
        period: Duration? = nil
    ) {
        self.acknowledge = acknowledge
        self.alarmtype = alarmtype
        self.period = period
    }
}

/// Empty-marker element inside `<dcalarm>`
public struct Acknowledge: Codable, Equatable, Sendable {
    public init() {}
}

// MARK: - SetDCAlarmTime

/// Absolute (clock-time) alarm trigger
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcalarmtime.html
public struct SetDCAlarmTime: Codable, Equatable, Sendable {
    /// Wall-clock time at which the alarm fires
    public var datetime: Date

    /// Alarm definition
    public var dcalarm: DCAlarm

    public init(datetime: Date, dcalarm: DCAlarm) {
        self.datetime = datetime
        self.dcalarm = dcalarm
    }
}

// MARK: - SetDCBuddyData

/// Buddy data transfer to the dive computer
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcbuddydata.html
public struct SetDCBuddyData: Codable, Equatable, Sendable {
    /// Identifier of the `<buddy>` whose data is transferred
    @Attribute public var buddy: String

    public init(buddy: String) {
        self._buddy = Attribute(buddy)
    }

    enum CodingKeys: String, CodingKey {
        case buddy
    }
}

// MARK: - SetDCDateTime

/// Date/time to set on the dive computer
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcdatetime.html
public struct SetDCDateTime: Codable, Equatable, Sendable {
    /// Date and time to write into the dive computer
    public var datetime: Date

    public init(datetime: Date) {
        self.datetime = datetime
    }
}

// MARK: - SetDCDecoModel

/// Decompression model selection
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcdecomodel.html
public struct SetDCDecoModel: Codable, Equatable, Sendable {
    /// Algorithm name (e.g. "Buhlmann ZH-L16")
    public var name: String

    /// Alternative names recognized by the dive computer
    public var aliasname: [String]

    /// Application-specific data (manufacturer-defined free-form text)
    public var applicationdata: String?

    public init(name: String, aliasname: [String] = [], applicationdata: String? = nil) {
        self.name = name
        self.aliasname = aliasname
        self.applicationdata = applicationdata
    }

    enum CodingKeys: String, CodingKey {
        case name
        case aliasname
        case applicationdata
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        aliasname = try container.decodeIfPresent([String].self, forKey: .aliasname) ?? []
        applicationdata = try container.decodeIfPresent(String.self, forKey: .applicationdata)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        for entry in aliasname {
            let encoder = container.superEncoder(forKey: .aliasname)
            try entry.encode(to: encoder)
        }
        try container.encodeIfPresent(applicationdata, forKey: .applicationdata)
    }
}

// MARK: - SetDCDiveDepthAlarm

/// Depth-threshold alarm
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcdivedepthalarm.html
public struct SetDCDiveDepthAlarm: Codable, Equatable, Sendable {
    /// Depth threshold (meters, SI)
    public var dcalarmdepth: Depth

    /// Alarm definition
    public var dcalarm: DCAlarm

    public init(dcalarmdepth: Depth, dcalarm: DCAlarm) {
        self.dcalarmdepth = dcalarmdepth
        self.dcalarm = dcalarm
    }
}

// MARK: - SetDCDivePO2Alarm

/// PO2-threshold alarm
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcdivepo2alarm.html
public struct SetDCDivePO2Alarm: Codable, Equatable, Sendable {
    /// Alarm definition
    public var dcalarm: DCAlarm

    /// PO2 threshold (pascals, SI)
    public var maximumpo2: Pressure

    public init(dcalarm: DCAlarm, maximumpo2: Pressure) {
        self.dcalarm = dcalarm
        self.maximumpo2 = maximumpo2
    }
}

// MARK: - SetDCDiveSiteData

/// Dive-site data transfer to the dive computer
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcdivesitedata.html
public struct SetDCDiveSiteData: Codable, Equatable, Sendable {
    /// Identifier of the `<site>` whose data is transferred
    @Attribute public var divesite: String

    public init(divesite: String) {
        self._divesite = Attribute(divesite)
    }

    enum CodingKeys: String, CodingKey {
        case divesite
    }
}

// MARK: - SetDCDiveTimeAlarm

/// Elapsed-dive-time alarm
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcdivetimealarm.html
public struct SetDCDiveTimeAlarm: Codable, Equatable, Sendable {
    /// Alarm definition
    public var dcalarm: DCAlarm

    /// Elapsed-time threshold (seconds, SI)
    public var timespan: Duration

    public init(dcalarm: DCAlarm, timespan: Duration) {
        self.dcalarm = dcalarm
        self.timespan = timespan
    }
}

// MARK: - SetDCEndNDTAlarm

/// No-decompression-time exceeded alarm
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcendndtalarm.html
public struct SetDCEndNDTAlarm: Codable, Equatable, Sendable {
    /// Alarm definition
    public var dcalarm: DCAlarm

    public init(dcalarm: DCAlarm) {
        self.dcalarm = dcalarm
    }
}

// MARK: - SetDCGasDefinitionsData (UDDF 3.2.2)

/// Gas-definition transfer to the dive computer (UDDF 3.2.2)
///
/// Either all defined gases (via `<setdcallgasdefinitions/>`) or a
/// selective set (via repeated `<setdcgasdata ref="…"/>`).
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcgasdefinitionsdata.html
public struct SetDCGasDefinitionsData: Codable, Equatable, Sendable {
    /// Empty-marker child: transfer every gas defined in `<gasdefinitions>`
    public var setdcallgasdefinitions: SetDCAllGasDefinitions?

    /// Selective transfer: each entry references a `<mix>` ID
    public var setdcgasdata: [SetDCGasData]

    public init(
        setdcallgasdefinitions: SetDCAllGasDefinitions? = nil,
        setdcgasdata: [SetDCGasData] = []
    ) {
        self.setdcallgasdefinitions = setdcallgasdefinitions
        self.setdcgasdata = setdcgasdata
    }

    enum CodingKeys: String, CodingKey {
        case setdcallgasdefinitions
        case setdcgasdata
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        setdcallgasdefinitions = try container.decodeIfPresent(SetDCAllGasDefinitions.self, forKey: .setdcallgasdefinitions)
        setdcgasdata = try container.decodeIfPresent([SetDCGasData].self, forKey: .setdcgasdata) ?? []
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(setdcallgasdefinitions, forKey: .setdcallgasdefinitions)
        for entry in setdcgasdata {
            let encoder = container.superEncoder(forKey: .setdcgasdata)
            try entry.encode(to: encoder)
        }
    }
}

/// Empty-marker element: transfer all defined gases (UDDF 3.2.2)
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcallgasdefinitions.html
public struct SetDCAllGasDefinitions: Codable, Equatable, Sendable {
    public init() {}
}

/// Selective gas transfer (UDDF 3.2.2)
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcgasdata.html
public struct SetDCGasData: Codable, Equatable, Sendable {
    /// Identifier of the `<mix>` to transfer
    @Attribute public var ref: String

    public init(ref: String) {
        self._ref = Attribute(ref)
    }

    enum CodingKeys: String, CodingKey {
        case ref
    }
}

// MARK: - Empty-marker setdc elements

/// Owner data transfer (empty marker; references `<owner>` in the document)
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcownerdata.html
public struct SetDCOwnerData: Codable, Equatable, Sendable {
    public init() {}
}

/// Generator/manufacturer data transfer (empty marker)
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/setdcgeneratordata.html
public struct SetDCGeneratorData: Codable, Equatable, Sendable {
    public init() {}
}
