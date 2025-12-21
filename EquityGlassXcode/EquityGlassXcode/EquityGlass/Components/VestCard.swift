import SwiftUI
import LocalAuthentication

struct VestCard: View {
    let vest: VestEvent
    @State private var isRevealed = false
    @State private var shake = false
    @State private var hideTimer: Timer?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            Text("UPCOMING VEST")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Company name
            Text(vest.companyName)
                .font(.title2.bold())

            // Vest date and countdown
            HStack {
                Text(vest.vestDate, style: .date)
                    .font(.subheadline)
                Text("•")
                    .foregroundStyle(.secondary)
                Text("\(vest.daysUntilVest) days")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Divider()
                .padding(.vertical, 4)

            // Share count (always visible)
            Text("\(vest.sharesVesting.formatted()) shares")
                .font(.headline)

            // Dollar amount (blurred or revealed)
            ZStack {
                if !isRevealed {
                    // Blurred placeholder
                    Text("$•••,•••")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                } else {
                    // Revealed amount
                    Text(vest.estimatedValue, format: .currency(code: "USD"))
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .contentTransition(.numericText(value: vest.estimatedValue))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .visualEffect { content, proxy in
                content
                    .blur(radius: isRevealed ? 0 : 12)
            }
            .animation(.smooth(duration: 0.5), value: isRevealed)

            // Tap to reveal / Auto-hide indicator
            if !isRevealed {
                Text("Tap to reveal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                HStack(spacing: 4) {
                    Image(systemName: "lock.fill")
                        .font(.caption2)
                    Text("Auto-hiding in 10s")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        .offset(x: shake ? -10 : 0)
        .onTapGesture {
            if !isRevealed {
                authenticateAndReveal()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(isRevealed ?
            "Vest amount: \(vest.estimatedValue.formatted(.currency(code: "USD")))" :
            "Vest amount hidden. Double tap to reveal with Face ID")
        .accessibilityHint(isRevealed ? "" : "Requires Face ID authentication")
    }

    func authenticateAndReveal() {
        let context = LAContext()
        var error: NSError?

        // Check if biometric authentication is available
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            // If Face ID not available, show error
            print("Biometric authentication not available: \(error?.localizedDescription ?? "Unknown error")")
            shakeCard()
            return
        }

        // Evaluate authentication
        context.evaluatePolicy(.deviceOwnerAuthentication,
                             localizedReason: "Reveal vest amount") { success, authError in
            DispatchQueue.main.async {
                if success {
                    // Successful authentication
                    withAnimation(.smooth) {
                        isRevealed = true
                    }

                    // Success haptic
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)

                    // Auto-hide after 10 seconds
                    hideTimer?.invalidate()
                    hideTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
                        withAnimation(.smooth) {
                            isRevealed = false
                        }
                    }
                } else {
                    // Failed authentication
                    print("Authentication failed: \(authError?.localizedDescription ?? "Unknown error")")
                    shakeCard()
                }
            }
        }
    }

    func shakeCard() {
        // Error haptic
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)

        // Shake animation
        withAnimation(.linear(duration: 0.1).repeatCount(3, autoreverses: true)) {
            shake = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            shake = false
        }
    }
}

#Preview {
    VestCard(vest: VestEvent(
        id: UUID(),
        vestDate: Calendar.current.date(byAdding: .day, value: 47, to: Date())!,
        companyName: "Steamboat Co.",
        sharesVesting: 2500,
        estimatedValue: 127450.00,
        advisorRecommendation: nil,
        taxEstimate: nil
    ))
    .padding()
}
