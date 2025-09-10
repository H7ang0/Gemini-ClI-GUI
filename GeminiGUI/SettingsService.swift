import Foundation

class SettingsService {
    private let defaults = UserDefaults.standard

    // Keys
    private let geminiPathKey = "geminiExecutablePath"
    private let userAvatarKey = "userAvatarName"
    private let geminiAvatarKey = "geminiAvatarName"
    private let hapticsEnabledKey = "hapticFeedbackEnabled"

    var geminiPath: String {
        get {
            return defaults.string(forKey: geminiPathKey) ?? "/opt/homebrew/bin/gemini"
        }
        set {
            defaults.set(newValue, forKey: geminiPathKey)
        }
    }

    var userAvatarName: String {
        get {
            return defaults.string(forKey: userAvatarKey) ?? "person.fill"
        }
        set {
            defaults.set(newValue, forKey: userAvatarKey)
        }
    }

    var geminiAvatarName: String {
        get {
            return defaults.string(forKey: geminiAvatarKey) ?? "sparkle"
        }
        set {
            defaults.set(newValue, forKey: geminiAvatarKey)
        }
    }
    
    var hapticFeedbackEnabled: Bool {
        get {
            return defaults.bool(forKey: hapticsEnabledKey)
        }
        set {
            defaults.set(newValue, forKey: hapticsEnabledKey)
        }
    }
}
