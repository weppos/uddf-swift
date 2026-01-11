import Foundation
import XMLCoder

/// Equipment used during a specific dive
///
/// Contains cross-references to equipment pieces declared in the equipment section
/// and the amount of lead weight used.
///
/// This element appears inside `<informationbeforedive>`.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/equipmentused.html
public struct EquipmentUsed: Codable, Equatable, Sendable {
    /// Cross-references to equipment pieces (tanks, suits, etc.)
    ///
    /// Each link references an equipment item declared in the `<equipment>` section.
    public var link: [Link]?

    /// Lead weight quantity
    ///
    /// - Unit: kilograms (SI)
    public var leadquantity: Double?

    public init(
        link: [Link]? = nil,
        leadquantity: Double? = nil
    ) {
        self.link = link
        self.leadquantity = leadquantity
    }
}

/// Tank (cylinder) data for breathing gas consumption
///
/// Contains information about gas consumption for a single tank during a dive.
/// This is a direct child of `<dive>`, not inside `<equipmentused>`.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/tankdata.html
public struct TankData: Codable, Equatable, Sendable {
    /// Unique identifier for this tank data
    public var id: String?

    /// Reference to a gas mix from gasdefinitions
    public var link: Link?

    /// Tank volume (water capacity)
    ///
    /// - Unit: cubic meters (SI)
    public var tankvolume: Volume?

    /// Tank pressure at the beginning of the dive
    ///
    /// - Unit: pascals (SI)
    public var tankpressurebegin: Pressure?

    /// Tank pressure at the end of the dive
    ///
    /// - Unit: pascals (SI)
    public var tankpressureend: Pressure?

    /// Breathing gas consumption rate
    ///
    /// - Unit: cubic meters per second (SI)
    public var breathingconsumptionvolume: Double?

    public init(
        id: String? = nil,
        link: Link? = nil,
        tankvolume: Volume? = nil,
        tankpressurebegin: Pressure? = nil,
        tankpressureend: Pressure? = nil,
        breathingconsumptionvolume: Double? = nil
    ) {
        self.id = id
        self.link = link
        self.tankvolume = tankvolume
        self.tankpressurebegin = tankpressurebegin
        self.tankpressureend = tankpressureend
        self.breathingconsumptionvolume = breathingconsumptionvolume
    }

    enum CodingKeys: String, CodingKey {
        case id
        case link
        case tankvolume
        case tankpressurebegin
        case tankpressureend
        case breathingconsumptionvolume
    }
}

// MARK: - DynamicNodeEncoding

extension TankData: DynamicNodeEncoding {
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
