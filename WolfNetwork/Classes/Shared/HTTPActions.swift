//
//  HTTPActions.swift
//  WolfNetwork
//
//  Created by Wolf McNally on 11/21/16.
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

public class HTTPActions: NSObject, URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
  public var response: URLResponse?
  public var data: Data?
  public var error: Error?

  // MARK: - Callback Closures

  public var didBecomeInvalid: ((HTTPActions, URLSession, Error?) -> Void)?

  public var didReceiveChallenge: ((HTTPActions, URLSession, URLAuthenticationChallenge, _ completion: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?

  public var didReceiveResponse: ((HTTPActions, URLSession, URLSessionDataTask, URLResponse, _ completion: (URLSession.ResponseDisposition) -> Void) -> Void)?

  public var didBecomeDownloadTask: ((HTTPActions, URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?

//  public var didBecomeStreamTask: ((HTTPActions, URLSession, URLSessionDataTask, URLSessionStreamTask) -> Void)?

  public var didReceiveData: ((HTTPActions, URLSession, URLSessionDataTask, Data) -> Void)?

  public var willCacheResponse: ((HTTPActions, URLSession, URLSessionDataTask, _ proposedResponse: CachedURLResponse, _ completion: (CachedURLResponse?) -> Void) -> Void)?

  public var needNewBodyStream: ((HTTPActions, URLSession, URLSessionTask, _ completion: (InputStream?) -> Void) -> Void)?

  public var didComplete: ((HTTPActions, URLSession, URLSessionTask, Error?) -> Void)?

  public var didSendBodyData: ((HTTPActions, URLSession, URLSessionTask, _ bytesSent: Int64, _ totalBytesSent: Int64, _ totalBytesExpectedToSend: Int64) -> Void)?

  // MARK: - Delegate Functions

  public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
    self.error = error
    didBecomeInvalid?(self, session, error)
  }

  public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    didReceiveChallenge?(self, session, challenge, completionHandler)
  }

  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
    didBecomeDownloadTask?(self, session, dataTask, downloadTask)
  }

//  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
//    didBecomeStreamTask?(self, session, dataTask, streamTask)
//  }

  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    self.response = response
    didReceiveResponse?(self, session, dataTask, response, completionHandler)
  }

  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive newData: Data) {
    data?.append(newData)
    didReceiveData?(self, session, dataTask, newData)
  }

  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
    willCacheResponse?(self, session, dataTask, proposedResponse, completionHandler)
  }

  public func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
    needNewBodyStream?(self, session, task, completionHandler)
  }

  public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    self.error = error
    session.finishTasksAndInvalidate()
    didComplete?(self, session, task, error)
  }

  public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
    didSendBodyData?(self, session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
  }

  public init(keepData: Bool = true) {
    super.init()
    if keepData {
      data = Data()
    }
    didReceiveResponse = { (actions, session, dataTask, response, completionHandler) in
      completionHandler(.allow)
    }
    didReceiveChallenge = { (actions, session, challenge, completionHandler) in
      completionHandler(.useCredential, challenge.proposedCredential)
    }
    willCacheResponse = { (actions, session, dataTask, proposedResponse, completionHandler) in
      completionHandler(proposedResponse)
    }
  }

  public override convenience init() {
    self.init(keepData: true)
  }
}
