import Foundation
import XMLCoder

/// Video camera with body, housing, and lights
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/videocamera.html
public struct VideoCamera: Codable, Equatable, Sendable {
    /// Unique identifier
    public var id: String?

    /// Video camera body
    public var body: CameraBody?

    /// Underwater housing
    public var housing: Housing?

    /// Video lights
    public var light: [Light]?

    public init(
        id: String? = nil,
        body: CameraBody? = nil,
        housing: Housing? = nil,
        light: [Light]? = nil
    ) {
        self.id = id
        self.body = body
        self.housing = housing
        self.light = light
    }

    enum CodingKeys: String, CodingKey {
        case id, body, housing, light
    }
}

extension VideoCamera: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}
