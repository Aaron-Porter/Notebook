#if canImport(SwiftUI)
import SwiftUI

@main
public struct NotebookAIApp: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
#else
import Foundation

@main
public struct NotebookAIApp {
    public static func main() {
        print("NotebookAIApp requires SwiftUI (iOS/macOS) to run UI.")
    }
}
#endif
