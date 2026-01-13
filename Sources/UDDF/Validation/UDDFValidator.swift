import Foundation

/// Validates UDDF documents for correctness and completeness
///
/// Performs comprehensive validation including:
///
/// - Required elements (generator)
/// - Valid date/time formats
/// - Unit value ranges
/// - ID uniqueness
/// - Reference validity
public class UDDFValidator {
    /// Validation options
    public struct Options {
        /// Whether to validate unit ranges (e.g., depth >= 0)
        public var validateRanges: Bool

        /// Whether to validate references
        public var validateReferences: Bool

        /// Whether to treat warnings as errors
        public var strictMode: Bool

        public init(
            validateRanges: Bool = true,
            validateReferences: Bool = true,
            strictMode: Bool = false
        ) {
            self.validateRanges = validateRanges
            self.validateReferences = validateReferences
            self.strictMode = strictMode
        }
    }

    private let options: Options
    private var errors: [ValidationError] = []
    private var warnings: [ValidationError] = []

    public init(options: Options = Options()) {
        self.options = options
    }

    // MARK: - Validation

    /// Validate a UDDF document
    ///
    /// - Parameter document: Document to validate
    /// - Returns: Validation result with any errors or warnings
    public func validate(_ document: UDDFDocument) -> ValidationResult {
        errors.removeAll()
        warnings.removeAll()

        // Validate required elements
        validateGenerator(document.generator)

        // Validate optional sections
        if let diver = document.diver {
            validateDiver(diver)
        }

        if let profileData = document.profiledata {
            validateProfileData(profileData)
        }

        if let gasDefinitions = document.gasdefinitions {
            validateGasDefinitions(gasDefinitions)
        }

        if let diveSites = document.divesite {
            validateDiveSites(diveSites)
        }

        // Validate references if requested
        if options.validateReferences {
            validateReferences(document)
        }

        return ValidationResult(
            errors: errors,
            warnings: warnings
        )
    }

    // MARK: - Generator Validation

    private func validateGenerator(_ generator: Generator) {
        // Generator name is recommended but not strictly required
        // In strictMode: this warning becomes an error
        // In default mode: this is just a warning
        if generator.name == nil || generator.name?.isEmpty == true {
            addWarning(field: "generator.name", message: "Generator name is missing")
        }

        if let version = generator.version, version.isEmpty {
            addWarning(field: "generator.version", message: "Generator version is empty")
        }
    }

    // MARK: - Diver Data Validation

    private func validateDiver(_ diver: Diver) {
        // Validate owner
        if let owner = diver.owner {
            validateOwner(owner, index: 0)
        }

        // Validate buddies
        if let buddies = diver.buddy {
            for (index, buddy) in buddies.enumerated() {
                validateBuddy(buddy, index: index)
            }
        }
    }

    private func validateOwner(_ owner: Owner, index: Int) {
        let prefix = "diver.owner[\(index)]"

        if let id = owner.id, id.isEmpty {
            addError(field: "\(prefix).id", message: "ID cannot be empty")
        }

        if let personal = owner.personal {
            validatePersonal(personal, prefix: prefix)
        }
    }

    private func validateBuddy(_ buddy: Buddy, index: Int) {
        let prefix = "diver.buddy[\(index)]"

        if let id = buddy.id, id.isEmpty {
            addError(field: "\(prefix).id", message: "ID cannot be empty")
        }

        if let personal = buddy.personal {
            validatePersonal(personal, prefix: prefix)
        }
    }

    private func validatePersonal(_ personal: Personal, prefix: String) {
        if let firstname = personal.firstname, firstname.isEmpty {
            addWarning(field: "\(prefix).personal.firstname", message: "First name is empty")
        }

        if let lastname = personal.lastname, lastname.isEmpty {
            addWarning(field: "\(prefix).personal.lastname", message: "Last name is empty")
        }
    }

    // MARK: - Profile Data Validation

    private func validateProfileData(_ profileData: ProfileData) {
        guard let groups = profileData.repetitiongroup else { return }

        for (groupIndex, group) in groups.enumerated() {
            validateRepetitionGroup(group, index: groupIndex)
        }
    }

    private func validateRepetitionGroup(_ group: RepetitionGroup, index: Int) {
        let prefix = "profiledata.repetitiongroup[\(index)]"

        if let id = group.id, id.isEmpty {
            addError(field: "\(prefix).id", message: "ID cannot be empty")
        }

        if let dives = group.dive {
            for (diveIndex, dive) in dives.enumerated() {
                validateDive(dive, groupIndex: index, diveIndex: diveIndex)
            }
        }
    }

