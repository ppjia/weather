//  Copyright © 2017 rui. All rights reserved.

import Foundation

class MockDataTask: URLSessionDataTask {
    fileprivate var callback: ((MockDataTask) -> Void)?
    
    override func resume() {
        self.callback?(self)
    }
}

class MockSession: URLSession {
    var dataTaskWithRequestCalled: ((_ request: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?))?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        guard let dataTaskWithRequestCalled = self.dataTaskWithRequestCalled else {
            fatalError("The MockSession's dataTaskWithRequest method was called but the mock did not define the `dataTaskWithRequestCalled` block")
        }
        
        let task = MockDataTask()
        let (data, response, error) = dataTaskWithRequestCalled(request)
        task.callback = { task in
            completionHandler(data, response, error)
        }
        return task
    }
}
