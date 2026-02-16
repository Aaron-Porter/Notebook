import Foundation

public struct AgentReply {
    public let message: String
    public let notes: [Note]
}

public final class AgentEngine {
    public init() {}

    /// A local "AI" command interpreter with full note control.
    /// Supported commands:
    /// - create title: <title> | content: <content>
    /// - update <note-id> title: <title> | content: <content>
    /// - delete <note-id>
    /// - summarize
    /// - clear all
    public func handle(command: String, notes: [Note]) -> AgentReply {
        let trimmed = command.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.lowercased().hasPrefix("create") {
            return create(command: trimmed, notes: notes)
        }

        if trimmed.lowercased().hasPrefix("update") {
            return update(command: trimmed, notes: notes)
        }

        if trimmed.lowercased().hasPrefix("delete") {
            return delete(command: trimmed, notes: notes)
        }

        if trimmed.lowercased() == "clear all" {
            return AgentReply(message: "Deleted all notes.", notes: [])
        }

        if trimmed.lowercased() == "summarize" {
            let bulletList = notes.map { "• \($0.title): \($0.content.prefix(80))" }.joined(separator: "\n")
            let summary = notes.isEmpty
                ? "You do not have any notes yet."
                : "You have \(notes.count) notes:\n\(bulletList)"
            return AgentReply(message: summary, notes: notes)
        }

        let help = "I can control your notes with commands: create, update, delete, summarize, clear all."
        return AgentReply(message: help, notes: notes)
    }

    private func create(command: String, notes: [Note]) -> AgentReply {
        let payload = command.replacingOccurrences(of: "create", with: "", options: .caseInsensitive)
        let parsed = parseTitleAndContent(from: payload)
        let title = parsed.title?.isEmpty == false ? parsed.title! : "Untitled"
        let content = parsed.content ?? ""
        var updated = notes
        updated.insert(Note(title: title, content: content), at: 0)
        return AgentReply(message: "Created note '\(title)'.", notes: updated)
    }

    private func update(command: String, notes: [Note]) -> AgentReply {
        let parts = command.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: true)
        guard parts.count >= 3,
              let id = UUID(uuidString: String(parts[1])) else {
            return AgentReply(message: "Update format: update <note-id> title: ... | content: ...", notes: notes)
        }
        let parsed = parseTitleAndContent(from: String(parts[2]))
        guard let index = notes.firstIndex(where: { $0.id == id }) else {
            return AgentReply(message: "No note found for id \(id.uuidString).", notes: notes)
        }
        var updated = notes
        updated[index].apply(title: parsed.title, content: parsed.content)
        return AgentReply(message: "Updated note \(id.uuidString).", notes: updated)
    }

    private func delete(command: String, notes: [Note]) -> AgentReply {
        let parts = command.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        guard parts.count == 2,
              let id = UUID(uuidString: String(parts[1])) else {
            return AgentReply(message: "Delete format: delete <note-id>", notes: notes)
        }
        let updated = notes.filter { $0.id != id }
        if updated.count == notes.count {
            return AgentReply(message: "No note found for id \(id.uuidString).", notes: notes)
        }
        return AgentReply(message: "Deleted note \(id.uuidString).", notes: updated)
    }

    private func parseTitleAndContent(from text: String) -> (title: String?, content: String?) {
        let chunks = text.split(separator: "|", omittingEmptySubsequences: false).map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        var title: String?
        var content: String?

        for chunk in chunks {
            let lower = chunk.lowercased()
            if lower.hasPrefix("title:") {
                title = String(chunk.dropFirst("title:".count)).trimmingCharacters(in: .whitespacesAndNewlines)
            } else if lower.hasPrefix("content:") {
                content = String(chunk.dropFirst("content:".count)).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        return (title, content)
    }
}
