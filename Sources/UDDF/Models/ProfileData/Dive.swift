import Foundation
import XMLCoder

/// A single dive with profile data
///
/// Contains information before, during, and after the dive, including
/// samples (waypoints) recorded during the dive.
public struct Dive: Codable, Equatable, Sendable {
    /// Unique identifier for this dive
    public var id: String?

    /// Information recorded before the dive started
    public var informationbeforedive: InformationBeforeDive?

    /// Equipment used during this dive (tanks, weights, etc.)
    public var equipmentused: EquipmentUsed?

    /// Dive profile samples (waypoints)
    public var samples: Samples?

    /// Information recorded after the dive ended
    public var informationafterdive: InformationAfterDive?

    public init(
        id: String? = nil,
        informationbeforedive: InformationBeforeDive? = nil,
        equipmentused: EquipmentUsed? = nil,
        samples: Samples? = nil,
        informationafterdive: InformationAfterDive? = nil
    ) {
        self.id = id
        self.informationbeforedive = informationbeforedive
        self.equipmentused = equipmentused
        self.samples = samples
        self.informationafterdive = informationafterdive
    }

    enum CodingKeys: String, CodingKey {
        case id
        case informationbeforedive
        case equipmentused
        case samples
        case informationafterdive
    }
}

// MARK: - DynamicNodeEncoding

extension Dive: DynamicNodeEncoding {
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

/// Information recorded before the dive
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/informationbeforedive.html
public struct InformationBeforeDive: Codable, Equatable, Sendable {
    /// Cross-references to related elements (diver, dive site, buddy, etc.)
    public var link: [Link]?

    /// Date and time when the dive started
    public var datetime: Date?

    /// Dive number (sequential number across all dives)
    public var divenumber: Int?

    /// Internal dive number (dive computer's sequence number)
    public var internaldivenumber: Int?

    /// Dive number of the day (1st dive, 2nd dive, etc.)
    public var divenumberofday: Int?

    /// Air temperature at surface
    ///
    /// - Unit: Kelvin (SI)
    public var airtemperature: Temperature?

    /// Surface interval before this dive
    public var surfaceintervalbeforedive: SurfaceIntervalBeforeDive?

    /// Altitude of the dive site
    ///
    /// - Unit: meters (SI)
    public var altitude: Altitude?

    /// Surface pressure at dive site
    ///
    /// - Unit: pascals (SI)
    public var surfacepressure: Pressure?

    /// Platform from which the dive commenced
    public var platform: Platform?

    /// Type of breathing apparatus used
    public var apparatus: Apparatus?

    /// Purpose of the dive
    public var purpose: Purpose?

    /// Diver's state of rest before the dive
    public var stateofrestbeforedive: StateOfRestBeforeDive?

    /// Water salinity (fresh/salt) for the dive site.
    ///
    /// - Note: EXTENSION libdivecomputer export
    public var salinity: Salinity?

    /// Trip membership identifier
    public var tripmembership: String?

    /// Notes or comments before the dive
    public var notes: Notes?

    public init(
        link: [Link]? = nil,
        datetime: Date? = nil,
        divenumber: Int? = nil,
        internaldivenumber: Int? = nil,
        divenumberofday: Int? = nil,
        airtemperature: Temperature? = nil,
        surfaceintervalbeforedive: SurfaceIntervalBeforeDive? = nil,
        altitude: Altitude? = nil,
        surfacepressure: Pressure? = nil,
        platform: Platform? = nil,
        apparatus: Apparatus? = nil,
        purpose: Purpose? = nil,
        stateofrestbeforedive: StateOfRestBeforeDive? = nil,
        salinity: Salinity? = nil,
        tripmembership: String? = nil,
        notes: Notes? = nil
    ) {
        self.link = link
        self.datetime = datetime
        self.divenumber = divenumber
        self.internaldivenumber = internaldivenumber
        self.divenumberofday = divenumberofday
        self.airtemperature = airtemperature
        self.surfaceintervalbeforedive = surfaceintervalbeforedive
        self.altitude = altitude
        self.surfacepressure = surfacepressure
        self.platform = platform
        self.apparatus = apparatus
        self.purpose = purpose
        self.stateofrestbeforedive = stateofrestbeforedive
        self.salinity = salinity
        self.tripmembership = tripmembership
        self.notes = notes
    }
}

/// Information recorded after the dive
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/informationafterdive.html
public struct InformationAfterDive: Codable, Equatable, Sendable {
    /// Lowest temperature during the dive
    ///
    /// - Unit: Kelvin (SI)
    public var lowesttemperature: Temperature?

