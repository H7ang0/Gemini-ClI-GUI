import SwiftUI

struct TypingIndicatorView: View {
    @State private var dotScales: [CGFloat] = [1.0, 1.0, 1.0]
    private let animationDuration: Double = 0.6
    private let delayBetweenDots: Double = 0.2

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .scaleEffect(dotScales[index])
                    .animation(
                        Animation.easeInOut(duration: animationDuration)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * delayBetweenDots),
                        value: dotScales[index]
                    )
            }
        }
        .onAppear(perform: startAnimation)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.primary.opacity(0.15))
        .cornerRadius(16)
    }

    private func startAnimation() {
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * delayBetweenDots) {
                dotScales[i] = 0.6 // Scale down slightly to start the bounce
            }
        }
    }
}

struct TypingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        TypingIndicatorView()
    }
}
