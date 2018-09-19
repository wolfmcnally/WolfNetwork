//
//  HTTPError.swift
//  WolfNetwork
//
//  Created by Wolf McNally on 7/5/15.
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
import WolfPipe
import WolfFoundation

extension Error {
    public var httpStatusCode: StatusCode? {
        guard let e = self as? HTTPError else { return nil }
        return e.statusCode
    }
}

public struct HTTPError: DescriptiveError {
    public let request: URLRequest
    public let response: HTTPURLResponse
    public let data: Data?

    public init(request: URLRequest, response: HTTPURLResponse, data: Data? = nil) {
        self.request = request
        self.response = response
        self.data = data
    }

    public var message: String {
        return HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }

    public var code: Int {
        return response.statusCode
    }

    public var statusCode: StatusCode {
        return StatusCode(rawValue: code)!
    }

    public var identifier: String {
        return "HTTPError(\(code))"
    }

//    public var json: JSON? {
//        guard let data = data else { return nil }
//        do {
//            return try data |> JSON.init
//        } catch {
//            return nil
//        }
//    }

    public var isCancelled: Bool { return false }
}

extension HTTPError: CustomStringConvertible {
    public var description: String {
        return "HTTPError(\(code) \(message))"
    }
}
