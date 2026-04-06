// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ClaudeTrackerTracker",
    platforms: [.macOS(.v12)],
    targets: [
        .executableTarget(
            name: "ClaudeTrackerTracker",
            path: "Sources"
        )
    ]
)
