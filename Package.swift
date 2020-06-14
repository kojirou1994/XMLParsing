// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "XMLParsing",
  products: [
    .library(
      name: "XMLParsing",
      targets: ["XMLParsing"]),
  ],
  targets: [
    .target(
      name: "XMLParsing",
      dependencies: []),
    .testTarget(
      name: "XMLParsingTests",
      dependencies: ["XMLParsing"]),
  ]
)
