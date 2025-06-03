// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "EduEditorSwift",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "EduEditorSwift", targets: ["EduEditorSwift"])
    ],
    targets: [
        .target(
            name: "EduEditorSwift",
            path: "Sources/EduEditorSwift",
            resources: [
                .process("../../Resources/EditorBundle")
            ]
        )
    ]
)
