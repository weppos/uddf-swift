// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "UDDF",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "UDDF",
            targets: ["UDDF"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/CoreOffice/XMLCoder.git",
            from: "0.17.0"
        )
    ],
    targets: [
        .target(
            name: "UDDF",
            dependencies: [
                .product(name: "XMLCoder", package: "XMLCoder")
            ]
        ),
        .testTarget(
            name: "UDDFTests",
            dependencies: ["UDDF"],
            resources: [
                .copy("Fixtures")
            ]
        )
    ]
)
