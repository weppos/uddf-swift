import Foundation
import XMLCoder

/// Price with currency attribute
///
/// Reference: https://www.streit.cc/extern/uddf_v321/en/price.html
public struct Price: Codable, Equatable, Sendable {
    /// Currency code (e.g., "EUR", "USD")
    @Attribute public var currency: String?

    /// Price value
    public var value: Double

    public init(value: Double, currency: String? = nil) {
        self.value = value
        self._currency = Attribute(currency)
    }

    enum CodingKeys: String, CodingKey {
        case currency
        case value = ""
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _currency = try container.decodeIfPresent(Attribute<String?>.self, forKey: .currency) ?? Attribute(nil)
        value = try container.decodeTrimmedIntrinsicValue(forKey: .value)
    }
}
