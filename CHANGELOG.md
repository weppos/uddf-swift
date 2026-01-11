# Changelog

## Unreleased

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
