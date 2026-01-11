# Agent Instructions for Fixtures

## Critical: Do NOT Modify Real-World Fixtures

The `real/` directory contains fixtures derived from actual dive computer exports. These files represent real-world data and may contain bugs or spec deviations from the original dive computer software.

**Never modify files in the `real/` directory** unless explicitly instructed by the user.

If you notice issues in real-world fixtures (incorrect units, spec violations, etc.):

1. **Do NOT fix them** - they represent actual dive computer behavior
2. **Report the issue** to the user with details about what looks wrong
3. **Comment out or skip** the affected test assertions with a NOTE explaining the issue
4. The user will decide whether to file a bug report with the dive computer manufacturer

## Synthetic Fixtures

Other directories contain synthetic test fixtures that can be modified as needed to match the UDDF specification. These are safe to update when fixing bugs or adding features.

## Known Issues in Real Fixtures

- **shearwater_perdix_closedcircuit_deco.uddf**: `calculatedpo2` values are in bar instead of pascals (SI). This appears to be a bug in Shearwater Cloud Desktop export.
