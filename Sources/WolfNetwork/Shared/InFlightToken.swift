//
//  InFlightToken.swift
//  WolfNetwork
//
//  Created by Wolf McNally on 5/26/16.
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

import WolfCore
import WolfApp

public class InFlightToken: Equatable, Hashable, CustomStringConvertible {
    private static var nextID = 1
    public let id: Int
    public let name: String
    public internal(set) var result: ResultSummary?
    #if !os(Linux)
    private var networkActivityRef: LockerCause?
    #endif

    init(name: String) {
        id = InFlightToken.nextID
        InFlightToken.nextID += 1
        self.name = name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public var description: String {
        return "InFlightToken(id: \(id), name: \(name), result: \(result†))"
    }

    public var isNetworkActive: Bool = false {
        didSet {
            #if !os(Linux)
                if isNetworkActive {
                    networkActivityRef = networkActivity.newActivity()
                } else {
                    networkActivityRef = nil
                }
            #endif
        }
    }
}

public func == (lhs: InFlightToken, rhs: InFlightToken) -> Bool {
    return lhs.id == rhs.id
}
