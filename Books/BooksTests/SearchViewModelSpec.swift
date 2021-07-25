@testable import Books
import Cuckoo
import Foundation
import Nimble
import Quick

class SearchViewModelSpec: QuickSpec {
    override func spec() {
        describe("search") {
            context("when a book search fails") {
                it("should set its errorMessage property and invoke the delegate") {
                    let mockService = MockBookAPIService()
                    stub(mockService) {
                        $0.fetch(keywords: any(), limit: any(), completion: any()).then { (_, _, completion) in
                            completion(
                                .failure(
                                    NSError(
                                        domain: "dummy_domain",
                                        code: 1,
                                        userInfo: [
                                            NSLocalizedDescriptionKey: "Some error message"
                                        ]
                                    )
                                )
                            )
                        }
                    }

                    let mockDelegate = MockSearchViewModelDelegate()
                    stub(mockDelegate) {
                        $0.willLoadModel().thenDoNothing()
                        $0.didEncounterError().thenDoNothing()
                    }

                    let viewModel = SearchViewModel(delegate: mockDelegate, bookAPI: mockService)

                    waitUntil(timeout: .milliseconds(500)) { done in
                        viewModel.search(using: "keywords")

                        expect(viewModel.errorMessage).to(equal("Some error message"))
                        expect(viewModel.count).to(equal(0))
                        expect(viewModel.found).to(equal(0))
                        expect(viewModel.author(0)).to(beNil())
                        expect(viewModel.isbn(0)).to(beNil())
                        expect(viewModel.title(0)).to(beNil())

                        verify(mockService).fetch(keywords: "keywords", limit: anyInt(), completion: anyClosure())
                        verify(mockDelegate).willLoadModel()
                        DispatchQueue.main.async {
                            verify(mockDelegate).didEncounterError()
                        }

                        done()
                    }
                }
            }

            context("when a book search succeeds") {
                it("should set its properties from the model and invoke the delegate") {
                    let mockService = MockBookAPIService()
                    stub(mockService) {
                        $0.fetch(keywords: any(), limit: any(), completion: any()).then { (_, _, completion) in
                            let url = Bundle(for: Self.self).url(forResource: "search_result", withExtension: ".json")!
                            completion(
                                .success(try! SearchResultModel(jsonData: Data(contentsOf: url)))
                            )
                        }
                    }

                    let mockDelegate = MockSearchViewModelDelegate()
                    stub(mockDelegate) {
                        $0.willLoadModel().thenDoNothing()
                        $0.didLoadModel().thenDoNothing()
                    }

                    let viewModel = SearchViewModel(delegate: mockDelegate, bookAPI: mockService)

                    waitUntil(timeout: .milliseconds(500)) { done in
                        viewModel.search(using: "keywords")

                        expect(viewModel.errorMessage).to(beNil())
                        expect(viewModel.count).to(equal(10))
                        expect(viewModel.found).to(equal(1335))
                        expect(viewModel.author(0)).to(equal("Lynch Mob"))
                        expect(viewModel.isbn(0)).to(equal("0793503124"))
                        expect(viewModel.title(0)).to(equal("Wicked Sensation"))

                        verify(mockService).fetch(keywords: "keywords", limit: anyInt(), completion: anyClosure())
                        verify(mockDelegate).willLoadModel()
                        DispatchQueue.main.async {
                            verify(mockDelegate).didLoadModel()
                        }

                        done()
                    }
                }
            }
        }
    }
}
