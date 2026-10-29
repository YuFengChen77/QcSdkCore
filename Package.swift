// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "QcSdkCore", defaultLocalization: "en", platforms: [.iOS(.v17)],

    products: [
        .library(name: "QcSdkCore", targets: ["QcSdkCore", "QcSdkCoreDistribution"])
    ],

    dependencies: [],

    targets: [
        .binaryTarget(name: "QcSdkCore", url: "https://github.com/YuFengChen77/QcSdkCore/releases/download/1.1.3/QcSdkCore-1.1.3.xcframework.zip", checksum: "7156faf55cbeec03c68ae2ab2196a678e4cf9463aa3403d518aa9801643b35da"),

        .target(name: "QcSdkCoreDistribution", dependencies: ["QcSdkCore"], path: "QcSdkCore", sources: ["Sources"], resources: [.process("Resources")])
    ]
)
