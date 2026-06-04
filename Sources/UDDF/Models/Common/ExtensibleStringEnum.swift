import Foundation

/// A string-backed UDDF enum that preserves unrecognized values instead of
/// failing to decode.
///
/// UDDF defines closed enumerations, but real-world dive computers emit values
/// outside the specification. Conforming enums model the standard values as
/// cases and collect everything else in a catch-all `unknown(String)` case, so
/// parsing never fails on an unexpected token and the original text round-trips.
///
/// A conformer only has to provide the case mapping (`init(rawValue:)` and
/// `rawValue`). This protocol supplies the single-value-string `Codable`
/// conformance that was otherwise hand-copied into every such enum.
public protocol ExtensibleStringEnum: Codable, Equatable, Sendable {
    /// Create a value from its raw string.
    ///
    /// Unrecognized input must map to the catch-all case rather than failing,
    /// so this initializer is non-failable.
    init(rawValue: String)

    /// The raw string value.
    var rawValue: String { get }
}

public extension ExtensibleStringEnum {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(String.self))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
