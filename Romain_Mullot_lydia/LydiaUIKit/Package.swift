// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LydiaUIKit",
    platforms: [.iOS(.v15)],
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
