// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NotebookAI",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .library(name: "NotebookAICore", targets: ["NotebookAICore"]),
        .executable(name: "NotebookAI", targets: ["NotebookAIApp"])
    ],
    targets: [
        .target(
            name: "NotebookAICore",
            path: "Sources/NotebookAICore"
        ),
        .executableTarget(
            name: "NotebookAIApp",
            dependencies: ["NotebookAICore"],
            path: "Sources/NotebookAIApp"
        ),
        .testTarget(
            name: "NotebookAIAppTests",
            dependencies: ["NotebookAICore"],
            path: "Tests/NotebookAIAppTests"
        )
    ]
)
