import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        List(viewModel.conversations, selection: $viewModel.selectedConversationID) { conversation in
            NavigationLink(value: conversation.id) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(conversation.title)
                        .font(.headline)
                        .lineLimit(1)
                    Text(conversation.messages.last?.text ?? String(localized: "NO_MESSAGES_YET"))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(LocalizedStringKey("HISTORY_TITLE"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    viewModel.createNewConversation()
                }) {
                    Label(LocalizedStringKey("NEW_CHAT_BUTTON"), systemImage: "plus")
                }
            }
        }
    }
}