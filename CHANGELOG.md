# Changelog

## Unreleased

## 0.9.0 - 2026-01-14

### Added

- Add `address` and `contact` properties to `Owner` and `Buddy`
- Add `equipment` property to `Buddy`
- Add complete `Personal` properties: `honorific`, `sex`, `height`, `weight`, `smoking`, `passport`, `bloodgroup`, `membership`, `numberofdives`
- Add `Sex` enum with hybrid pattern for biological sex values
- Add `Smoking` enum with hybrid pattern for smoking habit values
- Add `Membership` struct for organization memberships
- Add `NumberOfDives` struct for dive count in time intervals
- Add `Birthdate` wrapper struct containing datetime
- Add `education` property to `Owner` and `Buddy` for certification records
- Add `Education` struct containing certification array
- Add `Certification` struct with level, organization, instructor, issuedate, validdate, specialty, and link
- Add `Instructor` struct with personal, address, contact, and notes
- Add `IssueDate` and `ValidDate` wrapper structs containing datetime

### Changed

- **BREAKING**: Rename `DiverData` to `Diver`
- **BREAKING**: Change `Diver.owner` from `[Owner]?` to `Owner?` (single owner per UDDF spec)
- **BREAKING**: Change `Personal.birthdate` from `Date?` to `Birthdate?` (wrapper with datetime)
- **BREAKING**: Remove `Personal.contact` (contact is at owner/buddy level per UDDF spec)
- **BREAKING**: Reorder `Owner` and `Buddy` init parameters: `personal` now precedes `address`
- **BREAKING**: Change `Notes.link` from `Link?` to `[Link]?` (array per UDDF spec)

## 0.8.0 - 2026-01-13

### Added

- Add `heading` field to `Waypoint` for compass heading in degrees
- Add `otu` field to `Waypoint` for Oxygen Toxicity Units
- Add `remainingo2time` field to `Waypoint` for remaining time until oxygen toxicity

## 0.7.0 - 2026-01-12

### Added

- Add `measuredpo2` field to `Waypoint` for measured PPO2 from sensors

### Changed

- **BREAKING**: Change `Waypoint.calculatedpo2` from `Double` to `Pressure` (pascals SI)
- Document `Waypoint.heartrate` as non-standard extension (not in UDDF 3.2.1 spec)

### Removed

- **BREAKING**: Remove `Waypoint.ceiling` (not in UDDF spec, was Shearwater-specific)

## 0.6.0 - 2026-01-11

### Added

- Add `AlcoholBeforeDive`, `Drink` structs for pre-dive alcohol consumption tracking
- Add `MedicationBeforeDive`, `Medicine` structs for pre-dive medication tracking
- Add `ExerciseBeforeDive` type with standard values (none, light, moderate, heavy)
- Add `NoSuit` marker element for dives without protective suit
- Add `PlannedProfile` struct for planned dive profiles with waypoints
- Add `DiveTable` type with standard decompression table values (PADI, NAUI, Buehlmann, etc.)
- Add `HyperbaricFacilityTreatment` struct for recompression treatment records
- Add `GlobalAlarmsGiven` container with `globalalarm` string array

### Changed

- **BREAKING**: Move `purpose` from `InformationAfterDive` to `InformationBeforeDive`
- **BREAKING**: Remove `notes` from `InformationBeforeDive` (not in UDDF spec)
- Reorder `internaldivenumber` after `divenumberofday` in `InformationBeforeDive`
- Add `UDDFDateFormat` option (`.utc`, `.local`) for configuring date serialization format

## 0.5.0 - 2026-01-11

### Added

- Add full `<dive>` element support with all `<informationbeforedive>` and `<informationafterdive>` child elements
- Add `Altitude` unit type (meters SI, feet conversion)
- Add full `equipment` element support for all 21 UDDF equipment types
- Add `Shop` struct for vendor/shop information
- Add `Price` struct with currency attribute
- Add `Purchase` struct for equipment purchase information
- Add full `decomodel` support with `Buehlmann`, `VPM`, and `RGBM` models
- Add `Tissue` struct with gas, number, halflife, a, b attributes
- Add `TissueGas` enum (n2, he, h2) with hybrid pattern for forward compatibility
- Add `UDDFBuilder.addBuehlmann()`, `addVPM()`, `addRGBM()` methods for building decomodels

### Changed

- Move `Notes` to `Models/Common/` for reuse by equipment types
- **BREAKING**: Rewrite `DecoModel` as container with `buehlmann[]`, `vpm[]`, `rgbm[]` arrays
- **BREAKING**: Change `UDDFDocument.decomodel` from `[DecoModel]?` to `DecoModel?`

## 0.4.0 - 2026-01-11

### Added

- Add `GeneratorType` enum and `Generator.type` property
- Add `Generator.aliasname` and `Generator.link` properties
- Add `Address` struct for postal addresses (shared across models)
- Add `Manufacturer.aliasname` and `Manufacturer.address` properties
- Add `Manufacturer.id` attribute (compulsory per UDDF spec)
- Add `Maker.aliasname` and `Maker.address` properties
- Add `Business.aliasname` and `Business.address` properties
- Add `Contact.language`, `Contact.mobilephone`, and `Contact.fax` properties

### Changed

- Rename `ManufacturerInfo` to `Manufacturer` (breaking change)
- Remove `Generator.contact` property (not in UDDF spec)
- Reorder `Generator` and `Contact` properties to match UDDF spec (breaking change)
- Move `Contact`, `Link`, and `Manufacturer` to shared `Models/Common/` directory
- Rename `Sources/UDDF/Parser/` to `Sources/UDDF/Serialization/`

### Fixed

- Include XML declaration header in exported UDDF files
- Include `xmlns` namespace attribute in exported UDDF files

## 0.3.0 - 2026-01-11

### Added

- Add `GasUsage` enum and `Mix.usage` property (libdivecomputer)

### Fixed

- Preserve XML element order as defined in models instead of sorting alphabetically

## 0.2.0 - 2026-01-10

### Added

- Add `EquipmentUsed` and `TankData` models for dive-specific equipment
- Add `equipmentused` property to `Dive` struct for gas mix references per dive
- Add `Volume` unit type with SI unit (m³) and conversions to liters and cubic feet
- Add `TankData.id` attribute and `TankData.breathingconsumptionvolume` element per UDDF spec

### Changed

- `TankData.tankvolume` now uses `Volume` type instead of `Double` (breaking change)
- `Pressure` now stores internally in pascals (SI unit) instead of bar (breaking change)
- Standardize unit documentation with `- Unit:` tags across all models

## 0.1.0 - 2026-01-07

### Added

- Initial UDDF parser implementation with XMLCoder
- Support for UDDF 3.2.x specification
- Document validation with warnings and errors
- Fluent builder API for creating UDDF documents
- Reference resolution and validation
- Real-world dive computer compatibility (relaxed validation)
