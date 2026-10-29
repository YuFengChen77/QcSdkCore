// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "QcSdkCore", defaultLocalization: "en", platforms: [.iOS(.v17)],

    products: [
        .library(name: "QcSdkCore", targets: ["QcSdkCore", "QcSdkCoreDistribution"])
    ],

    dependencies: [],

    targets: [
        .binaryTarget(name: "QcSdkCore", url: "https://github.com/YuFengChen77/QcSdkCore/releases/download/1.1.2/QcSdkCore-1.1.2.xcframework.zip", checksum: "07d8b3c3a51fe7c027085d45df87d57d5cd1e2fbadc8c2339a1f1666a1ac21b2"),

        .target(name: "QcSdkCoreDistribution", dependencies: ["QcSdkCore"], resources: [.process("Resources")])
    ]
)
