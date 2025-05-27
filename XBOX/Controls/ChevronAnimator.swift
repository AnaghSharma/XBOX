import SwiftUI

struct ChevronAnimator: View {
    @State private var animate = false

        var body: some View {
            VStack(spacing: 2) {
                ForEach(0..<3) { index in
                    Image(systemName: "chevron.compact.down")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .opacity(animate ? 0.2 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .delay(Double(index) * 0.2)
                                .repeatForever(autoreverses: true),
                            value: animate
                        )
                }
            }
            .onAppear {
                animate = true
            }
        }
}
