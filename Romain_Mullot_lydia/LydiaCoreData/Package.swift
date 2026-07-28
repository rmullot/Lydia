// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LydiaCoreData",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "LydiaCoreData", targets: ["LydiaCoreData"])
    ],
    dependencies: [
        .package(path: "../LydiaAPI")
    ],
    targets: [
        .target(
            name: "LydiaCoreData",
            dependencies: [
                .product(name: "LydiaAPI", package: "LydiaAPI")
            ],
            path: "LydiaCoreData",
            exclude: ["Info.plist"],
            resources: [
                .process("LydiaCoreData.xcdatamodeld")
            ]
        )
    ]
)
