import Foundation
import XMLCoder

/// Number of dives in a given time interval
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/numberofdives.html
public struct NumberOfDives: Codable, Equatable, Sendable {
    /// Start date of the interval (ISO 8601 format)
    public var startdate: String

    /// End date of the interval (ISO 8601 format)
    public var enddate: String

    /// Number of dives in the interval
    public var dives: Int

    public init(startdate: String, enddate: String, dives: Int) {
        self.startdate = startdate
        self.enddate = enddate
        self.dives = dives
    }

    enum CodingKeys: String, CodingKey {
        case startdate
        case enddate
        case dives
    }
}

// MARK: - DynamicNodeEncoding

extension NumberOfDives: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}
