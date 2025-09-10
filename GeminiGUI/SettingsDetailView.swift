import SwiftUI
import AppKit // For NSWorkspace

struct SettingsDetailView: View {
    let category: SettingsCategory
    
    @State private var geminiPath: String
    @State private var userAvatarName: String
    @State private var geminiAvatarName: String
    @State private var hapticFeedbackEnabled: Bool

    private let settingsService = SettingsService()

    init(category: SettingsCategory) {
        self.category = category
        let service = SettingsService()
        _geminiPath = State(initialValue: service.geminiPath)
        _userAvatarName = State(initialValue: service.userAvatarName)
        _geminiAvatarName = State(initialValue: service.geminiAvatarName)
        _hapticFeedbackEnabled = State(initialValue: service.hapticFeedbackEnabled)
    }

    var body: some View {
        Form {
            switch category {
            case .general:
                Section(header: Text(LocalizedStringKey("COMMAND_PATH_SECTION"))) {
                    TextField(LocalizedStringKey("GEMINI_EXECUTABLE_PATH_LABEL"), text: $geminiPath)
                }
            case .avatars:
                Section(header: Text(LocalizedStringKey("AVATARS_SECTION"))) {
                    TextField(LocalizedStringKey("USER_AVATAR_LABEL"), text: $userAvatarName)
                    TextField(LocalizedStringKey("GEMINI_AVATAR_LABEL"), text: $geminiAvatarName)
                    Text(LocalizedStringKey("SF_SYMBOLS_HINT"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            case .experience:
                Section(header: Text(LocalizedStringKey("EXPERIENCE_SECTION"))) {
                    Toggle(LocalizedStringKey("HAPTIC_FEEDBACK_TOGGLE"), isOn: $hapticFeedbackEnabled)
                }
            case .about:
                Section(header: Text(LocalizedStringKey("ABOUT_SETTINGS_TITLE"))) {
                    Text(LocalizedStringKey("APP_TITLE"))
                        .font(.headline)
                    Text(LocalizedStringKey("APP_VERSION_FULL_LABEL"))
                    Text(LocalizedStringKey("DEVELOPED_BY_FULL_LABEL"))
                    Text("https://t.me/H7ang0")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            if let url = URL(string: "https://t.me/H7ang0") {
                                NSWorkspace.shared.open(url)
                            }
                        }
                }
            }
        }
        .padding()
        .navigationTitle(category.localizedTitle)
        .onDisappear {
            // Save all settings when the view is closed
            settingsService.geminiPath = geminiPath
            settingsService.userAvatarName = userAvatarName
            settingsService.geminiAvatarName = geminiAvatarName
            settingsService.hapticFeedbackEnabled = hapticFeedbackEnabled
        }
    }
}
