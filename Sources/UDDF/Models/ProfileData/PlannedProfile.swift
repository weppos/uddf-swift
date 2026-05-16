import Foundation
import XMLCoder

/// A planned dive profile
///
/// Describes a theoretical dive profile for comparison against actual dive data.
/// Contains waypoints marking depth and time intervals throughout the planned dive.
///
/// Reference: https://www.streit.cc/resources/UDDF/v3.2.3/en/plannedprofile.html
public struct PlannedProfile: Codable, Equatable, Sendable {
    /// Initial dive mode (required)
    ///
    /// Specifies the breathing apparatus mode at dive start.
    /// Values: "apnea", "closedcircuit", "opencircuit", "semiclosedcircuit"
    /// (Legacy "apnoe" spelling pre-UDDF 3.2.2 is accepted on parse but emitted as "apnea".)
    public var startdivemode: String

    /// Initial breathing gas mix reference (required)
    ///
    /// References the mix ID used at dive start.
    public var startmix: String

    /// Planned waypoints for the dive
    public var waypoint: [Waypoint]?

    public init(
        startdivemode: String,
        startmix: String,
        waypoint: [Waypoint]? = nil
    ) {
        self.startdivemode = startdivemode
        self.startmix = startmix
        self.waypoint = waypoint
    }

    enum CodingKeys: String, CodingKey {
        case startdivemode
        case startmix
        case waypoint
    }
}

// MARK: - DynamicNodeEncoding

extension PlannedProfile: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let codingKey = key as? CodingKeys else {
            return .element
        }

        switch codingKey {
        case .startdivemode, .startmix:
            return .attribute
        default:
            return .element
        }
    }
}
