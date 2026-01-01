import Foundation
import XMLCoder

/// Multimedia data (images, audio, video)
///
/// Contains references to multimedia files associated with dives.
public struct MediaData: Codable, Equatable, Sendable {
    /// Image files
    public var image: [ImageMedia]?

    /// Audio files
    public var audio: [AudioMedia]?

    /// Video files
    public var video: [VideoMedia]?

    public init(image: [ImageMedia]? = nil, audio: [AudioMedia]? = nil, video: [VideoMedia]? = nil) {
        self.image = image
        self.audio = audio
        self.video = video
    }
}

/// Image file reference
public struct ImageMedia: Codable, Equatable, Sendable {
    /// Unique identifier
    public var id: String?

    /// Image title
    public var title: String?

    /// File path or URL
    public var objectname: String?

    public init(id: String? = nil, title: String? = nil, objectname: String? = nil) {
        self.id = id
        self.title = title
        self.objectname = objectname
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case objectname
    }
}

// MARK: - DynamicNodeEncoding

extension ImageMedia: DynamicNodeEncoding {
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

/// Audio file reference
public struct AudioMedia: Codable, Equatable, Sendable {
    /// Unique identifier
    public var id: String?

    /// Audio title
    public var title: String?

    /// File path or URL
    public var objectname: String?

    public init(id: String? = nil, title: String? = nil, objectname: String? = nil) {
        self.id = id
        self.title = title
        self.objectname = objectname
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case objectname
    }
}

// MARK: - DynamicNodeEncoding

extension AudioMedia: DynamicNodeEncoding {
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

/// Video file reference
public struct VideoMedia: Codable, Equatable, Sendable {
    /// Unique identifier
    public var id: String?

    /// Video title
    public var title: String?

    /// File path or URL
    public var objectname: String?

    public init(id: String? = nil, title: String? = nil, objectname: String? = nil) {
        self.id = id
        self.title = title
        self.objectname = objectname
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case objectname
    }
}

// MARK: - DynamicNodeEncoding

extension VideoMedia: DynamicNodeEncoding {
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
