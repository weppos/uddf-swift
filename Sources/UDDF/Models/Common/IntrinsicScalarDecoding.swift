import Foundation

extension KeyedDecodingContainer {
    func decodeTrimmedIntrinsicValue<T: LosslessStringConvertible & Decodable>(
        forKey key: Key
    ) throws -> T {
        if let value = try? decode(T.self, forKey: key) {
            // Numeric types reject surrounding whitespace on decode and fall
            // through to the trimming path below, but string content decodes
            // successfully with the formatting whitespace still attached. Trim it
            // here too so token-like text (e.g. a pretty-printed
            // `<alarm> deco </alarm>`) decodes to "deco" rather than " deco ",
            // matching the whitespace-insensitivity the numeric path already gets.
            if let text = value as? String,
               let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines) as? T {
                return trimmed
            }
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
