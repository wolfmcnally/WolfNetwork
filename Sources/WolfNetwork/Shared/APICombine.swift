//
//  APICombine.swift
//  
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

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension API {
    public func makeRequest(
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false
    ) -> Future<URLRequest, Error> {
        Future { promise in
            do {
                let req = try self.newRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth)
                promise(.success(req))
            } catch {
                promise(Result.failure(error))
            }
        }
    }

    public func makeRequest(
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        body: Data
    ) -> Future<URLRequest, Error> {
        Future { promise in
            do {
                let req = try self.newRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth, body: body)
                promise(.success(req))
            } catch {
                promise(Result.failure(error))
            }
        }
    }

    public func makeRequest(
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        body: String
    ) -> Future<URLRequest, Error> {
        Future { promise in
            do {
                let req = try self.newRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth, body: body)
                promise(.success(req))
            } catch {
                promise(Result.failure(error))
            }
        }
    }

    public func makeRequest<Body: Encodable>(
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        body: Body
    ) -> Future<URLRequest, Error> {
        Future { promise in
            do {
                let req = try self.newRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth, body: body)
                promise(.success(req))
            } catch {
                promise(Result.failure(error))
            }
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension API {
    public func call(
        returning returnType: T.Type,
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        session: URLSession? = nil,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> AnyPublisher<Data, Error> {
        makeRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth).flatMap { request in
            HTTPCombine.retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
                .map { $0.data }
        }
        .eraseToAnyPublisher()
    }

    public func call<T: Decodable>(
        returning returnType: T.Type,
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        session: URLSession? = nil,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> AnyPublisher<T, Error> {
        makeRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth).flatMap { request in
            HTTPCombine.retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
                .map { $0.data }
                .decode(type: T.self, decoder: JSONDecoder())
        }
        .eraseToAnyPublisher()
    }

    public func call(
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        body: Data,
        session: URLSession? = nil,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> AnyPublisher<Data, Error> {
        makeRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth, body: body).flatMap { request in
            HTTPCombine.retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
                .map { $0.data }
        }
        .eraseToAnyPublisher()
    }

    public func call<T: Decodable>(
        returning returnType: T.Type,
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        body: Data,
        session: URLSession? = nil,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> AnyPublisher<T, Error> {
        makeRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth, body: body).flatMap { request in
            HTTPCombine.retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
                .map { $0.data }
                .decode(type: T.self, decoder: JSONDecoder())
        }
        .eraseToAnyPublisher()
    }

    public func call(
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        body: String,
        session: URLSession? = nil,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> AnyPublisher<Data, Error> {
        makeRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth, body: body).flatMap { request in
            HTTPCombine.retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
                .map { $0.data }
        }
        .eraseToAnyPublisher()
    }

    public func call<T: Decodable>(
        returning returnType: T.Type,
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        body: String,
        session: URLSession? = nil,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> AnyPublisher<T, Error> {
        makeRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth, body: body).flatMap { request in
            HTTPCombine.retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
                .map { $0.data }
                .decode(type: T.self, decoder: JSONDecoder())
        }
        .eraseToAnyPublisher()
    }

    public func call<Body: Encodable>(
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        body: Body,
        session: URLSession? = nil,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> AnyPublisher<Data, Error> {
        makeRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth, body: body).flatMap { request in
            HTTPCombine.retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
                .map { $0.data }
        }
        .eraseToAnyPublisher()
    }

    public func call<T: Decodable, Body: Encodable>(
        returning returnType: T.Type,
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        body: Body,
        session: URLSession? = nil,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> AnyPublisher<T, Error> {
        makeRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth, body: body).flatMap { request in
            HTTPCombine.retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
                .map { $0.data }
                .decode(type: T.self, decoder: JSONDecoder())
        }
        .eraseToAnyPublisher()
    }

    public func call(
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        session: URLSession? = nil,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> AnyPublisher<Void, Error> {
        makeRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth).flatMap { request in
            HTTPCombine.retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
                .map { _ in }
        }
        .eraseToAnyPublisher()
    }

    public func call<Body: Encodable>(
        method: HTTPMethod,
        scheme: HTTPScheme? = nil,
        path: [Any]? = nil,
        query: KeyValuePairs<String, String>? = nil,
        isAuth: Bool = false,
        body: Body,
        session: URLSession? = nil,
        successStatusCodes: [StatusCode] = [.ok],
        expectedFailureStatusCodes: [StatusCode] = [],
        mock: Mock? = nil
    ) -> AnyPublisher<Void, Error> {
        makeRequest(method: method, scheme: scheme, path: path, query: query, isAuth: isAuth, body: body).flatMap { request in
            HTTPCombine.retrieveData(with: request, session: session, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock)
                .map { _ in }
        }
        .eraseToAnyPublisher()
    }
}
#endif
