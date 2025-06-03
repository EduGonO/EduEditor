// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "EduEditor",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "EduEditor", targets: ["EduEditor"])
    ],
    targets: [
        .target(
            name: "EduEditor",
            path: "Sources/EduEditor",
            resources: [
                .process("../../Resources/EditorBundle")
            ]
        )
    ]
)