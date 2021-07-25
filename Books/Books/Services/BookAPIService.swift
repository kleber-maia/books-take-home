import Foundation

/// Concrete interface for accessing Books REST API.
class BookAPIService {
    enum ServiceError: Error {
        case invalidData(Data?)
        case invalidKeywords(String)
        case invalidUrl
        case requestError(Error?)
    }

    typealias Completion = (Result<SearchResultModel, Error>) -> Void

    var errorLogger: ErrorLogging = ErrorLogger.shared

    private let urlFormat = "https://openlibrary.org/search.json?q=%@&limit=%d"

    /// Fetches Books and invokes `completion` passing either a failure with an error or a
    /// list of Books.
    /// In case of an error, a non fatal error will be logged.
    /// - Parameters:
    ///   - keywords: search keywords.
    ///   - limit: maximum number of results while pagination is not yet supported.
    ///   - completion: closure to receive the fetched results.
    func fetch(keywords: String, limit: Int = 10, completion: @escaping Completion) {
        guard let encodedKeywords = keywords.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(ServiceError.invalidKeywords(keywords)))
            return
        }

        guard let url = URL(string: String(format: urlFormat, encodedKeywords, limit)) else {
            completion(.failure(ServiceError.invalidUrl))
            return
        }

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            let httpResponse = response as? HTTPURLResponse
            let statusCode = httpResponse?.statusCode ?? 0

            let succeeded = error == nil && data != nil && (200..<300).contains(statusCode)

            if !succeeded {
                if let httpResponse = httpResponse {
                    self?.errorLogger.logHTTP(error: error, request: request, response: httpResponse)
                } else if let error = error {
                    self?.errorLogger.logNonFatal(error: error)
                }

                completion(.failure(ServiceError.requestError(error)))
                return
            }

            do {
                let model = try SearchResultModel(jsonData: data ?? Data())
                completion(.success(model))
            } catch {
                self?.errorLogger.logNonFatal(error: error)
                completion(.failure(ServiceError.invalidData(data)))
            }
        }.resume()
    }
}
