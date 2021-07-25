import Foundation
import UIKit

/// Implements the Book search interface.
class SearchViewController: UIViewController {
    private var viewModel: SearchViewModel!
    private var spinner: UIActivityIndicatorView?
    private var hasSearched = false

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SearchViewModel(delegate: self)
    }
}

// MARK: - SearchViewModelDelegate

extension SearchViewController: SearchViewModelDelegate {
    func didEncounterError() {
        spinner?.removeFromSuperview()

        let alert = UIAlertController(
            title: "Error",
            message: viewModel.errorMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))

        present(alert, animated: true)
    }

    func didLoadModel() {
        spinner?.removeFromSuperview()

        tableView.reloadData()
    }

    func willLoadModel() {
        // visual cue for the user to wait
        let spinner = UIActivityIndicatorView(style: .large)
        self.spinner = spinner
        view.addSubview(spinner)
        spinner.center = view.center
        spinner.startAnimating()
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keywords = searchBar.text else { return }

        searchBar.resignFirstResponder()

        hasSearched = true

        viewModel.search(using: keywords)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.count > 0 || hasSearched ? "Search Results" : nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.count > 0 {
            // when too many results are found, `too many results` cell is also presented
            return viewModel.count + (viewModel.found > viewModel.count ? 1 : 0)
        } else if hasSearched {
            // when no results are found, the `no results` cell is also presented
            return 1
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String
        if viewModel.count == 0 {
            identifier = "EmptyCell"
        } else if indexPath.row == viewModel.count {
            identifier = "TooManyResultsCell"
        } else {
            identifier = "BookCell"
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        if let bookCell = cell as? BookCell {
            bookCell.configure(
                title: viewModel.title(indexPath.row) ?? "",
                author: viewModel.author(indexPath.row) ?? "",
                isbn: viewModel.isbn(indexPath.row) ?? ""
            )
        } else if let tooManyResultCell = cell  as? TooManyResultsCell {
            tooManyResultCell.configure(resultsFound: viewModel.found)
        }

        return cell
    }
}
