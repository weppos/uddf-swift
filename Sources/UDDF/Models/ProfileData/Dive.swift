import Foundation
import XMLCoder

/// A single dive with profile data
///
/// Contains information before, during, and after the dive, including
/// samples (waypoints) recorded during the dive.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/dive.html
public struct Dive: Codable, Equatable, Sendable {
    /// Unique identifier for this dive
    public var id: String?

    /// Information recorded before the dive started
    public var informationbeforedive: InformationBeforeDive?

    /// Application-specific data
    public var applicationdata: ApplicationData?

    /// Dive profile samples (waypoints)
    public var samples: Samples?

    /// Tank data for breathing gas consumption
    public var tankdata: [TankData]?

    /// Information recorded after the dive ended
    public var informationafterdive: InformationAfterDive?

    public init(
        id: String? = nil,
        informationbeforedive: InformationBeforeDive? = nil,
        applicationdata: ApplicationData? = nil,
        samples: Samples? = nil,
        tankdata: [TankData]? = nil,
        informationafterdive: InformationAfterDive? = nil
    ) {
        self.id = id
        self.informationbeforedive = informationbeforedive
        self.applicationdata = applicationdata
        self.samples = samples
        self.tankdata = tankdata
        self.informationafterdive = informationafterdive
    }

    enum CodingKeys: String, CodingKey {
        case id
        case informationbeforedive
        case applicationdata
        case samples
        case tankdata
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

/// Application-specific data container
///
/// Contains manufacturer or application-specific dive data that doesn't fit
/// in the standard UDDF elements.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/applicationdata.html
public struct ApplicationData: Codable, Equatable, Sendable {
    // Application-specific elements can be added here as needed
    // For now, this is a placeholder for forward compatibility

    public init() {}
}

/// Information recorded before the dive
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/informationbeforedive.html
public struct InformationBeforeDive: Codable, Equatable, Sendable {
    // Elements in UDDF spec order

    /// Cross-references to related elements (diver, dive site, buddy, etc.)
    public var link: [Link]?

    /// Air temperature at surface
    ///
    /// - Unit: Kelvin (SI)
    public var airtemperature: Temperature?

    /// Alcohol consumed before the dive
    public var alcoholbeforedive: AlcoholBeforeDive?

    /// Altitude of the dive site
    ///
    /// - Unit: meters (SI)
    public var altitude: Altitude?

    /// Type of breathing apparatus used
    public var apparatus: Apparatus?

    /// Date and time when the dive started
    public var datetime: Date?

    /// Dive number (sequential number across all dives)
    public var divenumber: Int?

    /// Dive number of the day (1st dive, 2nd dive, etc.)
    public var divenumberofday: Int?

    /// Internal dive number (dive computer's sequence number)
    public var internaldivenumber: Int?

    /// Equipment used during this dive
    ///
    /// - Note: Sections "profiledata" describes parent as "informationbeforedive", "equipmentused" describes parent as "informationafterdive". Using parent "informationbeforedive".
    ///
    /// Reference: https://www.streit.cc/extern/uddf_v321/en/equipmentused.html
    public var equipmentused: EquipmentUsed?

    /// Exercise level before the dive
    ///
    /// - Note: Sections "profiledata" describes parent as "informationbeforedive", "exercisebeforedive" describes parent as "dive". Using parent "informationbeforedive".
    ///
    /// Reference: https://www.streit.cc/extern/uddf_v321/en/exercisebeforedive.html
    public var exercisebeforedive: ExerciseBeforeDive?

    /// Medication taken before the dive
    public var medicationbeforedive: MedicationBeforeDive?

    /// Indicates dive was made without any suit
    public var nosuit: NoSuit?

    /// Planned dive profile for comparison
    public var plannedprofile: PlannedProfile?

    /// Platform from which the dive commenced
    public var platform: Platform?

    /// Price of the dive
    public var price: Price?

