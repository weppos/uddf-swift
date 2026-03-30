import Foundation

extension KeyedDecodingContainer {
    func decodeTrimmedIntrinsicValue<T: LosslessStringConvertible & Decodable>(
        forKey key: Key
    ) throws -> T {
        if let value = try? decode(T.self, forKey: key) {
            return value
        }

        let normalized: String
        if let fragments = try? decode([String].self, forKey: key) {
            normalized = fragments.joined()
        } else {
            normalized = try decode(String.self, forKey: key)
        }

        let trimmed = normalized.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = T(trimmed) else {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "Expected intrinsic \(T.self) content after trimming formatting whitespace"
            )
        }

        return value
    }
}
