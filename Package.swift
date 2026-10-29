// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "QcSdkCore", defaultLocalization: "en", platforms: [.iOS(.v17)],

    products: [
        .library(name: "QcSdkCore", targets: ["QcSdkCore", "QcSdkCoreSupport"])
    ],

    dependencies: [],

    targets: [
        .binaryTarget(name: "QcSdkCore", url: "https://github.com/YuFengChen77/QcSdkCore/releases/download/1.1.5/QcSdkCore-1.1.5.xcframework.zip", checksum: "90454f7b58b8f26d5aa3a3f2420b54934e84bb59d305131baeed8e8e4427abb2"),

        .target(name: "QcSdkCoreSupport", dependencies: ["QcSdkCore"], path: "QcSdkCore", sources: ["Sources"], resources: [.process("Resources")])
    ]
)
