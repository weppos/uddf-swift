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
/// a reference to the gas mix and pressure readings.
///
/// - SeeAlso: https://www.streit.cc/extern/uddf_v321/en/tankdata.html
public struct TankData: Codable, Equatable, Sendable {
    /// Reference to a gas mix from gasdefinitions
    public var link: Link?

    /// Tank volume
    ///
    /// - Unit: m³ (cubic meters)
    public var tankvolume: Volume?

    /// Tank pressure at the beginning of the dive
    ///
    /// - Unit: Pa (pascals)
    public var tankpressurebegin: Pressure?

    /// Tank pressure at the end of the dive
    ///
    /// - Unit: Pa (pascals)
    public var tankpressureend: Pressure?

    public init(
        link: Link? = nil,
        tankvolume: Volume? = nil,
        tankpressurebegin: Pressure? = nil,
        tankpressureend: Pressure? = nil
    ) {
        self.link = link
        self.tankvolume = tankvolume
        self.tankpressurebegin = tankpressurebegin
        self.tankpressureend = tankpressureend
    }
}
