import Foundation
import XMLCoder

/// Multimedia data (images, audio, video)
///
/// Contains references to multimedia files associated with dives.
public struct UDDFMediaData: Codable, Equatable {
    /// Image files
    public var image: [UDDFImageMedia]?

    /// Audio files
    public var audio: [UDDFAudioMedia]?

    /// Video files
    public var video: [UDDFVideoMedia]?

    public init(image: [UDDFImageMedia]? = nil, audio: [UDDFAudioMedia]? = nil, video: [UDDFVideoMedia]? = nil) {
        self.image = image
        self.audio = audio
        self.video = video
    }
}

/// Image file reference
public struct UDDFImageMedia: Codable, Equatable {
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

extension UDDFImageMedia: DynamicNodeEncoding {
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
public struct UDDFAudioMedia: Codable, Equatable {
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

extension UDDFAudioMedia: DynamicNodeEncoding {
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
public struct UDDFVideoMedia: Codable, Equatable {
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

extension UDDFVideoMedia: DynamicNodeEncoding {
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
