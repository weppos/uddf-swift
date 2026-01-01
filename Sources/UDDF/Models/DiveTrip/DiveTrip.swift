import Foundation
import XMLCoder

/// Multi-dive trip information
///
/// Contains information about a dive trip spanning multiple days or dives.
public struct DiveTrip: Codable, Equatable, Sendable {
    /// Unique identifier
    public var id: String?

    /// Trip name
    public var name: String?

    /// Trip notes
    public var notes: Notes?

    public init(id: String? = nil, name: String? = nil, notes: Notes? = nil) {
        self.id = id
        self.name = name
        self.notes = notes
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case notes
    }
}

// MARK: - DynamicNodeEncoding

extension DiveTrip: DynamicNodeEncoding {
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
