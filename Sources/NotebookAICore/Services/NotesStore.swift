import Foundation

public protocol NotesStoreProtocol {
    func loadNotes() throws -> [Note]
    func saveNotes(_ notes: [Note]) throws
}

public final class NotesStore: NotesStoreProtocol {
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(fileManager: FileManager = .default, appFolderName: String = "NotebookAI", fileName: String = "notes.json") {
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            ?? fileManager.homeDirectoryForCurrentUser
        let appFolderURL = documentsURL.appendingPathComponent(appFolderName, isDirectory: true)
        if !fileManager.fileExists(atPath: appFolderURL.path) {
            try? fileManager.createDirectory(at: appFolderURL, withIntermediateDirectories: true)
        }
        self.fileURL = appFolderURL.appendingPathComponent(fileName)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    public init(fileURL: URL) {
        self.fileURL = fileURL
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    public func loadNotes() throws -> [Note] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([Note].self, from: data)
    }

    public func saveNotes(_ notes: [Note]) throws {
        let data = try encoder.encode(notes)
        let parent = fileURL.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: parent.path) {
            try FileManager.default.createDirectory(at: parent, withIntermediateDirectories: true)
        }
        try data.write(to: fileURL, options: .atomic)
    }

    public var storagePath: String {
        fileURL.path
    }
}
