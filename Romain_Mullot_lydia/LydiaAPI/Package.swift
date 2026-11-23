// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LydiaAPI",
    defaultLocalization: "en",
    platforms: [.iOS("17.0")],
    products: [
        .library(name: "LydiaAPI", targets: ["LydiaAPI"])
    ],
    dependencies: [
        .package(path: "../LydiaCore"),
        .package(path: "../LydiaNetwork"),
        .package(url: "https://github.com/SwiftKickMobile/SwiftMessages.git", from: "9.0.0")
    ],
    targets: [
        .target(
            name: "LydiaAPI",
            dependencies: [
                .product(name: "LydiaCore", package: "LydiaCore"),
                .product(name: "LydiaNetwork", package: "LydiaNetwork"),
                .product(name: "SwiftMessages", package: "SwiftMessages")
            ],
            path: ".",
            exclude: [
                "LydiaAPI/Info.plist"
            ],
            sources: [
                "LydiaAPI",
                "Resources/Strings.swift"
            ],
            resources: [
                .process("Resources/en.lproj"),
                .process("Resources/fr.lproj")
            ]
        )
    ]
)
