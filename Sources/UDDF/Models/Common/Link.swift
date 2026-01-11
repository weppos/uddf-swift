import Foundation
import XMLCoder

/// Cross-reference link to another element
///
/// An empty element with a ref attribute pointing to another element's ID.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/link.html
public struct Link: Codable, Equatable, Sendable {
    /// Reference to another element's ID
    public var ref: String?

    public init(ref: String? = nil) {
        self.ref = ref
    }

    enum CodingKeys: String, CodingKey {
        case ref
    }
}

// MARK: - DynamicNodeEncoding

extension Link: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let codingKey = key as? CodingKeys else {
            return .element
        }

        switch codingKey {
        case .ref:
            return .attribute
        }
    }
}
