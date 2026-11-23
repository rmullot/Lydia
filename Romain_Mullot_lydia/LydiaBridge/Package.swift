// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LydiaBridge",
    platforms: [.iOS("17.0")],
    products: [
        .library(name: "LydiaBridge", targets: ["LydiaBridge"])
    ],
    dependencies: [
        .package(path: "../LydiaAPI"),
        .package(path: "../LydiaCoreData")
    ],
    targets: [
        .target(
            name: "LydiaBridge",
            dependencies: [
                .product(name: "LydiaAPI", package: "LydiaAPI"),
                .product(name: "LydiaCoreData", package: "LydiaCoreData")
            ],
            path: "LydiaBridge",
            exclude: ["Info.plist"]
        )
    ]
)
