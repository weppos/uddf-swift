import Foundation

/// Resolves ID/IDREF cross-references in UDDF documents
///
/// UDDF uses XML ID and IDREF attributes to link elements across different sections.
/// This resolver builds a registry of all elements with IDs and validates that all
/// references can be resolved.
public class ReferenceResolver {
    /// Registry mapping IDs to their element types
    private var registry: [String: ReferenceableElement] = [:]

    /// Tracks references during resolution to detect circular dependencies
    private var resolutionStack: Set<String> = []

    public init() {}

    // MARK: - Resolution

    /// Resolve all references in a UDDF document
    ///
    /// - Parameter document: The UDDF document to resolve
    /// - Returns: A validation result indicating success or failures
    /// - Throws: UDDFError if resolution fails
    public func resolve(_ document: UDDFDocument) throws -> ResolutionResult {
        // Clear previous state
        registry.removeAll()
        resolutionStack.removeAll()

        // Build the ID registry
        try buildRegistry(document)

        // Validate references
        let validationErrors = validateReferences(document)

        return ResolutionResult(
            registry: registry,
            errors: validationErrors
        )
    }

    // MARK: - Registry Building

    private func buildRegistry(_ document: UDDFDocument) throws {
        // Register divers
        if let owners = document.diver?.owner {
            for owner in owners {
                if let id = owner.id {
                    try register(id: id, element: .diver(owner))
                }
            }
        }

        if let buddies = document.diver?.buddy {
            for buddy in buddies {
                if let id = buddy.id {
                    try register(id: id, element: .buddy(buddy))
                }
            }
        }

        // Register dive sites
        if let sites = document.divesite {
            for site in sites {
                if let id = site.id {
                    try register(id: id, element: .diveSite(site))
                }
            }
        }

        // Register gas mixes
        if let mixes = document.gasdefinitions?.mix {
            for mix in mixes {
                if let id = mix.id {
                    try register(id: id, element: .gasMix(mix))
                }
            }
        }

        // Register repetition groups and dives
        if let groups = document.profiledata?.repetitiongroup {
            for group in groups {
                if let id = group.id {
                    try register(id: id, element: .repetitionGroup(group))
                }

                if let dives = group.dive {
                    for dive in dives {
                        if let id = dive.id {
                            try register(id: id, element: .dive(dive))
                        }
                    }
                }
            }
        }

        // Register media
        if let images = document.mediadata?.image {
            for image in images {
                if let id = image.id {
                    try register(id: id, element: .image(image))
                }
            }
        }

        if let audio = document.mediadata?.audio {
            for audio in audio {
                if let id = audio.id {
                    try register(id: id, element: .audio(audio))
                }
            }
        }

        if let video = document.mediadata?.video {
            for video in video {
                if let id = video.id {
                    try register(id: id, element: .video(video))
                }
            }
        }

        // Register makers
        if let makers = document.maker {
            for maker in makers {
                if let id = maker.id {
                    try register(id: id, element: .maker(maker))
                }
            }
        }

        // Register businesses
        if let businesses = document.business {
            for business in businesses {
                if let id = business.id {
                    try register(id: id, element: .business(business))
                }
            }
        }

        // Register decompression models
        if let models = document.decomodel {
            for model in models {
                if let id = model.id {
                    try register(id: id, element: .decoModel(model))
                }
            }
        }

        // Register dive trips
        if let trips = document.divetrip {
            for trip in trips {
                if let id = trip.id {
                    try register(id: id, element: .diveTrip(trip))
                }
            }
        }
    }

    private func register(id: String, element: ReferenceableElement) throws {
        if registry[id] != nil {
            throw UDDFError.duplicateID(id)
        }
        registry[id] = element
    }

    // MARK: - Reference Validation

    private func validateReferences(_ document: UDDFDocument) -> [ReferenceError] {
        var errors: [ReferenceError] = []

        // Validate references in notes/links
        if let groups = document.profiledata?.repetitiongroup {
            for group in groups {
                if let dives = group.dive {
                    for dive in dives {
                        // Check information before dive
                        if let notes = dive.informationbeforedive?.notes {
                            errors.append(contentsOf: validateLinkReferences(in: notes))
                        }

                        // Check information after dive
                        if let notes = dive.informationafterdive?.notes {
                            errors.append(contentsOf: validateLinkReferences(in: notes))
                        }
                    }
                }
            }
        }

        // Validate table generation references
        if let link = document.tablegeneration?.link {
            if let ref = link.ref, !registry.keys.contains(ref) {
                errors.append(ReferenceError(
                    referenceID: ref,
                    location: "tablegeneration.link",
                    message: "Unresolved reference to '\(ref)'"
                ))
            }
        }

        return errors
    }

    private func validateLinkReferences(in notes: Notes) -> [ReferenceError] {
        var errors: [ReferenceError] = []

        if let link = notes.link {
            if let ref = link.ref, !registry.keys.contains(ref) {
                errors.append(ReferenceError(
                    referenceID: ref,
                    location: "notes.link",
                    message: "Unresolved reference to '\(ref)'"
                ))
            }
        }

        return errors
    }

    // MARK: - Public Query Methods

    /// Look up an element by its ID
    public func element(for id: String) -> ReferenceableElement? {
        registry[id]
    }

    /// Check if an ID exists in the registry
    public func contains(id: String) -> Bool {
        registry.keys.contains(id)
    }

    /// Get all registered IDs
    public var allIDs: [String] {
        Array(registry.keys)
    }
}

// MARK: - Supporting Types

/// Elements that can be referenced by ID
public enum ReferenceableElement: Equatable {
    case diver(Owner)
    case buddy(Buddy)
    case diveSite(DiveSite)
    case gasMix(Mix)
    case repetitionGroup(RepetitionGroup)
    case dive(Dive)
    case image(ImageMedia)
    case audio(AudioMedia)
    case video(VideoMedia)
    case maker(Maker)
    case business(Business)
    case decoModel(DecoModel)
    case diveTrip(DiveTrip)
}

/// A reference resolution error
public struct ReferenceError: Equatable {
    /// The reference ID that couldn't be resolved
    public let referenceID: String

    /// Where in the document the reference appears
    public let location: String

    /// Error message
    public let message: String
}

/// Result of reference resolution
public struct ResolutionResult {
    /// The ID registry
    public let registry: [String: ReferenceableElement]

    /// Any errors found during resolution
    public let errors: [ReferenceError]

    /// Whether resolution was successful (no errors)
    public var isValid: Bool {
        errors.isEmpty
    }
}
