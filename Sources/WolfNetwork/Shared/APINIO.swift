//
//  APINIO.swift
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

extension API {
    public func callNIO<T: Decodable, Body: Encodable>(
        returning returnType: T.Type,
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        body: Body,
        session: URLSession?,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> Future<T> {
        do {
            let request = try self.newRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth, body: body)
            let futureData = HTTPNIO.retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
            futureData.whenFailure { error in
                self.handle(error: error)
            }
            return futureData.flatMapThrowing { (_, data) in
                return try JSONDecoder().decode(returnType, from: data)
            }
        } catch {
            return MainEventLoop.shared.future(error: error)
        }
    }

    public func callNIO<T: Decodable>(
        returning returnType: T.Type,
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        session: URLSession?,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> Future<T> {
        do {
            let request = try self.newRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth)
            let futureData = HTTPNIO.retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
            futureData.whenFailure { error in
                self.handle(error: error)
            }
            return futureData.flatMapThrowing { (_, data) in
                return try JSONDecoder().decode(returnType, from: data)
            }
        } catch {
            return MainEventLoop.shared.future(error: error)
        }
    }

    public func callNIO<Body: Encodable>(
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        isAuth: Bool = false,
        body: Body,
        session: URLSession?,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> Future<Void> {
        do {
            let request = try self.newRequest(method: method, scheme: scheme, path: path, isAuth: isAuth, body: body)
            let future = HTTPNIO.retrieve(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
            future.whenFailure { error in
                self.handle(error: error)
            }
            return future
        } catch {
            return MainEventLoop.shared.future(error: error)
        }
    }

    public func callNIO(
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        isAuth: Bool = false,
        session: URLSession?,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> Future<Void> {
        do {
            let request = try self.newRequest(method: method, scheme: scheme, path: path, isAuth: isAuth)
            let future = HTTPNIO.retrieve(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
            future.whenFailure { error in
                self.handle(error: error)
            }
            return future
        } catch {
            return MainEventLoop.shared.future(error: error)
        }
    }
}
