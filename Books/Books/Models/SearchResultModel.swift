import Foundation

struct SearchResultModel: Codable {
    let numFound: Int?
    let start: Int?
    let numFoundExact: Bool?
    let docs: [SearchItemModel]?

    /// Initializes de model from the provided `jsonData`.
    /// - Throws: DecodingError in case the data is invalid and may not be decoded.
    init(jsonData: Data) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let decoded = try decoder.decode(SearchResultModel.self, from: jsonData)

        self = decoded
    }
}
