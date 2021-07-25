import Foundation

/// Book search interface to implement this delegate.
protocol SearchViewModelDelegate: AnyObject {
    /// Invoked when a fetch operation resulted in error.
    func didEncounterError()
    /// Invoked when a fetch operation was successfully.
    func didLoadModel()
    /// Invoked before a fetch operation has started.
    func willLoadModel()
}
