import Foundation
import XMLCoder

/// Decompression model parameters
///
/// Contains decompression algorithm settings and parameters.
public struct UDDFDecoModel: Codable, Equatable {
    /// Unique identifier
    public var id: String?

    /// Model name (e.g., "Bühlmann ZHL-16C")
    public var name: String?

    /// Model type
    public var type: String?

    public init(id: String? = nil, name: String? = nil, type: String? = nil) {
        self.id = id
        self.name = name
        self.type = type
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
    }
}

// MARK: - DynamicNodeEncoding

extension UDDFDecoModel: DynamicNodeEncoding {
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
