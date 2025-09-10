import SwiftUI

struct ContentView: View {
    @State private var command: String = ""

    var body: some View {
        ZStack {
            // Use a translucent material for the modern background
            VisualEffectView(material: .underWindowBackground, blendingMode: .behindWindow)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Conversation Area (Placeholder)
                ScrollView {
                    VStack {
                        Text("Welcome to Gemini GUI")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 40)
                        Text("by H7ang0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }

                // Input Area
                HStack {
                    TextField("Enter your command...", text: $command)
                        .textFieldStyle(.plain)
                        .padding(10)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(12)

                    Button(action: {
                        // Action to send command will be here
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.borderless)
                    .disabled(command.isEmpty)
                }
                .padding()
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

// Helper view to use NSVisualEffectView in SwiftUI
struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSViewRepresentable, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