    /// Purpose of the dive
    ///
    /// - Note: Sections "profiledata" describes parent as "informationafterdive", "purpose" describes parent as "informationbeforedive". Using parent "informationbeforedive".
    ///
    /// Reference: https://www.streit.cc/extern/uddf_v321/en/purpose.html
    public var purpose: Purpose?

    /// Type of diving program
    ///
    /// - Note: Sections "profiledata" describes parent as "informationbeforedive", "program" describes parent as "informationafterdive". Using parent "informationbeforedive".
    ///
    /// Reference: https://www.streit.cc/extern/uddf_v321/en/program.html
    public var program: Program?

    /// Diver's state of rest before the dive
    public var stateofrestbeforedive: StateOfRestBeforeDive?

    /// Surface interval before this dive
    public var surfaceintervalbeforedive: SurfaceIntervalBeforeDive?

    /// Surface pressure at dive site
    ///
    /// - Unit: pascals (SI)
    public var surfacepressure: Pressure?

    /// Trip membership identifier
    public var tripmembership: String?

    // Extensions (non-standard)

    /// Water salinity (fresh/salt) for the dive site.
    ///
    /// - Note: EXTENSION libdivecomputer export
    public var salinity: Salinity?

    public init(
        link: [Link]? = nil,
        airtemperature: Temperature? = nil,
        alcoholbeforedive: AlcoholBeforeDive? = nil,
        altitude: Altitude? = nil,
        apparatus: Apparatus? = nil,
        datetime: Date? = nil,
        divenumber: Int? = nil,
        divenumberofday: Int? = nil,
        internaldivenumber: Int? = nil,
        equipmentused: EquipmentUsed? = nil,
        exercisebeforedive: ExerciseBeforeDive? = nil,
        medicationbeforedive: MedicationBeforeDive? = nil,
        nosuit: NoSuit? = nil,
        plannedprofile: PlannedProfile? = nil,
        platform: Platform? = nil,
        price: Price? = nil,
        purpose: Purpose? = nil,
        program: Program? = nil,
        stateofrestbeforedive: StateOfRestBeforeDive? = nil,
        surfaceintervalbeforedive: SurfaceIntervalBeforeDive? = nil,
        surfacepressure: Pressure? = nil,
        tripmembership: String? = nil,
        salinity: Salinity? = nil
    ) {
        self.link = link
        self.airtemperature = airtemperature
        self.alcoholbeforedive = alcoholbeforedive
        self.altitude = altitude
        self.apparatus = apparatus
        self.datetime = datetime
        self.divenumber = divenumber
        self.divenumberofday = divenumberofday
        self.internaldivenumber = internaldivenumber
        self.equipmentused = equipmentused
        self.exercisebeforedive = exercisebeforedive
        self.medicationbeforedive = medicationbeforedive
        self.nosuit = nosuit
        self.plannedprofile = plannedprofile
        self.platform = platform
        self.price = price
        self.purpose = purpose
        self.program = program
        self.stateofrestbeforedive = stateofrestbeforedive
        self.surfaceintervalbeforedive = surfaceintervalbeforedive
        self.surfacepressure = surfacepressure
        self.tripmembership = tripmembership
        self.salinity = salinity
    }
}

/// Information recorded after the dive
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/informationafterdive.html
public struct InformationAfterDive: Codable, Equatable, Sendable {
    // Elements in UDDF spec order

    /// Any symptoms experienced during or after the dive (free text)
    public var anysymptoms: String?

    /// Average depth during the dive
    ///
    /// - Unit: meters (SI)
    public var averagedepth: Depth?

    /// Water current strength during the dive
    public var current: Current?

    /// Time required for full desaturation after the dive
    ///
    /// - Unit: seconds (SI)
    public var desaturationtime: Duration?

    /// Total dive time
    ///
    /// - Unit: seconds (SI)
    public var diveduration: Duration?

    /// Method used to plan the dive
    public var diveplan: DivePlan?

    /// Decompression table used to plan the dive
    public var divetable: DiveTable?

