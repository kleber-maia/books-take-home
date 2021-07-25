import Foundation
import UIKit

/// Presents relevant information for when the search result is too large.
class TooManyResultsCell: UITableViewCell {
    @IBOutlet var messageLabel: UILabel!

    /// Configure the cell with the given information.
    func configure(resultsFound: Int) {
        messageLabel.text = String(
            format: "%d results found, please refine your search.",
            locale: Locale.current,
            resultsFound
        )
    }
}
