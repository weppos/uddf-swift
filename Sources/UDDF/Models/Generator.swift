import Foundation
import XMLCoder

// MARK: - Generator

/// REQUIRED section identifying the software that created the UDDF file
///
/// Every UDDF file must contain a generator section that identifies the
/// application that created or last modified the file.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/generator.html
public struct Generator: Codable, Equatable, Sendable {
    /// Name of the generating application
    ///
    /// Recommended but not strictly required. Missing names produce
    /// a validation warning (or error in strict mode).
    ///
    /// Some real-world dive computers may omit this field.
    public var name: String?

    /// Alternative names for the generator
    public var aliasname: [String]?

    /// Manufacturer or developer of the application
    public var manufacturer: Manufacturer?

    /// Version of the generating software
    public var version: String?

    /// Date and time when the file was created or last modified
    public var datetime: Date?

    /// Type of generator (dive computer, logbook, or converter)
    public var type: GeneratorType?

    /// Cross-reference to another element
    public var link: Link?

    public init(
        name: String? = nil,
        aliasname: [String]? = nil,
        manufacturer: Manufacturer? = nil,
        version: String? = nil,
        datetime: Date? = nil,
        type: GeneratorType? = nil,
        link: Link? = nil
    ) {
        self.name = name
        self.aliasname = aliasname
        self.manufacturer = manufacturer
        self.version = version
        self.datetime = datetime
        self.type = type
        self.link = link
    }
}

/// Type of generator that created the UDDF file
///
/// Indicates whether the file was created by a dive computer, logbook software,
/// or a converter program.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/type.html
public enum GeneratorType: Equatable, Sendable {
    /// A converter program generated the UDDF file from a manufacturer's own format
    case converter
    /// A dive computer generated the UDDF file
    case divecomputer
    /// A logbook program generated the UDDF file
    case logbook
    /// Non-standard or future value
    case unknown(String)

    public var rawValue: String {
        switch self {
        case .converter: return "converter"
        case .divecomputer: return "divecomputer"
        case .logbook: return "logbook"
        case .unknown(let value): return value
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case "converter": self = .converter
        case "divecomputer": self = .divecomputer
        case "logbook": self = .logbook
        default: self = .unknown(rawValue)
        }
    }

    /// Whether this is a standard UDDF value
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

extension GeneratorType: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(rawValue: value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