    /// Equipment malfunction that occurred during the dive
    public var equipmentmalfunction: EquipmentMalfunction?

    /// Global alarms triggered during the dive
    public var globalalarmsgiven: GlobalAlarmsGiven?

    /// Greatest depth reached during the dive
    ///
    /// - Unit: meters (SI)
    public var greatestdepth: Depth?

    /// Highest partial pressure of oxygen during the dive
    ///
    /// - Unit: pascals (SI)
    public var highestpo2: Pressure?

    /// Hyperbaric recompression treatment after the dive
    ///
    /// - Note: Sections "profiledata" describes parent as "informationafterdive", "hyperbaricfacilitytreatment" describes parent as "dive". Using parent "informationafterdive".
    ///
    /// Reference: https://www.streit.cc/extern/uddf_v321/en/exercisebeforedive.html
    public var hyperbaricfacilitytreatment: HyperbaricFacilityTreatment?

    /// Lowest temperature during the dive
    ///
    /// - Unit: Kelvin (SI)
    public var lowesttemperature: Temperature?

    /// No-fly time after the dive
    ///
    /// - Unit: seconds (SI)
    public var noflighttime: Duration?

    /// Notes or comments after the dive
    public var notes: Notes?

    /// Observations during the dive (marine life, etc.)
    public var observations: String?

    /// Pressure drop in tank(s) during the dive
    ///
    /// - Unit: pascals (SI)
    public var pressuredrop: Pressure?

    /// Problems encountered during the dive (free text)
    public var problems: String?

    /// See InformationBeforeDive
    /// public var program: Program?

    /// Diver's rating of the dive
    public var rating: Rating?

    /// Surface interval after this dive
    ///
    /// - Unit: seconds (SI)
    public var surfaceintervalafterdive: Duration?

    /// Thermal comfort during the dive
    public var thermalcomfort: ThermalComfort?

    /// Underwater visibility
    ///
    /// - Unit: meters (SI)
    public var visibility: Depth?

    /// Physical workload during the dive
    public var workload: Workload?

    public init(
        anysymptoms: String? = nil,
        averagedepth: Depth? = nil,
        current: Current? = nil,
        desaturationtime: Duration? = nil,
        diveduration: Duration? = nil,
        diveplan: DivePlan? = nil,
        divetable: DiveTable? = nil,
        equipmentmalfunction: EquipmentMalfunction? = nil,
        globalalarmsgiven: GlobalAlarmsGiven? = nil,
        greatestdepth: Depth? = nil,
        highestpo2: Pressure? = nil,
        hyperbaricfacilitytreatment: HyperbaricFacilityTreatment? = nil,
        lowesttemperature: Temperature? = nil,
        noflighttime: Duration? = nil,
        notes: Notes? = nil,
        observations: String? = nil,
        pressuredrop: Pressure? = nil,
        problems: String? = nil,
        rating: Rating? = nil,
        surfaceintervalafterdive: Duration? = nil,
        thermalcomfort: ThermalComfort? = nil,
        visibility: Depth? = nil,
        workload: Workload? = nil
    ) {
        self.anysymptoms = anysymptoms
        self.averagedepth = averagedepth
        self.current = current
        self.desaturationtime = desaturationtime
        self.diveduration = diveduration
        self.diveplan = diveplan
        self.divetable = divetable
        self.equipmentmalfunction = equipmentmalfunction
        self.globalalarmsgiven = globalalarmsgiven
        self.greatestdepth = greatestdepth
        self.highestpo2 = highestpo2
        self.hyperbaricfacilitytreatment = hyperbaricfacilitytreatment
        self.lowesttemperature = lowesttemperature
        self.noflighttime = noflighttime
        self.notes = notes
        self.observations = observations
        self.pressuredrop = pressuredrop
        self.problems = problems
        self.rating = rating
        self.surfaceintervalafterdive = surfaceintervalafterdive
        self.thermalcomfort = thermalcomfort
        self.visibility = visibility
        self.workload = workload
    }
}
