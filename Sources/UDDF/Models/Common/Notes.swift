import Foundation

/// Notes or comments (text content)
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/notes.html
public struct Notes: Codable, Equatable, Sendable {
    /// Links to related notes/media
    public var link: [Link]?

    /// Text content of the note
    public var para: [String]?

    public init(link: [Link]? = nil, para: [String]? = nil) {
        self.link = link
        self.para = para
    }
}
