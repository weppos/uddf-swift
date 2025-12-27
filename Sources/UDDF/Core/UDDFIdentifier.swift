import Foundation

/// Type-safe wrapper for UDDF element IDs
///
/// UDDF elements use ID attributes to uniquely identify elements that can be
/// referenced from other parts of the document using IDREF attributes.
public struct UDDFIdentifier: Codable, Equatable, Hashable {
    /// The unique identifier string
    public let value: String

    public init(_ value: String) {
        self.value = value
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

// MARK: - ExpressibleByStringLiteral

extension UDDFIdentifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.value = value
    }
}

// MARK: - CustomStringConvertible

extension UDDFIdentifier: CustomStringConvertible {
    public var description: String {
        value
    }
}
