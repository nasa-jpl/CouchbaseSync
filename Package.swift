// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CouchbaseSync",
    platforms: [
        .macOS(.v14), .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CouchbaseSync",
            targets: ["CouchbaseSync"]),
    ],
    dependencies: [
        .package(
            name: "CouchbaseLiteSwift",
            url: "https://github.com/couchbase/couchbase-lite-swift-ee.git",
            from: "3.2.4"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CouchbaseSync",
            dependencies: ["CouchbaseLiteSwift"]),
        .testTarget(
            name: "CouchbaseSyncTests",
            dependencies: ["CouchbaseSync"]
        ),
    ]
)
