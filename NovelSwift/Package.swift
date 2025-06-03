// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "NovelSwift",
  platforms: [.iOS(.v15), .macOS(.v12)],
  products: [
    .library(name: "NovelSwift", targets: ["NovelSwift"])
  ],
  targets: [
    .target(
      name: "NovelSwift",
      resources: [.copy("Web")]   // ← bundle everything under Web/
    )
  ]
)