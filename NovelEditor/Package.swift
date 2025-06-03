// NovelEditor/Package.swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "NovelEditor",
  platforms: [.iOS(.v15), .macOS(.v12)],
  products: [.library(name: "NovelEditor", targets: ["NovelEditor"])],
  targets: [
    .target(
      name: "NovelEditor",
      resources: [.copy("Web")]
    )
  ]
)