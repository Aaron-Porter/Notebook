#if canImport(SwiftUI)
import SwiftUI
import NotebookAICore

public struct ContentView: View {
    @StateObject private var viewModel = NotesViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                GroupBox("New Note") {
                    VStack(spacing: 8) {
                        TextField("Title", text: $viewModel.draftTitle)
                            .textFieldStyle(.roundedBorder)
                        TextField("Content", text: $viewModel.draftContent, axis: .vertical)
                            .lineLimit(3...8)
                            .textFieldStyle(.roundedBorder)
                        Button("Add Note") {
                            viewModel.addNote()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                GroupBox("AI Agent") {
                    VStack(spacing: 8) {
                        TextField("e.g. summarize or create title: ... | content: ...", text: $viewModel.agentInput)
                            .textFieldStyle(.roundedBorder)
                        Button("Run Agent Command") {
                            viewModel.runAgent()
                        }
                        .buttonStyle(.bordered)

                        ScrollView {
                            Text(viewModel.agentLog.joined(separator: "\n"))
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(minHeight: 80, maxHeight: 150)
                    }
                }

                List {
                    ForEach(viewModel.notes) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.title)
                                .font(.headline)
                            Text(note.content)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("ID: \(note.id.uuidString)")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: viewModel.deleteNotes)
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationTitle("Notebook AI")
        }
    }
}
#endif
