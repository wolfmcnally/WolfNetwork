//
//  URLComponentsExtensions.swift
//  WolfNetwork
//
//  Created by Wolf McNally on 11/23/16.
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
import WolfStrings

extension URLComponents {
    public var queryDictionary: [String: String] {
        get {
            var dict = [String: String]()
            guard let queryItems = queryItems else { return dict }
            for item in queryItems {
                if let value = item.value {
                    dict[item.name] = value
                }
            }
            return dict
        }

        set {
            let queryItems: [URLQueryItem] = newValue.map {
                return URLQueryItem(name: $0.0, value: $0.1)
            }
            self.queryItems = queryItems
        }
    }

    public static func parametersDictionary(from string: String?) -> [String: String] {
        var dict = [String: String]()
        guard let string = string else { return dict }
        let items = string.components(separatedBy: "&")
        for item in items {
            let parts = item.components(separatedBy: "=")
            assert(parts.count == 2)
            dict[parts[0]] = parts[1]
        }
        return dict
    }
}

extension URLComponents {
    public init(scheme: HTTPScheme, host: String, basePath: String? = nil, pathComponents: [Any]? = nil, query: [String: String]? = nil) {
        self.init()

        self.scheme = scheme.rawValue

        self.host = host

        let joiner = Joiner(left: "/", separator: "/")
        if let basePath = basePath {
            joiner.append(basePath)
        }
        if let pathComponents = pathComponents {
            joiner.append(contentsOf: pathComponents)
        }
        self.path = joiner.description

        if let query = query {
            queryDictionary = query
        }
    }
}
