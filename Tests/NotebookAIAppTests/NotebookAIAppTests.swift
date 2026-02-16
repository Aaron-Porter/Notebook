import XCTest
@testable import NotebookAICore

final class NotebookAIAppTests: XCTestCase {
    func testStoreRoundTrip() throws {
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")
        let store = NotesStore(fileURL: tempURL)

        let notes = [
            Note(title: "First", content: "Hello"),
            Note(title: "Second", content: "World")
        ]

        try store.saveNotes(notes)
        let loaded = try store.loadNotes()
        XCTAssertEqual(loaded.count, 2)
        XCTAssertEqual(loaded.map(\.title), ["First", "Second"])
    }

    func testAgentCreateAndDelete() {
        let agent = AgentEngine()
        let created = agent.handle(command: "create title: Task | content: Buy milk", notes: [])
        XCTAssertEqual(created.notes.count, 1)
        XCTAssertEqual(created.notes.first?.title, "Task")

        let id = created.notes[0].id.uuidString
        let deleted = agent.handle(command: "delete \(id)", notes: created.notes)
        XCTAssertTrue(deleted.notes.isEmpty)
    }
}
