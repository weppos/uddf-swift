import Foundation

/// Equipment container for diver gear
///
/// Contains all diving equipment owned by a diver.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/equipment.html
public struct Equipment: Codable, Equatable, Sendable {
    /// Diving boots/footwear
    public var boots: [Boots]?

    /// Buoyancy control devices (BCDs)
    public var buoyancycontroldevice: [BuoyancyControlDevice]?

    /// Photo cameras
    public var camera: [Camera]?

    /// Compasses
    public var compass: [Compass]?

    /// Compressors
    public var compressor: [Compressor]?

    /// Dive computers
    public var divecomputer: [DiveComputer]?

    /// Equipment configurations (preset gear combinations)
    public var equipmentconfiguration: [EquipmentConfiguration]?

    /// Fins
    public var fins: [Fins]?

    /// Gloves
    public var gloves: [Gloves]?

    /// Knives
    public var knife: [Knife]?

    /// Lead/weights
    public var lead: [Lead]?

    /// Underwater lights
    public var light: [Light]?

    /// Masks
    public var mask: [Mask]?

    /// Rebreathers
    public var rebreather: [Rebreather]?

    /// Regulators
    public var regulator: [Regulator]?

    /// Underwater scooters/DPVs
    public var scooter: [Scooter]?

    /// Exposure suits (wetsuits, drysuits)
    public var suit: [Suit]?

    /// Tanks/cylinders
    public var tank: [Tank]?

    /// Miscellaneous equipment
    public var variouspieces: [VariousPieces]?

    /// Video cameras
    public var videocamera: [VideoCamera]?

    /// Dive watches
    public var watch: [Watch]?

    public init(
        boots: [Boots]? = nil,
        buoyancycontroldevice: [BuoyancyControlDevice]? = nil,
        camera: [Camera]? = nil,
        compass: [Compass]? = nil,
        compressor: [Compressor]? = nil,
        divecomputer: [DiveComputer]? = nil,
        equipmentconfiguration: [EquipmentConfiguration]? = nil,
        fins: [Fins]? = nil,
        gloves: [Gloves]? = nil,
        knife: [Knife]? = nil,
        lead: [Lead]? = nil,
        light: [Light]? = nil,
        mask: [Mask]? = nil,
        rebreather: [Rebreather]? = nil,
        regulator: [Regulator]? = nil,
        scooter: [Scooter]? = nil,
        suit: [Suit]? = nil,
        tank: [Tank]? = nil,
        variouspieces: [VariousPieces]? = nil,
        videocamera: [VideoCamera]? = nil,
        watch: [Watch]? = nil
    ) {
        self.boots = boots
        self.buoyancycontroldevice = buoyancycontroldevice
        self.camera = camera
        self.compass = compass
        self.compressor = compressor
        self.divecomputer = divecomputer
        self.equipmentconfiguration = equipmentconfiguration
        self.fins = fins
        self.gloves = gloves
        self.knife = knife
        self.lead = lead
        self.light = light
        self.mask = mask
        self.rebreather = rebreather
        self.regulator = regulator
        self.scooter = scooter
        self.suit = suit
        self.tank = tank
        self.variouspieces = variouspieces
        self.videocamera = videocamera
        self.watch = watch
    }
}
