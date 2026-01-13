import XCTest
@testable import UDDF

final class ProfileDataTests: XCTestCase {

    // MARK: - DiveMode Enum Tests

    func testDiveModeStringConversion() {
        // Test standard values
        let mode1 = DiveMode.ModeType(rawValue: "closedcircuit")
        XCTAssertEqual(mode1, .closedCircuit)
        XCTAssertEqual(mode1.isStandard, true)

        let mode2 = DiveMode.ModeType(rawValue: "opencircuit")
        XCTAssertEqual(mode2, .openCircuit)

        let mode3 = DiveMode.ModeType(rawValue: "apnoe")
        XCTAssertEqual(mode3, .apnoe)

        let mode4 = DiveMode.ModeType(rawValue: "semiclosedcircuit")
        XCTAssertEqual(mode4, .semiClosedCircuit)

        // Test unknown values
        let unknown = DiveMode.ModeType(rawValue: "gauge")
        XCTAssertEqual(unknown.rawValue, "gauge")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - DecoStop Enum Tests

    func testDecoStopKindValues() {
        let kind1 = DecoStop.StopKind(rawValue: "mandatory")
        XCTAssertEqual(kind1, .mandatory)
        XCTAssertEqual(kind1.isStandard, true)

        let kind2 = DecoStop.StopKind(rawValue: "safety")
        XCTAssertEqual(kind2, .safety)
        XCTAssertEqual(kind2.isStandard, true)

        let unknown = DecoStop.StopKind(rawValue: "deep")
        XCTAssertEqual(unknown.rawValue, "deep")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - Platform Enum Tests

    func testPlatformEnumValues() {
        XCTAssertEqual(Platform(rawValue: "beach-shore"), .beachShore)
        XCTAssertEqual(Platform(rawValue: "pier"), .pier)
        XCTAssertEqual(Platform(rawValue: "small-boat"), .smallBoat)
        XCTAssertEqual(Platform(rawValue: "charter-boat"), .charterBoat)
        XCTAssertEqual(Platform(rawValue: "live-aboard"), .liveAboard)
        XCTAssertEqual(Platform(rawValue: "barge"), .barge)
        XCTAssertEqual(Platform(rawValue: "landside"), .landside)
        XCTAssertEqual(Platform(rawValue: "hyperbaric-facility"), .hyperbaricFacility)
        XCTAssertEqual(Platform(rawValue: "other"), .other)

        let unknown = Platform(rawValue: "submarine")
        XCTAssertEqual(unknown.rawValue, "submarine")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - Apparatus Enum Tests

    func testApparatusEnumValues() {
        XCTAssertEqual(Apparatus(rawValue: "open-scuba"), .openScuba)
        XCTAssertEqual(Apparatus(rawValue: "rebreather"), .rebreather)
        XCTAssertEqual(Apparatus(rawValue: "surface-supplied"), .surfaceSupplied)
        XCTAssertEqual(Apparatus(rawValue: "chamber"), .chamber)
        XCTAssertEqual(Apparatus(rawValue: "experimental"), .experimental)
        XCTAssertEqual(Apparatus(rawValue: "other"), .other)

        let unknown = Apparatus(rawValue: "freediving")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - Purpose Enum Tests

    func testPurposeEnumValues() {
        XCTAssertEqual(Purpose(rawValue: "sightseeing"), .sightseeing)
        XCTAssertEqual(Purpose(rawValue: "learning"), .learning)
        XCTAssertEqual(Purpose(rawValue: "teaching"), .teaching)
        XCTAssertEqual(Purpose(rawValue: "research"), .research)
        XCTAssertEqual(Purpose(rawValue: "photography-videography"), .photographyVideography)
        XCTAssertEqual(Purpose(rawValue: "spearfishing"), .spearfishing)
        XCTAssertEqual(Purpose(rawValue: "proficiency"), .proficiency)
        XCTAssertEqual(Purpose(rawValue: "work"), .work)
        XCTAssertEqual(Purpose(rawValue: "other"), .other)

        let unknown = Purpose(rawValue: "treasure-hunting")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - Current Enum Tests

    func testCurrentEnumValues() {
        XCTAssertEqual(Current(rawValue: "no-current"), .noCurrent)
        XCTAssertEqual(Current(rawValue: "very-mild-current"), .veryMildCurrent)
        XCTAssertEqual(Current(rawValue: "mild-current"), .mildCurrent)
        XCTAssertEqual(Current(rawValue: "moderate-current"), .moderateCurrent)
        XCTAssertEqual(Current(rawValue: "hard-current"), .hardCurrent)
        XCTAssertEqual(Current(rawValue: "very-hard-current"), .veryHardCurrent)

        let unknown = Current(rawValue: "ripping")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - DivePlan Enum Tests

    func testDivePlanEnumValues() {
        XCTAssertEqual(DivePlan(rawValue: "none"), DivePlan.none)
        XCTAssertEqual(DivePlan(rawValue: "table"), .table)
        XCTAssertEqual(DivePlan(rawValue: "dive-computer"), .diveComputer)
        XCTAssertEqual(DivePlan(rawValue: "another-diver"), .anotherDiver)

        let unknown = DivePlan(rawValue: "gut-feeling")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - ThermalComfort Enum Tests

    func testThermalComfortEnumValues() {
        XCTAssertEqual(ThermalComfort(rawValue: "not-indicated"), .notIndicated)
        XCTAssertEqual(ThermalComfort(rawValue: "comfortable"), .comfortable)
        XCTAssertEqual(ThermalComfort(rawValue: "cold"), .cold)
        XCTAssertEqual(ThermalComfort(rawValue: "very-cold"), .veryCold)
        XCTAssertEqual(ThermalComfort(rawValue: "hot"), .hot)

        let unknown = ThermalComfort(rawValue: "freezing")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - Workload Enum Tests

    func testWorkloadEnumValues() {
        XCTAssertEqual(Workload(rawValue: "not-specified"), .notSpecified)
        XCTAssertEqual(Workload(rawValue: "resting"), .resting)
        XCTAssertEqual(Workload(rawValue: "light"), .light)
        XCTAssertEqual(Workload(rawValue: "moderate"), .moderate)
        XCTAssertEqual(Workload(rawValue: "severe"), .severe)
        XCTAssertEqual(Workload(rawValue: "exhausting"), .exhausting)

        let unknown = Workload(rawValue: "extreme")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - EquipmentMalfunction Enum Tests

    func testEquipmentMalfunctionEnumValues() {
        XCTAssertEqual(EquipmentMalfunction(rawValue: "none"), EquipmentMalfunction.none)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "face-mask"), .faceMask)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "fins"), .fins)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "weight-belt"), .weightBelt)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "buoyancy-control-device"), .buoyancyControlDevice)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "thermal-protection"), .thermalProtection)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "dive-computer"), .diveComputer)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "depth-gauge"), .depthGauge)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "pressure-gauge"), .pressureGauge)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "breathing-apparatus"), .breathingApparatus)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "deco-reel"), .decoReel)
        XCTAssertEqual(EquipmentMalfunction(rawValue: "other"), .other)

        let unknown = EquipmentMalfunction(rawValue: "torch")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - Program Enum Tests

    func testProgramEnumValues() {
        XCTAssertEqual(Program(rawValue: "recreation"), .recreation)
        XCTAssertEqual(Program(rawValue: "training"), .training)
        XCTAssertEqual(Program(rawValue: "scientific"), .scientific)
        XCTAssertEqual(Program(rawValue: "medical"), .medical)
        XCTAssertEqual(Program(rawValue: "commercial"), .commercial)
        XCTAssertEqual(Program(rawValue: "military"), .military)
        XCTAssertEqual(Program(rawValue: "competitive"), .competitive)
        XCTAssertEqual(Program(rawValue: "other"), .other)

        let unknown = Program(rawValue: "expedition")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - StateOfRestBeforeDive Enum Tests

    func testStateOfRestBeforeDiveEnumValues() {
        XCTAssertEqual(StateOfRestBeforeDive(rawValue: "not-specified"), .notSpecified)
        XCTAssertEqual(StateOfRestBeforeDive(rawValue: "rested"), .rested)
        XCTAssertEqual(StateOfRestBeforeDive(rawValue: "tired"), .tired)
        XCTAssertEqual(StateOfRestBeforeDive(rawValue: "exhausted"), .exhausted)

        let unknown = StateOfRestBeforeDive(rawValue: "sleepy")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - ExerciseBeforeDive Enum Tests

    func testExerciseBeforeDiveEnumValues() {
        XCTAssertEqual(ExerciseBeforeDive(rawValue: "none"), ExerciseBeforeDive.none)
        XCTAssertEqual(ExerciseBeforeDive(rawValue: "light"), .light)
        XCTAssertEqual(ExerciseBeforeDive(rawValue: "moderate"), .moderate)
        XCTAssertEqual(ExerciseBeforeDive(rawValue: "heavy"), .heavy)

        let unknown = ExerciseBeforeDive(rawValue: "extreme")
        XCTAssertEqual(unknown.rawValue, "extreme")
        XCTAssertEqual(unknown.isStandard, false)
    }

    // MARK: - DiveTable Enum Tests

    func testDiveTableEnumValues() {
        XCTAssertEqual(DiveTable(rawValue: "PADI"), .padi)
        XCTAssertEqual(DiveTable(rawValue: "NAUI"), .naui)
        XCTAssertEqual(DiveTable(rawValue: "BSAC"), .bsac)
        XCTAssertEqual(DiveTable(rawValue: "Buehlmann"), .buehlmann)
        XCTAssertEqual(DiveTable(rawValue: "DCIEM"), .dciem)
        XCTAssertEqual(DiveTable(rawValue: "US-Navy"), .usNavy)
        XCTAssertEqual(DiveTable(rawValue: "CSMD"), .csmd)
        XCTAssertEqual(DiveTable(rawValue: "COMEX"), .comex)
        XCTAssertEqual(DiveTable(rawValue: "other"), .other)

        let unknown = DiveTable(rawValue: "custom")
        XCTAssertEqual(unknown.rawValue, "custom")
        XCTAssertEqual(unknown.isStandard, false)
    }
}
