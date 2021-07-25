import Foundation
import UIKit

/// Concrete interface for accessing Books Covers REST API.
///
/// Leverages NSCache for maintaining an in-memory image cache for saving network resources and best user experience.
class BookCoverAPIService {
    enum ServiceError: Error {
        case invalidData(Data?)
        case invalidUrl
        case requestError(Error?)
    }

    typealias Completion = (Result<UIImage, Error>) -> Void

    static private let imageCache = NSCache<AnyObject, UIImage>()

    var errorLogger: ErrorLogging = ErrorLogger.shared

    private let urlFormat = "https://covers.openlibrary.org/b/isbn/%@-L.jpg"

    /// Fetches the book cover and invokes `completion` passing either a failure with an error or its image.
    /// In case of an error, a non fatal error will be logged.
    /// - Parameters:
    ///   - isbn: book's ISBN.
    ///   - completion: closure to receive the fetched result.
    func fetch(isbn: String, completion: @escaping Completion) {
        guard let url = URL(string: String(format: urlFormat, isbn)) else {
            completion(.failure(ServiceError.invalidUrl))
            return
        }

        // retrieves image if already available in cache
        if let imageFromCache = Self.imageCache.object(forKey: url as AnyObject) {
            completion(.success(imageFromCache))
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

            if let data = data, let result = UIImage(data: data) {
                Self.imageCache.setObject(result, forKey: url as AnyObject)

                completion(.success(result))
            } else {
                completion(.failure(ServiceError.invalidData(data)))
            }
        }.resume()
    }
}
