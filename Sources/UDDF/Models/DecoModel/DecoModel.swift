import Foundation
import XMLCoder

// MARK: - DecoModel Container

/// Decompression model container
///
/// Contains configuration for decompression algorithms used in dive planning
/// and real-time calculations. Supports Bühlmann, VPM, and RGBM models.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/decomodel.html
public struct DecoModel: Codable, Equatable, Sendable {
    /// Bühlmann decompression models
    public var buehlmann: [Buehlmann]?

    /// VPM (Varying Permeability Model) configurations
    public var vpm: [VPM]?

    /// RGBM (Reduced Gradient Bubble Model) configurations
    public var rgbm: [RGBM]?

    public init(
        buehlmann: [Buehlmann]? = nil,
        vpm: [VPM]? = nil,
        rgbm: [RGBM]? = nil
    ) {
        self.buehlmann = buehlmann
        self.vpm = vpm
        self.rgbm = rgbm
    }

    enum CodingKeys: String, CodingKey {
        case buehlmann
        case vpm
        case rgbm
    }
}

// MARK: - Buehlmann

/// Bühlmann decompression model parameters
///
/// The Bühlmann algorithm models dissolved gas uptake and elimination
/// in multiple tissue compartments with different half-times.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/buehlmann.html
public struct Buehlmann: Codable, Equatable, Sendable {
    /// Unique identifier for this parameter set
    public var id: String

    /// Tissue compartment parameters
    public var tissue: [Tissue]?

    /// Low gradient factor (GF Lo)
    ///
    /// Used to limit supersaturation at depth. Values typically 0.0-1.0.
    public var gradientfactorlow: Double?

    /// High gradient factor (GF Hi)
    ///
    /// Used to limit supersaturation at the surface. Values typically 0.0-1.0.
    public var gradientfactorhigh: Double?

    public init(
        id: String,
        tissue: [Tissue]? = nil,
        gradientfactorlow: Double? = nil,
        gradientfactorhigh: Double? = nil
    ) {
        self.id = id
        self.tissue = tissue
        self.gradientfactorlow = gradientfactorlow
        self.gradientfactorhigh = gradientfactorhigh
    }

    enum CodingKeys: String, CodingKey {
        case id
        case tissue
        case gradientfactorlow
        case gradientfactorhigh
    }
}

extension Buehlmann: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}

// MARK: - VPM

/// VPM (Varying Permeability Model) parameters
///
/// Based on research by Yount and Hoffman (1986), this model tracks
/// bubble formation and growth during decompression.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/vpm.html
public struct VPM: Codable, Equatable, Sendable {
    /// Unique identifier for this parameter set
    public var id: String

    /// Conservatism factor
    public var conservatism: Double?

    /// Gamma coefficient
    public var gamma: Double?

    /// Gc parameter
    public var gc: Double?

    /// Lambda parameter (tissue loading rate)
    public var lambda: Double?

    /// R0 parameter (initial bubble radius)
    public var r0: Double?

    /// Tissue compartment parameters
    public var tissue: [Tissue]?

    public init(
        id: String,
        conservatism: Double? = nil,
        gamma: Double? = nil,
        gc: Double? = nil,
        lambda: Double? = nil,
        r0: Double? = nil,
        tissue: [Tissue]? = nil
    ) {
        self.id = id
        self.conservatism = conservatism
        self.gamma = gamma
        self.gc = gc
        self.lambda = lambda
        self.r0 = r0
        self.tissue = tissue
    }

    enum CodingKeys: String, CodingKey {
        case id
        case conservatism
        case gamma
        case gc
        case lambda
        case r0
        case tissue
    }
}

extension VPM: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}

// MARK: - RGBM

/// RGBM (Reduced Gradient Bubble Model) parameters
///
/// Note: RGBM is a proprietary model and its complete parameters
/// are not fully documented. Support is experimental.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/rgbm.html
public struct RGBM: Codable, Equatable, Sendable {
    /// Unique identifier for this parameter set
    public var id: String

    /// Tissue compartment parameters
    public var tissue: [Tissue]?

    public init(
        id: String,
        tissue: [Tissue]? = nil
    ) {
        self.id = id
        self.tissue = tissue
    }

    enum CodingKeys: String, CodingKey {
        case id
        case tissue
    }
}

extension RGBM: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key as? CodingKeys {
        case .id: return .attribute
        default: return .element
        }
    }
}

// MARK: - Tissue

/// Tissue compartment parameters for decompression models
///
/// Defines gas absorption characteristics for a single tissue compartment.
/// All attributes are compulsory per the UDDF specification.
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/tissue.html
public struct Tissue: Codable, Equatable, Sendable {
    /// Gas type (n2, he, or h2)
    public var gas: TissueGas

    /// Tissue compartment number
    public var number: Int

    /// Tissue half-life
    ///
    /// - Unit: seconds (SI)
    public var halflife: Double

    /// Bühlmann 'a' coefficient
    public var a: Double

    /// Bühlmann 'b' coefficient
    public var b: Double

    public init(
        gas: TissueGas,
        number: Int,
        halflife: Double,
        a: Double,
        b: Double
    ) {
        self.gas = gas
        self.number = number
        self.halflife = halflife
        self.a = a
        self.b = b
    }

    enum CodingKeys: String, CodingKey {
        case gas
        case number
        case halflife
        case a
        case b
    }
}

extension Tissue: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        // All tissue properties are attributes
        return .attribute
    }
}

// MARK: - TissueGas

/// Gas types for tissue compartment calculations
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/tissue.html
public enum TissueGas: Equatable, Sendable {
    /// Nitrogen
    case n2
    /// Helium
    case he
    /// Hydrogen
    case h2
    /// Unknown or non-standard gas type
    case unknown(String)

    public var rawValue: String {
        switch self {
        case .n2: return "n2"
        case .he: return "he"
        case .h2: return "h2"
        case .unknown(let value): return value
        }
    }

    public init(rawValue: String) {
        switch rawValue.lowercased() {
        case "n2": self = .n2
        case "he": self = .he
        case "h2": self = .h2
        default: self = .unknown(rawValue)
        }
    }

    /// Whether this is a standard UDDF tissue gas value
    public var isStandard: Bool {
        if case .unknown = self {
            return false
        }
        return true
    }
}

extension TissueGas: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(rawValue: value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