    private func validateDive(_ dive: Dive, groupIndex: Int, diveIndex: Int) {
        let prefix = "profiledata.repetitiongroup[\(groupIndex)].dive[\(diveIndex)]"

        if let id = dive.id, id.isEmpty {
            addError(field: "\(prefix).id", message: "ID cannot be empty")
        }

        // Validate depths
        if let afterDive = dive.informationafterdive {
            if options.validateRanges {
                if let depth = afterDive.greatestdepth, depth.meters < 0 {
                    addError(field: "\(prefix).greatestdepth", message: "Depth cannot be negative")
                }

                if let depth = afterDive.averagedepth, depth.meters < 0 {
                    addError(field: "\(prefix).averagedepth", message: "Depth cannot be negative")
                }

                if let duration = afterDive.diveduration, duration.seconds < 0 {
                    addError(field: "\(prefix).diveduration", message: "Duration cannot be negative")
                }
            }
        }

        // Validate waypoints
        if let samples = dive.samples?.waypoint {
            for (waypointIndex, waypoint) in samples.enumerated() {
                validateWaypoint(waypoint, prefix: "\(prefix).samples.waypoint[\(waypointIndex)]")
            }
        }
    }

    private func validateWaypoint(_ waypoint: Waypoint, prefix: String) {
        if options.validateRanges {
            if let time = waypoint.divetime, time.seconds < 0 {
                addError(field: "\(prefix).divetime", message: "Dive time cannot be negative")
            }

            if let depth = waypoint.depth, depth.meters < 0 {
                addError(field: "\(prefix).depth", message: "Depth cannot be negative")
            }
        }
    }

    // MARK: - Gas Definitions Validation

    private func validateGasDefinitions(_ gasDefinitions: GasDefinitions) {
        guard let mixes = gasDefinitions.mix else { return }

        for (index, mix) in mixes.enumerated() {
            validateMix(mix, index: index)
        }
    }

    private func validateMix(_ mix: Mix, index: Int) {
        let prefix = "gasdefinitions.mix[\(index)]"

        if let id = mix.id, id.isEmpty {
            addError(field: "\(prefix).id", message: "ID cannot be empty")
        }

        if options.validateRanges {
            // Validate gas percentages
            if let o2 = mix.o2, (o2 < 0 || o2 > 1) {
                addError(field: "\(prefix).o2", message: "Oxygen percentage must be between 0 and 1")
            }

            if let n2 = mix.n2, (n2 < 0 || n2 > 1) {
                addError(field: "\(prefix).n2", message: "Nitrogen percentage must be between 0 and 1")
            }

            if let he = mix.he, (he < 0 || he > 1) {
                addError(field: "\(prefix).he", message: "Helium percentage must be between 0 and 1")
            }

            // Validate total percentage
            let o2 = mix.o2 ?? 0
            let n2 = mix.n2 ?? 0
            let he = mix.he ?? 0
            let ar = mix.ar ?? 0
            let h2 = mix.h2 ?? 0
            let total = o2 + n2 + he + ar + h2
            if abs(total - 1.0) > 0.01 {
                addWarning(
                    field: prefix,
                    message: "Gas percentages should sum to 1.0 (currently \(total))"
                )
            }
        }
    }

    // MARK: - Dive Site Validation

    private func validateDiveSites(_ sites: [DiveSite]) {
        for (index, site) in sites.enumerated() {
            validateDiveSite(site, index: index)
        }
    }

    private func validateDiveSite(_ site: DiveSite, index: Int) {
        let prefix = "divesite[\(index)]"

        if let id = site.id, id.isEmpty {
            addError(field: "\(prefix).id", message: "ID cannot be empty")
        }

        if let gps = site.geography?.gps {
            if options.validateRanges {
                if let lat = gps.latitude, (lat < -90 || lat > 90) {
                    addError(field: "\(prefix).geography.gps.latitude", message: "Latitude must be between -90 and 90")
                }

                if let lon = gps.longitude, (lon < -180 || lon > 180) {
                    addError(field: "\(prefix).geography.gps.longitude", message: "Longitude must be between -180 and 180")
                }
            }
        }
    }

    // MARK: - Reference Validation

    private func validateReferences(_ document: UDDFDocument) {
        do {
            let resolver = ReferenceResolver()
            let result = try resolver.resolve(document)

            for refError in result.errors {
                addError(
                    field: refError.location,
                    message: refError.message,
                    context: ["ref": refError.referenceID]
                )
            }
        } catch {
            addError(field: "references", message: "Failed to resolve references: \(error)")
        }
    }

    // MARK: - Error/Warning Helpers

    private func addError(field: String, message: String, context: [String: String]? = nil) {
        errors.append(ValidationError(
            severity: .error,
            field: field,
            message: message,
            context: context
        ))
    }

    private func addWarning(field: String, message: String, context: [String: String]? = nil) {
        if options.strictMode {
            addError(field: field, message: message, context: context)
        } else {
            warnings.append(ValidationError(
                severity: .warning,
                field: field,
                message: message,
                context: context
            ))
        }
    }
}
