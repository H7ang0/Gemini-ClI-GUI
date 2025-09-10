import Foundation

class HistoryService {
    private var fileURL: URL

    init() {
        // Find the application support directory and create a file for the conversations.
        if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let directoryURL = appSupportURL.appendingPathComponent("GeminiGUI")
            // Create the directory if it doesn't exist
            try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            self.fileURL = directoryURL.appendingPathComponent("conversations.json")
        } else {
            // Fallback to a local file if app support is not available (unlikely)
            self.fileURL = URL(fileURLWithPath: "conversations.json")
        }
    }

    func load() -> [Conversation] {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let conversations = try decoder.decode([Conversation].self, from: data)
            return conversations.sorted(by: { $0.lastMessageDate > $1.lastMessageDate })
        } catch {
            print("Could not load conversations: \(error.localizedDescription)")
            return []
        }
    }

    func save(conversations: [Conversation]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(conversations)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Could not save conversations: \(error.localizedDescription)")
        }
    }
}