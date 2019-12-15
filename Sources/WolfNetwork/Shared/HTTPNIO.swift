//
//  HTTPNIO.swift
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

import Foundation
import WolfNIO
import WolfLog
import WolfFoundation
import WolfConcurrency

public class HTTPNIO {
    public static func retrieveData(with request: URLRequest, session: URLSession? = nil, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil) -> Future<(HTTPURLResponse, Data)> {
        func onComplete(promise: Promise<(HTTPURLResponse, Data)>, error: Error?, response: URLResponse?, data: Data?) {
            guard error == nil else {
                promise.fail(error!)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                fatalError("Improper response type: \(response†)")
            }

            guard data != nil else {
                let error = HTTPError(request: request, response: httpResponse)
                promise.fail(error)
                return
            }

            guard let statusCode = StatusCode(rawValue: httpResponse.statusCode) else {
                let error = HTTPError(request: request, response: httpResponse, data: data)
                promise.fail(error)
                return
            }

            guard successStatusCodes.contains(statusCode) else {
                let error = HTTPError(request: request, response: httpResponse, data: data)
                promise.fail(error)
                return
            }

            promise.succeed((httpResponse, data!))
        }

        func perform(promise: Promise<(HTTPURLResponse, Data)>, session: URLSession?) {
            let _sessionActions = HTTPActions()

            _sessionActions.didReceiveResponse = { (sessionActions, session, dataTask, response, completionHandler) in
                completionHandler(.allow)
            }

            _sessionActions.didComplete = { (sessionActions, session, task, error) in
                onComplete(promise: promise, error: error, response: sessionActions.response, data: sessionActions.data)
            }

            let mySession = session ?? URLSession.shared
            let config = mySession.configuration.copy() as! URLSessionConfiguration
            let session = URLSession(configuration: config, delegate: _sessionActions, delegateQueue: nil)
            let task = session.dataTask(with: request)
            task.resume()
        }

        func mockPerform(promise: Promise<(HTTPURLResponse, Data)>) {
            let mock = mock!
            dispatchOnBackground(afterDelay: mock.delay) {
                let response = HTTPURLResponse(url: request.url!, statusCode: mock.statusCode.rawValue, httpVersion: nil, headerFields: nil)!
                var error: Error?
                if !successStatusCodes.contains(mock.statusCode) {
                    error = HTTPError(request: request, response: response)
                }
                onComplete(promise: promise, error: error, response: response, data: mock.data)
            }
        }

        let promise = MainEventLoop.shared.makePromise(of: (HTTPURLResponse, Data).self)

        if mock != nil {
            mockPerform(promise: promise)
        } else {
            perform(promise: promise, session: session)
        }

        return promise.futureResult
    }

    public static func retrieve(with request: URLRequest, session: URLSession? = nil, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil) -> Future<Void> {
        return retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock).transform(to: ())
    }
}
