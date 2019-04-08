//
//  Authorization.swift
//  WolfNetwork
//
//  Created by Wolf McNally on 3/3/17.
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
import WolfSec

public protocol AuthorizationProtocol: Codable {
    // Implemented by conforming types.
    static var currentVersion: Int { get }
    static var keychainIdentifier: String { get }
    var savedVersion: Int { get }
    var authorizationToken: String { get set }

    // Implemented in extension below.
    func save()
    static func load() -> Self?
    static func delete()
}

extension AuthorizationProtocol {
    public func save() {
        try! KeyChain.updateObject(self, for: Self.keychainIdentifier)
    }

    public static func load() -> Self? {
        return try! KeyChain.object(Self.self, for: Self.keychainIdentifier)
    }

    public static func delete() {
        do {
            try KeyChain.delete(key: keychainIdentifier)
        } catch {
            // Do nothing
        }
    }
}

public struct Authorization: AuthorizationProtocol {
    public static let currentVersion = 1
    public static let keychainIdentifier = "authorization"
    public var savedVersion = 1
    public var authorizationToken: String
    public var credentials: Credentials

    public var id: String {
        return credentials.id
    }
}

public struct APIKey: AuthorizationProtocol {
    public static var currentVersion: Int = 1
    public static var keychainIdentifier: String { fatalError("not implemented") }
    public var savedVersion: Int = 1
    public var authorizationToken: String

    public init(authorizationToken: String) {
        self.authorizationToken = authorizationToken
    }

    public func save() { }
    public static func load() -> APIKey? { return nil }
    public static func delete() { }
}