    /// Greatest depth reached during the dive
    ///
    /// - Unit: meters (SI)
    public var greatestdepth: Depth?

    /// Average depth during the dive
    ///
    /// - Unit: meters (SI)
    public var averagedepth: Depth?

    /// Total dive time
    ///
    /// - Unit: seconds (SI)
    public var diveduration: Duration?

    /// Underwater visibility
    ///
    /// - Unit: meters (SI)
    public var visibility: Depth?

    /// Water current strength during the dive
    public var current: Current?

    /// Method used to plan the dive
    public var diveplan: DivePlan?

    /// Equipment malfunction that occurred during the dive
    public var equipmentmalfunction: EquipmentMalfunction?

    /// Pressure drop in tank(s) during the dive
    ///
    /// - Unit: pascals (SI)
    public var pressuredrop: Pressure?

    /// Problems encountered during the dive (free text)
    public var problems: String?

    /// Type of diving program
    public var program: Program?

    /// Thermal comfort during the dive
    public var thermalcomfort: ThermalComfort?

    /// Physical workload during the dive
    public var workload: Workload?

    /// Time required for full desaturation after the dive
    ///
    /// - Unit: seconds (SI)
    public var desaturationtime: Duration?

    /// No-fly time after the dive
    ///
    /// - Unit: seconds (SI)
    public var noflighttime: Duration?

    /// Surface interval after this dive
    ///
    /// - Unit: seconds (SI)
    public var surfaceintervalafterdive: Duration?

    /// Highest partial pressure of oxygen during the dive
    ///
    /// - Unit: pascals (SI)
    public var highestpo2: Pressure?

    /// Any symptoms experienced during or after the dive (free text)
    public var anysymptoms: String?

    /// Global alarms triggered during the dive (free text)
    public var globalalarmsgiven: String?

    /// Observations during the dive (marine life, etc.)
    public var observations: String?

    /// Diver's rating of the dive
    public var rating: Rating?

    /// Notes or comments after the dive
    public var notes: Notes?

    public init(
        lowesttemperature: Temperature? = nil,
        greatestdepth: Depth? = nil,
        averagedepth: Depth? = nil,
        diveduration: Duration? = nil,
        visibility: Depth? = nil,
        current: Current? = nil,
        diveplan: DivePlan? = nil,
        equipmentmalfunction: EquipmentMalfunction? = nil,
        pressuredrop: Pressure? = nil,
        problems: String? = nil,
        program: Program? = nil,
        thermalcomfort: ThermalComfort? = nil,
        workload: Workload? = nil,
        desaturationtime: Duration? = nil,
        noflighttime: Duration? = nil,
        surfaceintervalafterdive: Duration? = nil,
        highestpo2: Pressure? = nil,
        anysymptoms: String? = nil,
        globalalarmsgiven: String? = nil,
        observations: String? = nil,
        rating: Rating? = nil,
        notes: Notes? = nil
    ) {
        self.lowesttemperature = lowesttemperature
        self.greatestdepth = greatestdepth
        self.averagedepth = averagedepth
        self.diveduration = diveduration
        self.visibility = visibility
        self.current = current
        self.diveplan = diveplan
        self.equipmentmalfunction = equipmentmalfunction
        self.pressuredrop = pressuredrop
        self.problems = problems
        self.program = program
        self.thermalcomfort = thermalcomfort
        self.workload = workload
        self.desaturationtime = desaturationtime
        self.noflighttime = noflighttime
        self.surfaceintervalafterdive = surfaceintervalafterdive
        self.highestpo2 = highestpo2
        self.anysymptoms = anysymptoms
        self.globalalarmsgiven = globalalarmsgiven
        self.observations = observations
        self.rating = rating
        self.notes = notes
    }
}

