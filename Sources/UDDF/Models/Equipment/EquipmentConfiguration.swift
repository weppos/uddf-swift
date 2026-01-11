import Foundation
import XMLCoder

/// Equipment configuration (preset gear combinations)
///
/// Allows divers to define reusable equipment configurations by
/// referencing previously defined equipment pieces.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/equipmentconfiguration.html
public struct EquipmentConfiguration: Codable, Equatable, Sendable {
    /// Unique identifier
    public var id: String?

    /// Configuration name
    public var name: String?

    /// Alternative names
    public var aliasname: [String]?

    /// Additional notes
    public var notes: Notes?

    /// Links to equipment pieces in this configuration
    public var link: [Link]?

    public init(
        id: String? = nil,
        name: String? = nil,
        aliasname: [String]? = nil,
        notes: Notes? = nil,
        link: [Link]? = nil
    ) {
        self.id = id
        self.name = name
        self.aliasname = aliasname
        self.notes = notes
        self.link = link
    }

    enum CodingKeys: String, CodingKey {
        case id, name, aliasname, notes, link
    }
}

extension EquipmentConfiguration: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}
