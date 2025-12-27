import Foundation

/// A reference to another UDDF element by ID
///
/// UDDF uses IDREF attributes to reference elements defined elsewhere in the document.
/// This type represents an unresolved reference (just the ID string) before resolution.
public struct UDDFReference<T>: Codable, Equatable where T: Codable & Equatable {
    /// The referenced ID
    public let ref: String

    public init(ref: String) {
        self.ref = ref
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        ref = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(ref)
    }
}

/// A resolved reference that contains both the ID and the referenced object
///
/// After reference resolution, this type contains the actual referenced object.
public enum UDDFResolvedReference<T>: Equatable where T: Equatable {
    /// The element is defined inline (not a reference)
    case inline(T)

    /// A reference to another element, optionally resolved
    case reference(id: String, resolved: T?)

    /// The referenced object (if resolved)
    public var value: T? {
        switch self {
        case .inline(let obj):
            return obj
        case .reference(_, let resolved):
            return resolved
        }
    }

    /// Whether this reference has been resolved
    public var isResolved: Bool {
        switch self {
        case .inline:
            return true
        case .reference(_, let resolved):
            return resolved != nil
        }
    }

    /// The reference ID (if this is a reference)
    public var referenceID: String? {
        switch self {
        case .inline:
            return nil
        case .reference(let id, _):
            return id
        }
    }
}
