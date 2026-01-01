# Agent Instructions for Tests

## Fixtures Organization

Test fixtures in `Tests/UDDFTests/Fixtures/` are organized by UDDF specification sections for better discoverability and maintenance.

### Fixture Categories

Each directory corresponds to a major UDDF specification section:

- **business/** - Business entities (dive shops, training organizations)
- **decomodel/** - Decompression models (Buhlmann, VPM-B, etc.)
- **divecomputercontrol/** - Dive computer control configurations
- **diver/** - Diver information (owner, buddies, equipment)
- **divesite/** - Dive site data (geography, GPS coordinates)
- **divetrip/** - Complete dive trip information
- **gasdefinitions/** - Gas mix definitions (Air, Nitrox, Trimix, etc.)
- **generator/** - Generator/source application metadata
- **maker/** - Equipment manufacturer information
- **mediadata/** - Media attachments (images, videos, audio)
- **profiledata/** - Dive profile data (samples, waypoints, dive information)
- **real/** - Real-world examples from actual dive computers
- **tablegeneration/** - Dive table generation data

### File Naming Convention

Within each directory:

- `basic.uddf` - Minimal valid example with essential elements
- `full.uddf` - Comprehensive example with optional elements
- Descriptive names for specialized cases (e.g., `waypoint_extended_fields.uddf`)

### Benefits

- **Discoverability** - Easier to find relevant fixtures by UDDF section
- **Maintainability** - Clear organization reduces fixture sprawl
- **Completeness** - Comprehensive coverage of UDDF specification areas
- **Testing** - Better isolation of tests by specification section
