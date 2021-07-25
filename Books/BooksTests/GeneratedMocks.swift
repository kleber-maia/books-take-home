// MARK: - Mocks generated from file: Books/Helpers/ErrorLogging.swift at 2021-07-25 18:37:44 +0000


import Cuckoo
@testable import Books

import Foundation


 class MockErrorLogging: ErrorLogging, Cuckoo.ProtocolMock {
    
     typealias MocksType = ErrorLogging
    
     typealias Stubbing = __StubbingProxy_ErrorLogging
     typealias Verification = __VerificationProxy_ErrorLogging

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ErrorLogging?

     func enableDefaultImplementation(_ stub: ErrorLogging) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func logNonFatal(error: Error)  {
        
    return cuckoo_manager.call("logNonFatal(error: Error)",
            parameters: (error),
            escapingParameters: (error),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.logNonFatal(error: error))
        
    }
    
    
    
     func logHTTP(error: Error?, request: URLRequest, response: HTTPURLResponse)  {
        
    return cuckoo_manager.call("logHTTP(error: Error?, request: URLRequest, response: HTTPURLResponse)",
            parameters: (error, request, response),
            escapingParameters: (error, request, response),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.logHTTP(error: error, request: request, response: response))
        
    }
    

	 struct __StubbingProxy_ErrorLogging: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func logNonFatal<M1: Cuckoo.Matchable>(error: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Error)> where M1.MatchedType == Error {
	        let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: error) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockErrorLogging.self, method: "logNonFatal(error: Error)", parameterMatchers: matchers))
	    }
	    
	    func logHTTP<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(error: M1, request: M2, response: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(Error?, URLRequest, HTTPURLResponse)> where M1.OptionalMatchedType == Error, M2.MatchedType == URLRequest, M3.MatchedType == HTTPURLResponse {
	        let matchers: [Cuckoo.ParameterMatcher<(Error?, URLRequest, HTTPURLResponse)>] = [wrap(matchable: error) { $0.0 }, wrap(matchable: request) { $0.1 }, wrap(matchable: response) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockErrorLogging.self, method: "logHTTP(error: Error?, request: URLRequest, response: HTTPURLResponse)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_ErrorLogging: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func logNonFatal<M1: Cuckoo.Matchable>(error: M1) -> Cuckoo.__DoNotUse<(Error), Void> where M1.MatchedType == Error {
	        let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: error) { $0 }]
	        return cuckoo_manager.verify("logNonFatal(error: Error)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func logHTTP<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(error: M1, request: M2, response: M3) -> Cuckoo.__DoNotUse<(Error?, URLRequest, HTTPURLResponse), Void> where M1.OptionalMatchedType == Error, M2.MatchedType == URLRequest, M3.MatchedType == HTTPURLResponse {
	        let matchers: [Cuckoo.ParameterMatcher<(Error?, URLRequest, HTTPURLResponse)>] = [wrap(matchable: error) { $0.0 }, wrap(matchable: request) { $0.1 }, wrap(matchable: response) { $0.2 }]
	        return cuckoo_manager.verify("logHTTP(error: Error?, request: URLRequest, response: HTTPURLResponse)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class ErrorLoggingStub: ErrorLogging {
    

    

    
     func logNonFatal(error: Error)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func logHTTP(error: Error?, request: URLRequest, response: HTTPURLResponse)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

