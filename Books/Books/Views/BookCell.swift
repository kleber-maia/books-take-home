import Foundation
import UIKit

/// Presents relevant information for a Book.
class BookCell: UITableViewCell {
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!

    /// Configure the cell with the given information.
    func configure(title: String, author: String, isbn: String) {
        self.coverImageView.image = UIImage(named: "book-cover-placeholder")
        self.titleLabel.text = title
        self.authorLabel.text = author

        BookCoverAPIService().fetch(isbn: isbn) { [weak self] result in
            guard let self = self else { return }

            if case .success(let image) = result, image.size.width > 100 {
                DispatchQueue.main.async {
                    self.coverImageView.image = image
                }
            }
        }
    }
}
