// swift-tools-version:5.1

import PackageDescription

let exclude = ["PMKMapKit.h"] + ["MKMapSnapshotter", "MKDirections"].flatMap {
    ["\($0)+AnyPromise.m", "\($0)+AnyPromise.h"]
}

let package = Package(
    name: "PMKMapKit",
    platforms: [
        .macOS(.v10_10), .iOS(.v8), .tvOS(.v9), .watchOS(.v3)
    ],
    products: [
        .library(
            name: "PMKMapKit",
            targets: ["PMKMapKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.0.0"),
    ],
    targets: [
        .target(
            name: "PMKMapKit",
            dependencies: ["PromiseKit"],
            path: "Sources/MapKit",
            exclude: exclude),
        .testTarget(
            name: "PMKMapKitTests",
            dependencies: ["PMKMapKit"],
            path: "Tests"),
    ]
)
