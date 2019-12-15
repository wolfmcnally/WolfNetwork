//
//  HTTPCombine.swift
//  
//  Created by Wolf McNally on 11/26/19.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#if canImport(Combine)
import Foundation
import Combine
import WolfConcurrency

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
public class HTTPCombine {
    public static func retrieveData(with request: URLRequest, session: URLSession? = nil, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil) -> Future<(response: HTTPURLResponse, data: Data), Error> {

        func onComplete(promise: (Result<(response: HTTPURLResponse, data: Data), Error>) -> Void, error: Error?, response: URLResponse?, data: Data?) {
            if let error = error {
                promise(.failure(error))
                return
            }

            let httpResponse = response as! HTTPURLResponse

            guard let data = data else {
                let error = HTTPError(request: request, response: httpResponse)
                promise(.failure(error))
                return
            }

            guard let statusCode = StatusCode(rawValue: httpResponse.statusCode) else {
                let error = HTTPError(request: request, response: httpResponse, data: data)
                promise(.failure(error))
                return
            }

            guard successStatusCodes.contains(statusCode) else {
                let error = HTTPError(request: request, response: httpResponse, data: data)
                promise(.failure(error))
                return
            }

            promise(.success((httpResponse, data)))
        }

        func perform(promise: @escaping (Result<(response: HTTPURLResponse, data: Data), Error>) -> Void) {
            let sessionActions = HTTPActions()

            sessionActions.didReceiveResponse = { (sessionActions, session, dataTask, response, completionHandler) in
                completionHandler(.allow)
            }

            sessionActions.didComplete = { (sessionActions, session, task, error) in
                onComplete(promise: promise, error: error, response: sessionActions.response, data: sessionActions.data)
            }

            let mySession = session ?? URLSession.shared
            let config = mySession.configuration.copy() as! URLSessionConfiguration
            let session = URLSession(configuration: config, delegate: sessionActions, delegateQueue: nil)
            let task = session.dataTask(with: request)
            task.resume()
        }

        func mockPerform(promise: @escaping (Result<(response: HTTPURLResponse, data: Data), Error>) -> Void, mock: Mock) {
            dispatchOnBackground(afterDelay: mock.delay) {
                let response = HTTPURLResponse(url: request.url!, statusCode: mock.statusCode.rawValue, httpVersion: nil, headerFields: nil)!
                var error: Error?
                if !successStatusCodes.contains(mock.statusCode) {
                    error = HTTPError(request: request, response: response)
                }
                onComplete(promise: promise, error: error, response: response, data: mock.data)
            }
        }

        return Future { promise in
            if let mock = mock {
                mockPerform(promise: promise, mock: mock)
            } else {
                perform(promise: promise)
            }
        }
    }
}
#endif
