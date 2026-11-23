// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LydiaUIKit",
    platforms: [.iOS("17.0")],
    products: [
        .library(name: "LydiaUIKit", targets: ["LydiaUIKit"])
    ],
    targets: [
        .target(
            name: "LydiaUIKit",
            path: "LydiaUIKit",
            exclude: ["Info.plist"]
        )
    ]
)
