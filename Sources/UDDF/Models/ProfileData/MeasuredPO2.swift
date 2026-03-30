import Foundation
import XMLCoder

/// Measured partial pressure of oxygen reading for a single sensor.
public struct MeasuredPO2: Codable, Equatable, Sendable {
    /// Optional reference to an oxygen sensor definition.
    @Attribute public var ref: String?

    /// Measured partial pressure of oxygen in pascals.
    public var pascals: Double

    public init(pressure: Pressure, ref: String? = nil) {
        self._ref = Attribute(ref)
        self.pascals = pressure.pascals
    }

    public init(pascals: Double, ref: String? = nil) {
        self._ref = Attribute(ref)
        self.pascals = pascals
    }

    public init(bar: Double, ref: String? = nil) {
        self.init(pascals: Pressure(bar: bar).pascals, ref: ref)
    }

    public var bar: Double {
        pressure.bar
    }

    public var pressure: Pressure {
        get { Pressure(pascals: pascals) }
        set { pascals = newValue.pascals }
    }

    enum CodingKeys: String, CodingKey {
        case ref
        case pascals = ""
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _ref = try container.decodeIfPresent(Attribute<String?>.self, forKey: .ref) ?? Attribute(nil)
        pascals = try container.decodeTrimmedIntrinsicValue(forKey: .pascals)
    }
}
