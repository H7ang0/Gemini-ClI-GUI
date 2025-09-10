import SwiftUI

enum SettingsCategory: String, CaseIterable, Identifiable {
    case general = "General"
    case avatars = "Avatars"
    case experience = "Experience"
    case about = "About"

    var id: String { self.rawValue }
    
    var localizedTitle: LocalizedStringKey {
        LocalizedStringKey(self.rawValue.uppercased() + "_SETTINGS_TITLE")
    }
    
    var systemImage: String {
        switch self {
        case .general: return "gear"
        case .avatars: return "person.crop.circle"
        case .experience: return "sparkles"
        case .about: return "info.circle"
        }
    }
}

struct SettingsMainView: View {
    @State private var selectedCategory: SettingsCategory? = .general

    var body: some View {
        NavigationSplitView {
            List(SettingsCategory.allCases, selection: $selectedCategory) { category in
                NavigationLink(value: category) {
                    Label(category.localizedTitle, systemImage: category.systemImage)
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .navigationTitle(LocalizedStringKey("SETTINGS_WINDOW_TITLE"))
        } detail: {
            if let selectedCategory = selectedCategory {
                SettingsDetailView(category: selectedCategory)
            } else {
                Text(LocalizedStringKey("SELECT_SETTINGS_CATEGORY"))
            }
        }
        .frame(minWidth: 700, minHeight: 400)
    }
}
