import Foundation

/// Logs runtime / nonfatal errors, providing the team a way to be aware and track service outages and other edge cases
/// not identified during development.
///
/// XXX: this class only illustrates error logging.
class ErrorLogger: ErrorLogging {
    static let shared = ErrorLogger()

    private init() {
    }

    func logNonFatal(error: Error) {
        // XXX: should log a non fatal error on Crashlytics or other service, but it's out of scope, now.
    }

    func logHTTP(error: Error?, request: URLRequest, response: HTTPURLResponse) {
        // XXX: should log a non fatal error on Crashlytics or other service, but it's out of scope, now.
    }
}
