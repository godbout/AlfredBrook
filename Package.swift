// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlfredBrook",
    platforms: [.macOS("10.15.7")],
    dependencies: [
        .package(
            url: "https://github.com/godbout/AlfredWorkflowScriptFilter",
            from: "1.0.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "AlfredBrook",
            dependencies: ["AlfredBrookCore"]
        ),
        .target(
            name: "AlfredBrookCore",
            dependencies: ["AlfredWorkflowScriptFilter"]
        ),
        .testTarget(
            name: "AlfredBrookCoreTests",
            dependencies: ["AlfredBrookCore"]
        ),
    ]
)
