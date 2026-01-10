import Foundation
import XMLCoder

/// Equipment used during a specific dive
///
/// Contains information about the equipment used during a dive, including
/// tanks with gas mix references and lead weight quantity.
///
/// - SeeAlso: https://www.streit.cc/extern/uddf_v321/en/equipmentused.html
public struct EquipmentUsed: Codable, Equatable, Sendable {
    /// Lead weight quantity
    ///
    /// - Unit: kg (kilograms)
    public var leadquantity: Double?

    /// Tank data for each cylinder used during the dive
    public var tankdata: [TankData]?

    public init(
        leadquantity: Double? = nil,
        tankdata: [TankData]? = nil
    ) {
        self.leadquantity = leadquantity
        self.tankdata = tankdata
    }
}

/// Tank (cylinder) data for a dive
///
/// Contains information about a single tank used during a dive, including
/// a reference to the gas mix, pressure readings, and consumption data.
///
/// - SeeAlso: https://www.streit.cc/extern/uddf_v321/en/tankdata.html
public struct TankData: Codable, Equatable, Sendable {
    /// Unique identifier for this tank data
    public var id: String?

    /// Breathing gas consumption rate
    ///
    /// - Unit: m³/s (cubic meters per second)
    public var breathingconsumptionvolume: Double?

    /// Reference to a gas mix from gasdefinitions
    public var link: Link?

    /// Tank pressure at the beginning of the dive
    ///
    /// - Unit: Pa (pascals)
    public var tankpressurebegin: Pressure?

    /// Tank pressure at the end of the dive
    ///
    /// - Unit: Pa (pascals)
    public var tankpressureend: Pressure?

    /// Tank volume (water capacity)
    ///
    /// - Unit: m³ (cubic meters)
    public var tankvolume: Volume?

    public init(
        id: String? = nil,
        breathingconsumptionvolume: Double? = nil,
        link: Link? = nil,
        tankpressurebegin: Pressure? = nil,
        tankpressureend: Pressure? = nil,
        tankvolume: Volume? = nil
    ) {
        self.id = id
        self.breathingconsumptionvolume = breathingconsumptionvolume
        self.link = link
        self.tankpressurebegin = tankpressurebegin
        self.tankpressureend = tankpressureend
        self.tankvolume = tankvolume
    }

    enum CodingKeys: String, CodingKey {
        case id
        case breathingconsumptionvolume
        case link
        case tankpressurebegin
        case tankpressureend
        case tankvolume
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
