// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LydiaNetwork",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "LydiaNetwork", targets: ["LydiaNetwork"])
    ],
    targets: [
        .target(
            name: "LydiaNetwork",
            path: "LydiaNetwork",
            exclude: ["Info.plist"]
        )
    ]
)
