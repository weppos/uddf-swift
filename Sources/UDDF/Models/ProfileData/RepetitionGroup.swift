import Foundation
import XMLCoder

/// A repetition group contains dives performed in sequence
///
/// Dives within a repetition group are related (e.g., performed on the same
/// day or as part of the same dive trip) and may affect decompression calculations.
public struct RepetitionGroup: Codable, Equatable {
    /// Unique identifier for this repetition group
    public var id: String?

    /// One or more dives in this group
    public var dive: [Dive]?

    public init(id: String? = nil, dive: [Dive]? = nil) {
        self.id = id
        self.dive = dive
    }

    enum CodingKeys: String, CodingKey {
        case id
        case dive
    }
}

// MARK: - DynamicNodeEncoding

extension RepetitionGroup: DynamicNodeEncoding {
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
