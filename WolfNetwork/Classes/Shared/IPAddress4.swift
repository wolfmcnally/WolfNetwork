//
//  IPAddress4.swift
//  WolfNetwork
//
//  Created by Wolf McNally on 2/1/16.
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
import WolfLog
import WolfFoundation

extension Data {
    public static func ipAddress4(from data: Data) -> String {
        assert(data.count == 4)
        var components = [String]()
        for byte in data {
            components.append(String(byte))
        }
        return components.joined(separator: ".")
    }
}

public class IPAddress4 {
    public static func data(from string: String) throws -> Data {
        let components = string.components(separatedBy: ".")
        guard components.count == 4 else {
            throw ValidationError(message: "Invalid IP address.", violation: "ipv4Format")
        }
        var data = Data()
        for component in components {
            guard let i = Int(component) else {
                throw ValidationError(message: "Invalid IP address.", violation: "ipv4Format")
            }
            guard i >= 0 && i <= 255 else {
                throw ValidationError(message: "Invalid IP address.", violation: "ipv4Format")
            }
            data.append([UInt8(i)], count: 1)
        }
        return data
    }
}

extension IPAddress4 {
    public static func test() {
        do {
            let data = Data([127, 0, 0, 1])
            let encoded = data |> Data.ipAddress4
            assert(encoded == "127.0.0.1")
            print(encoded)
            let decoded = try encoded |> IPAddress4.data
            assert(decoded == data)
            print(decoded)
        } catch let error {
            logError(error)
        }
    }
}
