import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .navigationSplitViewColumnWidth(min: 220, ideal: 250)
        } detail: {
            if viewModel.selectedConversationID != nil {
                ChatView()
            } else {
                VStack {
                    Text(LocalizedStringKey("APP_TITLE"))
                        .font(.largeTitle)
                    Text(LocalizedStringKey("SELECT_OR_CREATE_CONVERSATION"))
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
        }
        .environmentObject(viewModel)
    }
}