// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LydiaCore",
    platforms: [.iOS("17.0")],
    products: [
        .library(name: "LydiaCore", targets: ["LydiaCore"])
    ],
    targets: [
        .target(
            name: "LydiaCore",
            path: "LydiaCore",
            exclude: ["Info.plist"]
        )
    ]
)
