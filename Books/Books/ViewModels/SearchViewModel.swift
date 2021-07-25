import Foundation

/// Implements the ViewModel counterpart of book search interface.
class SearchViewModel {
    /// Delegate to be notified upon data events.
    weak var delegate: SearchViewModelDelegate?

    /// Returns the number of books returned in the search result.
    var count: Int {
        searchResult?.docs?.count ?? 0
    }
    /// Returns the total number of books found on the search.
    var found: Int {
        searchResult?.numFound ?? 0
    }
    /// Contains a localized error message when search failed.
    private(set) var errorMessage: String?

    private var bookAPI: BookAPIService
    private var searchResult: SearchResultModel?

    init(
        delegate: SearchViewModelDelegate, bookAPI: BookAPIService = BookAPIService()
    ) {
        self.bookAPI = bookAPI
        self.delegate = delegate
    }

    /// Performs a book search and invokes delegate's `didLoadModel()` on completion.
    /// - Parameter keywords: search keywords.
    func search(using keywords: String) {
        delegate?.willLoadModel()

        self.errorMessage = nil
        self.searchResult = nil

        bookAPI.fetch(keywords: keywords) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let searchResultModel):
                self.searchResult = searchResultModel

                DispatchQueue.main.async {
                    self.delegate?.didLoadModel()
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                
                DispatchQueue.main.async {
                    self.delegate?.didEncounterError()
                }
            }
        }
    }

    /// Returns a book author in the search result.
    func author(_ index: Int) -> String? {
        guard let docs = searchResult?.docs, docs.count > index else { return nil }

        return docs[index].authorName?.first
    }

    /// Returns a book ISBN in the search result.
    func isbn(_ index: Int) -> String? {
        guard let docs = searchResult?.docs, docs.count > index else { return nil }

        return docs[index].isbn?.first
    }

    /// Returns a book title in the search result.
    func title(_ index: Int) -> String? {
        guard let docs = searchResult?.docs, docs.count > index else { return nil }

        return docs[index].title
    }
}
