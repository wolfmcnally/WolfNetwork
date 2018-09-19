//
//  InFlightTracker.swift
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

import WolfLog
import WolfConcurrency

public internal(set) var inFlightTracker: InFlightTracker?

extension LogGroup {
    public static let inFlight = LogGroup("inFlight")
}

public class InFlightTracker {
    private let serializer = Serializer(label: "InFlightTracker")
    private var tokens = Set<InFlightToken>()
    public var didStart: ((InFlightToken) -> Void)?
    public var didEnd: ((InFlightToken) -> Void)?
    //    #if os(Linux)
    //    public var isHidden: Bool = false
    //    {
    //        didSet {
    //            syncToHidden()
    //        }
    //    }
    //    #else
    //    public var isHidden: Bool = {
    //        return !((userDefaults["DevInFlight"] as? Bool) ?? false)
    //    }()
    //    {
    //        didSet {
    //            syncToHidden()
    //        }
    //    }
    //    #endif

    //    #if os(Linux)
    //    public static func setup(withView: Bool = false) {
    //        inFlightTracker = InFlightTracker()
    //        inFlightTracker!.syncToHidden()
    //    }
    //    #endif

    //    #if !os(Linux)
    //    public static func setup(withView: Bool = false) {
    //        inFlightTracker = InFlightTracker()
    //        if withView {
    //            inFlightView = InFlightView()
    //            devOverlay => [
    //                inFlightView
    //            ]
    //            inFlightView.constrainFrameToFrame(identifier: "inFlight")
    //        }
    //        inFlightTracker!.syncToHidden()
    //    }
    //    #endif

    //    public func syncToHidden() {
    //        logTrace("syncToHidden: \(isHidden)", group: .inFlight)
    //        #if !os(Linux)
    //            inFlightView.hideIf(isHidden)
    //        #endif
    //    }

    public func start(withName name: String) -> InFlightToken {
        let token = InFlightToken(name: name)
        token.isNetworkActive = true
        didStart?(token)
        serializer.dispatch {
            self.tokens.insert(token)
        }
        logTrace("started: \(token)", group: .inFlight)
        return token
    }

    public func end(withToken token: InFlightToken, result: ResultSummary) {
        token.isNetworkActive = false
        token.result = result
        serializer.dispatch {
            if let token = self.tokens.remove(token) {
                logTrace("ended: \(token)", group: .inFlight)
            } else {
                fatalError("Token \(token) not found.")
            }
        }
        self.didEnd?(token)
    }
}

//private var testTokens = [InFlightToken]()
//
//public func testInFlightTracker() {
//    dispatchRepeatedOnMain(atInterval: 0.5) { canceler in
//        let n: Double = Random.number()
//        switch n {
//        case 0.0..<0.4:
//            let token = inFlightTracker!.start(withName: "Test")
//            testTokens.append(token)
//        case 0.4..<0.8:
//            if testTokens.count > 0 {
//                let index = Random.number(0..<testTokens.count)
//                let token = testTokens.remove(at: index)
//                let result = Random.boolean() ? Result<Int>.success(0) : Result<Int>.failure(GeneralError(message: "err"))
//                inFlightTracker!.end(withToken: token, result: result)
//            }
//        case 0.8..<1.0:
//            // do nothing
//            break
//        default:
//            break
//        }
//    }
//}
