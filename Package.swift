// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "HAP",
    products: [
        .library(name: "HAP", targets: ["HAP"]),
        .executable(name: "hap-server", targets: ["hap-server"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/core.git", from: "3.4.0"),
        .package(url: "https://github.com/Bouke/CLibSodium.git", from: "1.0.0"),
        .package(url: "https://github.com/Bouke/SRP.git", from: "3.1.0"),
        .package(url: "https://github.com/Bouke/HKDF.git", from: "3.1.0"),
        .package(url: "https://github.com/knly/Evergreen.git", .branch("swift4")),
        .package(url: "https://github.com/IBM-Swift/BlueCryptor.git", from: "1.0.21"),
        .package(url: "https://github.com/crossroadlabs/Regex.git", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.11.0"),
    ],
    targets: [
        .target(name: "CQRCode"),
        .target(name: "HAPHTTP"),
        .target(name: "HAP", dependencies: ["SRP", "Cryptor", "Evergreen", "HKDF", "Regex", "CQRCode", "HAPHTTP", "COperatingSystem"]),
        .target(name: "hap-server", dependencies: ["HAP", "Evergreen"]),
        .testTarget(name: "HAPTests", dependencies: ["HAP"]),
    ]
)

#if os(Linux)
    package.dependencies.append(.package(url: "https://github.com/Bouke/NetService.git", .branch("dns_sd")))
    package.targets.first(where: { $0.name == "HAP" })!.dependencies.append("NetService")
#endif
