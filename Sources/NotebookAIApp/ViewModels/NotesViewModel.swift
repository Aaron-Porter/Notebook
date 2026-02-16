#if canImport(Combine)
import Foundation
import Combine
import NotebookAICore

@MainActor
public final class NotesViewModel: ObservableObject {
    @Published public private(set) var notes: [Note] = []
    @Published public var draftTitle: String = ""
    @Published public var draftContent: String = ""
    @Published public var agentInput: String = ""
    @Published public private(set) var agentLog: [String] = []

    private let store: NotesStore
    private let agent: AgentEngine

    public init(store: NotesStore = NotesStore(), agent: AgentEngine = AgentEngine()) {
        self.store = store
        self.agent = agent
        load()
        agentLog.append("Storage location: \(store.storagePath)")
        agentLog.append("Agent ready. Try: summarize")
    }

    public func addNote() {
        guard !draftTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                !draftContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        notes.insert(Note(title: draftTitle.isEmpty ? "Untitled" : draftTitle, content: draftContent), at: 0)
        draftTitle = ""
        draftContent = ""
        persist()
    }

    public func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        persist()
    }

    public func runAgent() {
        let command = agentInput
        agentInput = ""
        let reply = agent.handle(command: command, notes: notes)
        notes = reply.notes
        agentLog.append("> \(command)")
        agentLog.append(reply.message)
        persist()
    }

    private func load() {
        do {
            notes = try store.loadNotes().sorted { $0.updatedAt > $1.updatedAt }
        } catch {
            agentLog.append("Failed loading notes: \(error.localizedDescription)")
        }
    }

    private func persist() {
        do {
            try store.saveNotes(notes)
        } catch {
            agentLog.append("Failed saving notes: \(error.localizedDescription)")
        }
    }
}
#endif
