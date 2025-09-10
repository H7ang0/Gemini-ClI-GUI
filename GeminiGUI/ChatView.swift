import SwiftUI

struct ChatView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var promptText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Conversation Area
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        if let conversation = viewModel.selectedConversation {
                            ForEach(conversation.messages) { message in
                                MessageView(message: message)
                                    .id(message.id)
                            }
                            // Show typing indicator if Gemini is "typing"
                            if viewModel.isRunning &&
                               viewModel.selectedConversation?.messages.last?.role == .gemini &&
                               viewModel.selectedConversation?.messages.last?.text.isEmpty == true {
                                HStack {
                                    TypingIndicatorView()
                                    Spacer()
                                }
                            }
                        } else {
                            Text(LocalizedStringKey("NO_CONVERSATION_SELECTED"))
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.selectedConversation?.messages.count) { _, _ in
                    if let lastMessage = viewModel.selectedConversation?.messages.last {
                        withAnimation {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Input Area
            HStack(alignment: .bottom) {
                TextField(LocalizedStringKey("ENTER_COMMAND_PLACEHOLDER"), text: $promptText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(12)
                    .lineLimit(1...5)
                    .disabled(viewModel.isRunning)
                    .onSubmit {
                        sendMessage()
                    }
                
                if viewModel.isRunning {
                    Button(action: { viewModel.stop() }) {
                        Image(systemName: "stop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.borderless)
                    .padding(.bottom, 6)
                } else {
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.borderless)
                    .disabled(promptText.isEmpty)
                    .padding(.bottom, 6)
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.selectedConversation?.title ?? String(localized: "CHAT_DEFAULT_TITLE"))
    }
    
    func sendMessage() {
        viewModel.sendMessage(prompt: promptText)
        promptText = ""
    }
}

// A view to style each message bubble, now with Avatars
struct MessageView: View {
    let message: Message
    @State private var isCopied: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if message.role == .gemini {
                AvatarView(role: .gemini)
            }

            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(message.role == .user ? Color.accentColor : Color.primary.opacity(0.15))
                    .foregroundColor(message.role == .user ? .white : .primary)
                    .cornerRadius(16)
                    .textSelection(.enabled)
                
                if message.role == .gemini && !message.text.isEmpty {
                    Button(action: copyToClipboard) {
                        HStack(spacing: 4) {
                            Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                            Text(isCopied ? LocalizedStringKey("COPIED_BUTTON") : LocalizedStringKey("COPY_BUTTON"))
                        }
                        .font(.caption)
                        .foregroundColor(isCopied ? .green : .secondary)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)

            if message.role == .user {
                AvatarView(role: .user)
            }
        }
        .contextMenu {
            Button(LocalizedStringKey("COPY_BUTTON"), action: copyToClipboard)
        }
    }

    func copyToClipboard() {
        guard !message.text.isEmpty else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(message.text, forType: .string)
        
        withAnimation { isCopied = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { isCopied = false }
        }
    }
}

// Avatar View
struct AvatarView: View {
    let role: Message.Role
    private let settings = SettingsService()

    var body: some View {
        Image(systemName: role == .user ? settings.userAvatarName : settings.geminiAvatarName)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(width: 32, height: 32)
            .background(role == .user ? Color.blue.opacity(0.8) : Color.purple.opacity(0.8))
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}
