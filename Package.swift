// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "WolfNetwork",
    platforms: [
        .iOS(.v9), .macOS(.v10_13), .tvOS(.v11)
    ],
    products: [
        .library(
            name: "WolfNetwork",
            type: .dynamic,
            targets: ["WolfNetwork"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfConcurrency", from: "3.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfPipe", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfFoundation", from: "5.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfLog", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfLocale", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfSec", from: "3.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfApp", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfPubSub", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfNIO", from: "1.0.0"),
        .package(url: "https://github.com/wolfmcnally/ExtensibleEnumeratedName", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfStrings", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "WolfNetwork",
            dependencies: [
                "WolfConcurrency",
                "WolfPipe",
                "WolfFoundation",
                "WolfLog",
                "WolfLocale",
                "WolfSec",
                "WolfApp",
                "WolfPubSub",
                "WolfNIO",
                "WolfStrings",
                "ExtensibleEnumeratedName"
            ])
        ]
)
