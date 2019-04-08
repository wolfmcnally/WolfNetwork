//
//  HTTPDebugging.swift
//  WolfNetwork
//
//  Created by Wolf McNally on 6/3/16.
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
import WolfCore

extension URLRequest {
    public func printRequest(includeAuxFields: Bool = false, level: Int = 0) {
        print("➡️ \(httpMethod†) \(url†)".indented(level))

        let level = level + 1

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                print("\(key): \(value)".indented(level))
            }
        }

        if let data = httpBody, data.count > 0 {
            print("body:".indented(level))

            let level = level + 1
//            do {
//                try print((data |> JSON.init).prettyString.indented(level))
//            } catch {
                print("Non-JSON Data: \(data)".indented(level))
//            }
        }

        guard includeAuxFields else { return }

        let cachePolicyStrings: [URLRequest.CachePolicy: String] = [
            .useProtocolCachePolicy: ".useProtocolCachePolicy",
            .reloadIgnoringLocalCacheData: ".reloadIgnoringLocalCacheData",
            .returnCacheDataElseLoad: ".returnCacheDataElseLoad",
            .returnCacheDataDontLoad: ".returnCacheDataDontLoad"
            ]
        let networkServiceTypes: [URLRequest.NetworkServiceType: String]
        if #available(iOS 10.0, *) {
            networkServiceTypes = [
                .`default`: ".default",
                .voip: ".voip",
                .video: ".video",
                .background: ".background",
                .voice: ".voice",
                .callSignaling: ".callSignaling"
            ]
        } else {
            networkServiceTypes = [
                .`default`: ".default",
                .voip: ".voip",
                .video: ".video",
                .background: ".background",
                .voice: ".voice"
            ]
        }

        print("timeoutInterval: \(timeoutInterval)".indented(level))
        print("cachePolicy: \(cachePolicyStrings[cachePolicy]!)".indented(level))
        print("allowsCellularAccess: \(allowsCellularAccess)".indented(level))
        print("httpShouldHandleCookies: \(httpShouldHandleCookies)".indented(level))
        print("httpShouldUsePipelining: \(httpShouldUsePipelining)".indented(level))
        print("mainDocumentURL: \(mainDocumentURL†)".indented(level))
        print("networkServiceType: \(networkServiceTypes[networkServiceType]!)".indented(level))
    }
}
