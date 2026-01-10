# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

### Added

- Add `EquipmentUsed` and `TankData` models for dive-specific equipment
- Add `equipmentused` property to `Dive` struct for gas mix references per dive

## 0.1.0 - 2026-01-07

### Added

- Initial UDDF parser implementation with XMLCoder
- Support for UDDF 3.2.x specification
- Document validation with warnings and errors
- Fluent builder API for creating UDDF documents
- Reference resolution and validation
- Real-world dive computer compatibility (relaxed validation)
