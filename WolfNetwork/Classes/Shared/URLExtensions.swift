//
//  URLExtensions.swift
//  WolfNetwork
//
//  Created by Wolf McNally on 6/15/16.
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

extension URL {
    public static func retrieveData(from url: URL) throws -> Data {
        return try Data(contentsOf: url)
    }
}

extension URL {
    public init(scheme: HTTPScheme, host: String, basePath: String? = nil, pathComponents: [Any]? = nil, query: [String: String]? = nil) {
        let comps = URLComponents(scheme: scheme, host: host, basePath: basePath, pathComponents: pathComponents, query: query)
        self.init(string: comps.string!)!
    }
}

extension URL {
    public func convertedToHTTPS() -> URL {
        var comps = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        comps.scheme = HTTPScheme.https.rawValue
        return comps.url!
    }
}

extension String {
    public static func url(from string: String) throws -> URL {
        guard let url = URL(string: string) else {
            throw WolfNetworkError("Could not parse url from string: \(string)")
        }
        return url
    }
}
