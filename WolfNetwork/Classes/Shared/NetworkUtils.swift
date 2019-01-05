//
//  NetworkUtils.swift
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

#if canImport(Glibc)
    import Glibc
#endif

public enum IPAddressType: Int {
    case Version4 = 2 // AF_INET
    case Version6 = 10 // AF_INET6
}

public struct NetworkError: Error, CustomStringConvertible {
    public let message: String
    public let code: Int?

    public init(message: String, code: Int? = nil) {
        self.message = message
        self.code = code
    }

    public var description: String {
        var c = [message]
        if let code = code {
            c.append("[\(code)]")
        }

        return "NetworkError(\(c.joined(separator: " ")))"
    }
}

#if os(Linux)
    extension NetworkError {
        // public static func checkNotNil<T>(value: UnsafeMutablePointer<T>, message: String) throws -> UnsafeMutablePointer<T> {
        //     if value != nil {
        //         return value
        //     } else {
        //         let code = Int(ERR_get_error())
        //         throw CryptoError(message: message, code: code)
        //     }
        // }

        public static func checkCode(_ ret: Int32, message: String) throws {
            guard ret == 0 else {
                throw NetworkError(message: message, code: Int(ret))
            }
        }
    }
#endif

public class Host {
    public let hostname: String
    public let port: Int
    public private(set) var officialHostname: String!
    public private(set) var aliases = [String]()

    public init(hostname: String, port: Int = 0) {
        self.hostname = hostname
        self.port = port
    }
}

#if os(Linux)
    extension Host {
        public func resolve(for addressType: IPAddressType) throws {
            var hostent_p = UnsafeMutablePointer<hostent>.allocate(capacity: 1)
            defer { hostent_p.deallocate() }

            let buflen = 2048
            var buf_p = UnsafeMutablePointer<Int8>.allocate(capacity: buflen)
            defer { buf_p.deallocate() }

            var result_p = UnsafeMutablePointer<HostEntRef>.allocate(capacity: 1)
            defer { result_p.deallocate() }

            var errno_p = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
            defer { errno_p.deallocate() }

            try NetworkError.checkCode(
                gethostbyname2_r(
                    hostname,
                    Int32(addressType.rawValue),
                    hostent_p,
                    buf_p,
                    buflen,
                    result_p,
                    errno_p
                ),
                message: "Resolving address.")

            officialHostname = String(cString: hostent_p.pointee.h_name!)

            var nextAlias_p = hostent_p.pointee.h_aliases!
            //var q: String = nextAlias_p
            while nextAlias_p.pointee != nil {
                let alias = String(cString: UnsafePointer(nextAlias_p.pointee!))
                aliases.append(alias)
                nextAlias_p += 1
            }
        }
    }
#endif
