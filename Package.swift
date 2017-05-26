// swift-tools-version:3.1

import PackageDescription

let package = Package(
  name: "Tar",
  dependencies: [
    .Package(url: "https://github.com/pruthvikar/GZIP.git", "1.0.0-beta.1")
  ],
  exclude: [
    "Sources/Compression",
    "Tests/Data"
  ]
)
