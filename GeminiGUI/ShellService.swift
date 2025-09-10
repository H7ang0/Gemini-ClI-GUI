import Foundation

class ShellService: ObservableObject {
    private var task: Process?

    func run(prompt: String) -> AsyncStream<String> {
        AsyncStream { continuation in
            let settingsService = SettingsService()
            self.task = Process()
            let pipe = Pipe()

            guard let task = self.task else {
                continuation.finish()
                return
            }

            task.executableURL = URL(fileURLWithPath: "/bin/zsh") // Run via shell

            // Construct the command safely, escaping quotes in the prompt.
            let escapedPrompt = prompt.replacingOccurrences(of: "\"", with: "\\\"")
            // Prepend common Homebrew paths to the PATH and redirect stderr to /dev/null at the shell level.
            let command = "export PATH=/opt/homebrew/bin:/usr/local/bin:$PATH; \(settingsService.geminiPath) -p \"\(escapedPrompt)\" 2>/dev/null"
            task.arguments = ["-c", command]
            
            task.standardOutput = pipe
            task.standardError = pipe

            pipe.fileHandleForReading.readabilityHandler = { fileHandle in
                let data = fileHandle.availableData
                if data.isEmpty {
                    // EOF, stop reading
                    pipe.fileHandleForReading.readabilityHandler = nil
                    continuation.finish()
                } else {
                    if let output = String(data: data, encoding: .utf8) {
                        continuation.yield(output)
                    }
                }
            }
            
            task.terminationHandler = { _ in
                continuation.finish()
                DispatchQueue.main.async {
                    self.task = nil // Clear the task when it's done
                }
            }

            do {
                try task.run()
            } catch {
                continuation.yield("Error launching command: \(error.localizedDescription)")
                continuation.finish()
            }
        }
    }

    func stop() {
        task?.terminate()
    }
}