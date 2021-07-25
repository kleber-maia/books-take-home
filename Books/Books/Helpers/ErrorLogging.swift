import Foundation

protocol ErrorLogging {
    func logNonFatal(error: Error)

    func logHTTP(error: Error?, request: URLRequest, response: HTTPURLResponse)
}
