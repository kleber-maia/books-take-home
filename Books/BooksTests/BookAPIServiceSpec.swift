@testable import Books
import Cuckoo
import Foundation
import OHHTTPStubs
import OHHTTPStubsSwift
import Nimble
import Quick

class BookAPIServiceSpec: QuickSpec {
    override func spec() {
        afterEach {
            HTTPStubs.removeAllStubs()
        }

        describe("fetch") {
            context("when request succeeds") {
                it("should return the expected result") {
                    stub(condition: isHost("openlibrary.org")) { request in
                        expect(request.url!.query!).to(contain("q=some%20book%20title"))

                        return .init(
                            fileAtPath: OHPathForFile("search_result.json", BookAPIServiceSpec.self)!,
                            statusCode: 200,
                            headers: nil
                        )
                    }

                    let service = BookAPIService()

                    waitUntil(timeout: .milliseconds(500)) { done in
                        service.fetch(keywords: "some book title") { result in
                            expect(try! result.get()).toNot(throwError())
                            done()
                        }
                    }
                }
            }

            context("when invalid keywords are passed") {
                it("should return an error") {
                    let mock = MockErrorLogging()
                    stub(mock) { stub in
                        stub.logHTTP(error: any(), request: any(), response: any()).thenDoNothing()
                    }

                    let service = BookAPIService()
                    service.errorLogger = mock

                    waitUntil(timeout: .milliseconds(500)) { done in
                        let invalidKeyword = String(
                            bytes: [0xD8, 0x00] as [UInt8], encoding: String.Encoding.utf16BigEndian
                        )!
                        service.fetch(keywords: invalidKeyword) { result in
                            do {
                                let expected = BookAPIService.ServiceError.invalidKeywords(invalidKeyword)
                                expect(try result.get()).to(throwError(expected))

                                done()
                            } catch { /* XXX: ignore Xcode warning */ }
                        }
                    }
                }
            }

            context("when there's a server error") {
                it("should return and log an HTTP error") {
                    stub(condition: isHost("openlibrary.org")) { _ in
                        .init(data: Data(), statusCode: 500, headers: nil)
                    }

                    let mock = MockErrorLogging()
                    stub(mock) { stub in
                        stub.logHTTP(error: any(), request: any(), response: any()).thenDoNothing()
                    }

                    let service = BookAPIService()
                    service.errorLogger = mock

                    waitUntil(timeout: .milliseconds(500)) { done in
                        service.fetch(keywords: "") { result in
                            do {
                                let expected = BookAPIService.ServiceError.requestError(nil)
                                expect(try result.get()).to(throwError(expected))

                                verify(mock).logHTTP(error: any(), request: any(), response: any())

                                done()
                            } catch { /* XXX: ignore Xcode warning */ }
                        }
                    }
                }
            }

            context("when there's a local connection error") {
                it("should return and log a non fatal error") {
                    stub(condition: isHost("openlibrary.org")) { _ in
                        .init(error: NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue))
                    }

                    let mock = MockErrorLogging()
                    stub(mock) { stub in
                        stub.logNonFatal(error: any()).thenDoNothing()
                    }

                    let service = BookAPIService()
                    service.errorLogger = mock

                    waitUntil(timeout: .milliseconds(500)) { done in
                        service.fetch(keywords: "") { result in
                            do {
                                let expected = BookAPIService.ServiceError.requestError(nil)
                                expect(try result.get()).to(throwError(expected))

                                verify(mock).logNonFatal(error: any())

                                done()
                            } catch { /* XXX: ignore Xcode warning */ }
                        }
                    }
                }
            }

            context("when invalid data is returned") {
                it("should return and log a non fatal error") {
                    stub(condition: isHost("openlibrary.org")) { _ in
                        .init(data: Data(), statusCode: 200, headers: nil)
                    }

                    let mock = MockErrorLogging()
                    stub(mock) { stub in
                        stub.logNonFatal(error: any()).thenDoNothing()
                    }

                    let service = BookAPIService()
                    service.errorLogger = mock

                    waitUntil(timeout: .milliseconds(500)) { done in
                        service.fetch(keywords: "") { result in
                            do {
                                let expected = BookAPIService.ServiceError.invalidData(nil)
                                expect(try result.get()).to(throwError(expected))

                                verify(mock).logNonFatal(error: any())

                                done()
                            } catch { /* XXX: ignore Xcode warning */ }
                        }
                    }
                }
            }
        }
    }
}
