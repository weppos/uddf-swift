import Foundation

// MARK: - Platform

/// Dive platform type
///
/// Describes the location/facility from which a dive commenced.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/platform.html
public enum Platform: Equatable, Sendable {
    /// Beach or shore entry
    case beachShore
    /// Pier or dock entry
    case pier
    /// Small boat
    case smallBoat
    /// Charter boat
    case charterBoat
    /// Live-aboard vessel
    case liveAboard
    /// Barge
    case barge
    /// Landside (pool, quarry, etc.)
    case landside
    /// Hyperbaric facility
    case hyperbaricFacility
    /// Other platform type
    case other
    /// Non-standard or unknown platform
    case unknown(String)

    /// The raw string value for this platform type
    public var rawValue: String {
        switch self {
        case .beachShore: return "beach-shore"
        case .pier: return "pier"
        case .smallBoat: return "small-boat"
        case .charterBoat: return "charter-boat"
        case .liveAboard: return "live-aboard"
        case .barge: return "barge"
        case .landside: return "landside"
        case .hyperbaricFacility: return "hyperbaric-facility"
        case .other: return "other"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    public init(rawValue: String) {
        switch rawValue {
        case "beach-shore": self = .beachShore
        case "pier": self = .pier
        case "small-boat": self = .smallBoat
        case "charter-boat": self = .charterBoat
        case "live-aboard": self = .liveAboard
        case "barge": self = .barge
        case "landside": self = .landside
        case "hyperbaric-facility": self = .hyperbaricFacility
        case "other": self = .other
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard UDDF platform type
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

extension Platform: Codable {
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

// MARK: - Apparatus

/// Breathing gas delivery system
///
/// Describes the type of breathing apparatus used during the dive.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/apparatus.html
public enum Apparatus: Equatable, Sendable {
    /// Open-circuit scuba
    case openScuba
    /// Rebreather (closed or semi-closed circuit)
    case rebreather
    /// Surface-supplied diving
    case surfaceSupplied
    /// Hyperbaric chamber
    case chamber
    /// Experimental apparatus
    case experimental
    /// Other apparatus type
    case other
    /// Non-standard or unknown apparatus
    case unknown(String)

    /// The raw string value for this apparatus type
    public var rawValue: String {
        switch self {
        case .openScuba: return "open-scuba"
        case .rebreather: return "rebreather"
        case .surfaceSupplied: return "surface-supplied"
        case .chamber: return "chamber"
        case .experimental: return "experimental"
        case .other: return "other"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    public init(rawValue: String) {
        switch rawValue {
        case "open-scuba": self = .openScuba
        case "rebreather": self = .rebreather
        case "surface-supplied": self = .surfaceSupplied
        case "chamber": self = .chamber
        case "experimental": self = .experimental
        case "other": self = .other
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard UDDF apparatus type
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

extension Apparatus: Codable {
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

// MARK: - Purpose

/// Dive purpose
///
/// Describes the purpose or reason for the dive.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/purpose.html
public enum Purpose: Equatable, Sendable {
    /// Sightseeing/recreational diving
    case sightseeing
    /// Learning (student diving with instructor)
    case learning
    /// Teaching (instructor teaching students)
    case teaching
    /// Research diving
    case research
    /// Photography or videography
    case photographyVideography
    /// Spearfishing
    case spearfishing
    /// Proficiency/practice dive
    case proficiency
    /// Work/commercial diving
    case work
    /// Other purpose
    case other
    /// Non-standard or unknown purpose
    case unknown(String)

    /// The raw string value for this purpose
    public var rawValue: String {
        switch self {
        case .sightseeing: return "sightseeing"
        case .learning: return "learning"
        case .teaching: return "teaching"
        case .research: return "research"
        case .photographyVideography: return "photography-videography"
        case .spearfishing: return "spearfishing"
        case .proficiency: return "proficiency"
        case .work: return "work"
        case .other: return "other"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    public init(rawValue: String) {
        switch rawValue {
        case "sightseeing": self = .sightseeing
        case "learning": self = .learning
        case "teaching": self = .teaching
        case "research": self = .research
        case "photography-videography": self = .photographyVideography
        case "spearfishing": self = .spearfishing
        case "proficiency": self = .proficiency
        case "work": self = .work
        case "other": self = .other
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard UDDF purpose
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

extension Purpose: Codable {
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

// MARK: - StateOfRestBeforeDive

/// Diver's state of rest before the dive
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/stateofrestbeforedive.html
public enum StateOfRestBeforeDive: Equatable, Sendable {
    /// Not specified
    case notSpecified
    /// Well rested
    case rested
    /// Tired
    case tired
    /// Exhausted
    case exhausted
    /// Non-standard or unknown state
    case unknown(String)

    /// The raw string value for this state
    public var rawValue: String {
        switch self {
        case .notSpecified: return "not-specified"
        case .rested: return "rested"
        case .tired: return "tired"
        case .exhausted: return "exhausted"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    public init(rawValue: String) {
        switch rawValue {
        case "not-specified": self = .notSpecified
        case "rested": self = .rested
        case "tired": self = .tired
        case "exhausted": self = .exhausted
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard UDDF state
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

extension StateOfRestBeforeDive: Codable {
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

// MARK: - Current

/// Water current strength during the dive
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/current.html
public enum Current: Equatable, Sendable {
    /// No current
    case noCurrent
    /// Very mild current
    case veryMildCurrent
    /// Mild current
    case mildCurrent
    /// Moderate current
    case moderateCurrent
    /// Hard current
    case hardCurrent
    /// Very hard current (cannot swim against)
    case veryHardCurrent
    /// Non-standard or unknown current
    case unknown(String)

    /// The raw string value for this current strength
    public var rawValue: String {
        switch self {
        case .noCurrent: return "no-current"
        case .veryMildCurrent: return "very-mild-current"
        case .mildCurrent: return "mild-current"
        case .moderateCurrent: return "moderate-current"
        case .hardCurrent: return "hard-current"
        case .veryHardCurrent: return "very-hard-current"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    public init(rawValue: String) {
        switch rawValue {
        case "no-current": self = .noCurrent
        case "very-mild-current": self = .veryMildCurrent
        case "mild-current": self = .mildCurrent
        case "moderate-current": self = .moderateCurrent
        case "hard-current": self = .hardCurrent
        case "very-hard-current": self = .veryHardCurrent
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard UDDF current strength
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

extension Current: Codable {
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

// MARK: - DivePlan

/// Method used to plan the dive
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/diveplan.html
public enum DivePlan: Equatable, Sendable {
    /// No dive plan
    case none
    /// Dive tables used
    case table
    /// Dive computer used
    case diveComputer
    /// Followed another diver
    case anotherDiver
    /// Non-standard or unknown plan method
    case unknown(String)

    /// The raw string value for this dive plan method
    public var rawValue: String {
        switch self {
        case .none: return "none"
        case .table: return "table"
        case .diveComputer: return "dive-computer"
        case .anotherDiver: return "another-diver"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    public init(rawValue: String) {
        switch rawValue {
        case "none": self = .none
        case "table": self = .table
        case "dive-computer": self = .diveComputer
        case "another-diver": self = .anotherDiver
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard UDDF dive plan method
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

extension DivePlan: Codable {
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

// MARK: - ThermalComfort

/// Diver's thermal comfort during the dive
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/thermalcomfort.html
public enum ThermalComfort: Equatable, Sendable {
    /// Not indicated
    case notIndicated
    /// Comfortable temperature
    case comfortable
    /// Cold
    case cold
    /// Very cold
    case veryCold
    /// Hot
    case hot
    /// Non-standard or unknown thermal comfort
    case unknown(String)

    /// The raw string value for this thermal comfort
    public var rawValue: String {
        switch self {
        case .notIndicated: return "not-indicated"
        case .comfortable: return "comfortable"
        case .cold: return "cold"
        case .veryCold: return "very-cold"
        case .hot: return "hot"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    public init(rawValue: String) {
        switch rawValue {
        case "not-indicated": self = .notIndicated
        case "comfortable": self = .comfortable
        case "cold": self = .cold
        case "very-cold": self = .veryCold
        case "hot": self = .hot
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard UDDF thermal comfort
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

extension ThermalComfort: Codable {
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

// MARK: - Workload

/// Physical workload during the dive
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/workload.html
public enum Workload: Equatable, Sendable {
    /// Not specified
    case notSpecified
    /// Resting (minimal activity)
    case resting
    /// Light workload
    case light
    /// Moderate workload
    case moderate
    /// Severe workload
    case severe
    /// Exhausting workload
    case exhausting
    /// Non-standard or unknown workload
    case unknown(String)

    /// The raw string value for this workload
    public var rawValue: String {
        switch self {
        case .notSpecified: return "not-specified"
        case .resting: return "resting"
        case .light: return "light"
        case .moderate: return "moderate"
        case .severe: return "severe"
        case .exhausting: return "exhausting"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    public init(rawValue: String) {
        switch rawValue {
        case "not-specified": self = .notSpecified
        case "resting": self = .resting
        case "light": self = .light
        case "moderate": self = .moderate
        case "severe": self = .severe
        case "exhausting": self = .exhausting
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard UDDF workload
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

extension Workload: Codable {
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

// MARK: - EquipmentMalfunction

/// Type of equipment malfunction during the dive
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/equipmentmalfunction.html
public enum EquipmentMalfunction: Equatable, Sendable {
    /// No malfunction
    case none
    /// Face mask malfunction
    case faceMask
    /// Fins malfunction
    case fins
    /// Weight belt malfunction
    case weightBelt
    /// BCD malfunction
    case buoyancyControlDevice
    /// Thermal protection (suit) malfunction
    case thermalProtection
    /// Dive computer malfunction
    case diveComputer
    /// Depth gauge malfunction
    case depthGauge
    /// Pressure gauge malfunction
    case pressureGauge
    /// Breathing apparatus malfunction
    case breathingApparatus
    /// Deco reel malfunction
    case decoReel
    /// Other malfunction
    case other
    /// Non-standard or unknown malfunction
    case unknown(String)

    /// The raw string value for this malfunction type
    public var rawValue: String {
        switch self {
        case .none: return "none"
        case .faceMask: return "face-mask"
        case .fins: return "fins"
        case .weightBelt: return "weight-belt"
        case .buoyancyControlDevice: return "buoyancy-control-device"
        case .thermalProtection: return "thermal-protection"
        case .diveComputer: return "dive-computer"
        case .depthGauge: return "depth-gauge"
        case .pressureGauge: return "pressure-gauge"
        case .breathingApparatus: return "breathing-apparatus"
        case .decoReel: return "deco-reel"
        case .other: return "other"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    public init(rawValue: String) {
        switch rawValue {
        case "none": self = .none
        case "face-mask": self = .faceMask
        case "fins": self = .fins
        case "weight-belt": self = .weightBelt
        case "buoyancy-control-device": self = .buoyancyControlDevice
        case "thermal-protection": self = .thermalProtection
        case "dive-computer": self = .diveComputer
        case "depth-gauge": self = .depthGauge
        case "pressure-gauge": self = .pressureGauge
        case "breathing-apparatus": self = .breathingApparatus
        case "deco-reel": self = .decoReel
        case "other": self = .other
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard UDDF malfunction type
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

extension EquipmentMalfunction: Codable {
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

// MARK: - Program

/// Type of diving program
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/program.html
public enum Program: Equatable, Sendable {
    /// Recreational diving
    case recreation
    /// Training/certification dive
    case training
    /// Scientific diving
    case scientific
    /// Medical diving
    case medical
    /// Commercial diving
    case commercial
    /// Military diving
    case military
    /// Competitive diving
    case competitive
    /// Other program type
    case other
    /// Non-standard or unknown program
    case unknown(String)

    /// The raw string value for this program type
    public var rawValue: String {
        switch self {
        case .recreation: return "recreation"
        case .training: return "training"
        case .scientific: return "scientific"
        case .medical: return "medical"
        case .commercial: return "commercial"
        case .military: return "military"
        case .competitive: return "competitive"
        case .other: return "other"
        case .unknown(let value): return value
        }
    }

    /// Initialize from a raw string value
    public init(rawValue: String) {
        switch rawValue {
        case "recreation": self = .recreation
        case "training": self = .training
        case "scientific": self = .scientific
        case "medical": self = .medical
        case "commercial": self = .commercial
        case "military": self = .military
        case "competitive": self = .competitive
        case "other": self = .other
        default: self = .unknown(rawValue)
        }
    }

    /// Returns true if this is a standard UDDF program type
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

extension Program: Codable {
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
