import Foundation
import SwiftUI
import AppKit // Import AppKit for NSHapticFeedbackManager

@MainActor
class AppViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var selectedConversationID: UUID? {
        didSet {
            // When a conversation is selected, we might want to perform an action
        }
    }
    @Published var isRunning: Bool = false

    private let historyService = HistoryService()
    private let shellService = ShellService()
    private let settingsService = SettingsService() // Add SettingsService
    
    var selectedConversation: Conversation? {
        guard let selectedID = selectedConversationID else { return nil }
        return conversations.first { $0.id == selectedID }
    }
    
    private var selectedConversationIndex: Int? {
        guard let selectedID = selectedConversationID else { return nil }
        return conversations.firstIndex { $0.id == selectedID }
    }

    init() {
        self.conversations = historyService.load()
        if let firstConversation = self.conversations.first {
            self.selectedConversationID = firstConversation.id
        } else if conversations.isEmpty {
            // If no conversations, create a new one
            createNewConversation()
        }
    }

    // MARK: - Intents

    func createNewConversation() {
        let newConversation = Conversation(id: UUID(), title: String(localized: "NEW_CHAT_DEFAULT_TITLE"), messages: [], lastMessageDate: Date())
        conversations.insert(newConversation, at: 0)
        selectedConversationID = newConversation.id
        saveConversations()
    }
    
    func selectConversation(_ conversation: Conversation) {
        selectedConversationID = conversation.id
    }

    func sendMessage(prompt: String) {
        guard let index = selectedConversationIndex else { return }
        
        isRunning = true
        
        let userMessage = Message(role: .user, text: prompt)
        conversations[index].messages.append(userMessage)
        conversations[index].lastMessageDate = Date()
        
        // Auto-generate title from first message
        if conversations[index].title == String(localized: "NEW_CHAT_DEFAULT_TITLE") {
            conversations[index].title = prompt
        }
        
        let geminiMessage = Message(role: .gemini, text: "")
        conversations[index].messages.append(geminiMessage)
        let geminiMessageIndex = conversations[index].messages.count - 1

        Task {
            var hapticTriggeredForThisMessage = false // Flag for haptic feedback
            for await output in shellService.run(prompt: prompt) {
                if conversations.indices.contains(index) && conversations[index].messages.indices.contains(geminiMessageIndex) {
                    // Trigger haptic feedback on first output chunk
                    if settingsService.hapticFeedbackEnabled && !hapticTriggeredForThisMessage {
                        NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)
                        hapticTriggeredForThisMessage = true
                    }
                    conversations[index].messages[geminiMessageIndex].text += output
                }
            }
            
            DispatchQueue.main.async {
                self.isRunning = false
                self.saveConversations()
            }
        }
    }
    
    func stop() {
        shellService.stop()
        isRunning = false
    }

    private func saveConversations() {
        historyService.save(conversations: conversations)
    }
}
