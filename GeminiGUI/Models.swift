import Foundation

struct Conversation: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var messages: [Message]
    var lastMessageDate: Date
}

struct Message: Identifiable, Equatable, Codable, Hashable {
    let id = UUID()
    var role: Role
    var text: String
    
    enum Role: String, Codable, Hashable {
        case user
        case gemini
    }

    // We don't encode/decode the id, it's generated on load.
    enum CodingKeys: String, CodingKey {
        case role, text
    }
}
