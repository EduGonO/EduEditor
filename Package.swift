// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "EduEditor",
  platforms: [
    .iOS(.v15), .macOS(.v12)
  ],
  products: [
    .library(name: "EduEditor", targets: ["EduEditor"]),
  ],
  targets: [
    .target(
      name: "EduEditor",
      resources: [
        .process("Resources/EditorBundle")
      ]
    )
  ]
)
