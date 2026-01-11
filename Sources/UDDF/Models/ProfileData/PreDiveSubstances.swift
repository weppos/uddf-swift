import Foundation

/// Alcohol consumed before a dive
///
/// Container for alcoholic beverages consumed before a dive.
/// If present, at least one drink element must be provided.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/alcoholbeforedive.html
public struct AlcoholBeforeDive: Codable, Equatable, Sendable {
    /// List of alcoholic drinks consumed before the dive
    ///
    /// At least one drink must be present if this element exists.
    public var drink: [Drink]

    public init(drink: [Drink]) {
        self.drink = drink
    }
}

/// An alcoholic drink consumed before a dive
///
/// Documents a specific alcoholic beverage consumed before diving.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/drink.html
public struct Drink: Codable, Equatable, Sendable {
    /// Name of the drink
    public var name: String?

    /// Alternative name for the drink
    public var aliasname: String?

    /// Additional notes about the drink
    public var notes: Notes?

    /// Whether the drink is consumed periodically/habitually
    ///
    /// Uses "yes" or "no" string values.
    public var periodicallytaken: String?

    /// Time between consumption and dive start
    ///
    /// - Unit: seconds (SI)
    public var timespanbeforedive: Duration?

    public init(
        name: String? = nil,
        aliasname: String? = nil,
        notes: Notes? = nil,
        periodicallytaken: String? = nil,
        timespanbeforedive: Duration? = nil
    ) {
        self.name = name
        self.aliasname = aliasname
        self.notes = notes
        self.periodicallytaken = periodicallytaken
        self.timespanbeforedive = timespanbeforedive
    }
}

/// Medication taken before a dive
///
/// Container for medications taken before a dive.
/// If present, at least one medicine element must be provided.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/medicationbeforedive.html
public struct MedicationBeforeDive: Codable, Equatable, Sendable {
    /// List of medicines taken before the dive
    ///
    /// At least one medicine must be present if this element exists.
    public var medicine: [Medicine]

    public init(medicine: [Medicine]) {
        self.medicine = medicine
    }
}

/// A medicine taken before a dive
///
/// Documents a specific medication taken before diving.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/medicine.html
public struct Medicine: Codable, Equatable, Sendable {
    /// Unique identifier for this medicine
    public var id: String?

    /// Name of the medicine
    public var name: String?

    /// Alternative name for the medicine
    public var aliasname: String?

    /// Additional notes about the medicine
    public var notes: Notes?

    /// Whether the medicine is taken periodically/regularly
    ///
    /// Uses "yes" or "no" string values.
    public var periodicallytaken: String?

    /// Time between taking the medicine and dive start
    ///
    /// - Unit: seconds (SI)
    public var timespanbeforedive: Duration?

    public init(
        id: String? = nil,
        name: String? = nil,
        aliasname: String? = nil,
        notes: Notes? = nil,
        periodicallytaken: String? = nil,
        timespanbeforedive: Duration? = nil
    ) {
        self.id = id
        self.name = name
        self.aliasname = aliasname
        self.notes = notes
        self.periodicallytaken = periodicallytaken
        self.timespanbeforedive = timespanbeforedive
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case aliasname
        case notes
        case periodicallytaken
        case timespanbeforedive
    }
}

// MARK: - DynamicNodeEncoding

import XMLCoder

extension Medicine: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let codingKey = key as? CodingKeys else {
            return .element
        }

        switch codingKey {
        case .id:
            return .attribute
        default:
            return .element
        }
    }
}

/// Exercise level before a dive
///
/// Describes the physical activity level before the dive.
/// From DAN Project Dive Exploration standard.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/exercisebeforedive.html
public struct ExerciseBeforeDive: Equatable, Sendable {
    /// No exercise before the dive
    public static let none = ExerciseBeforeDive(rawValue: "none")
    /// Light exercise before the dive
    public static let light = ExerciseBeforeDive(rawValue: "light")
    /// Moderate exercise before the dive
    public static let moderate = ExerciseBeforeDive(rawValue: "moderate")
    /// Heavy exercise before the dive
    public static let heavy = ExerciseBeforeDive(rawValue: "heavy")

    /// The raw string value
    public let rawValue: String

    /// Whether this is a standard UDDF value
    public var isStandard: Bool {
        switch rawValue {
        case "none", "light", "moderate", "heavy":
            return true
        default:
            return false
        }
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension ExerciseBeforeDive: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
