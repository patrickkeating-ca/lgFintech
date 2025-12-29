import SwiftUI

struct ApprovalConfirmationSheet: View {
    let vest: VestEvent
    let onConfirm: () -> Void
    @Environment(\.dismiss) var dismiss

    @State private var approvalState: ApprovalState = .confirmation
    @State private var animateIn = false
    @State private var spinnerRotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var successRipple: CGFloat = 0
    @State private var dismissing = false
    @State private var floatOffset: CGFloat = 0
    @State private var glowPulse: CGFloat = 1.0
    @State private var shimmerOffset: CGFloat = -200

    enum ApprovalState {
        case confirmation
        case submitting
        case success
    }

    var body: some View {
        ZStack {
            // Background blur
            Color.clear
                .background(.ultraThinMaterial)
                .ignoresSafeArea()

            Group {
                switch approvalState {
                case .confirmation:
                    confirmationView
                case .submitting:
                    submittingView
                case .success:
                    successView
                }
            }
            .opacity(animateIn ? 1 : 0)
            .scaleEffect(animateIn ? 1 : 0.95)
            .blur(radius: animateIn ? 0 : 10)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                animateIn = true
            }
        }
    }

    // MARK: - Confirmation View

    var confirmationView: some View {
        VStack(spacing: 24) {
            // Header
            Text("Review Trade Plan")
                .font(.title2.bold())

            // VEST section (automatic)
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("VEST")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("Automatic")
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.secondary.opacity(0.6))
                        .clipShape(Capsule())
                }

                Text("\(vest.sharesVesting.formatted()) shares (RSU)")
                    .font(.headline)

                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.secondary)
                    Text(vest.vestDate, style: .date)
                        .font(.subheadline)
                    Spacer()
                }

                HStack(spacing: 6) {
                    Image(systemName: "arrow.right")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    Text("Schwab Brokerage ...328")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.secondary.opacity(0.2), lineWidth: 1)
            )

            // Frosted glass divider
            VStack(spacing: 8) {
                HStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .frame(height: 1)
                        .overlay(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.3),
                                    Color.cyan.opacity(0.2),
                                    Color.blue.opacity(0.3)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }

                Text("YOUR TRADE PLAN")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .tracking(0.5)
            }

            // Trade plan breakdown
            VStack(spacing: 12) {
                // Hold
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("HOLD")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(vest.holdShares.formatted()) shares")
                            .font(.title3.bold())
                            .foregroundStyle(.green)
                    }

                    Text("Remain in brokerage account")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(16)
                .background(Color.green.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.green.opacity(0.2),
                                    Color.green.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )

                // Sell (with subtle glow - needs authorization)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("SELL")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(vest.sellShares.formatted()) shares")
                            .font(.title3.bold())
                            .foregroundStyle(.blue)
                    }

                    HStack {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundStyle(.blue)
                        Text("\(executionDate, style: .date), market open")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "arrow.right")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        Text("Checking Acct ...582")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(16)
                .background(Color.blue.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.4),
                                    Color.cyan.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: .blue.opacity(0.15), radius: 8, y: 2)
            }

            Spacer()

            // T&C disclaimer
            Text("By tapping Submit, you agree to Schwab's Terms & Conditions for equity transactions.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            // Action buttons
            VStack(spacing: 12) {
                Button(action: {
                    submitPlan()
                }) {
                    Text("Submit")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary.opacity(0.2))
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(24)
        .frame(maxWidth: 400)
    }

    // MARK: - Submitting View

    var submittingView: some View {
        VStack(spacing: 24) {
            // Liquid Glass spinner
            ZStack {
                // Pulsing gradient ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.green.opacity(0.8),
                                Color.blue.opacity(0.8),
                                Color.green.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(spinnerRotation))
                    .scaleEffect(pulseScale)
                    .shadow(color: .green.opacity(0.3), radius: 8, y: 0)

                // Inner frosted circle
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 60, height: 60)

                // Icon
                Image(systemName: "bolt.fill")
                    .font(.title)
                    .foregroundStyle(.green)
            }
            .onAppear {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    spinnerRotation = 360
                }
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    pulseScale = 1.15
                }
            }

            Text("Submitting plan...")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }

    // MARK: - Success View

    var successView: some View {
        VStack(spacing: 24) {
            Spacer()

            // Success checkmark with liquid glass effects
            ZStack {
                // Outer expanding ripple (multiple waves)
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.green.opacity(0.4),
                                    Color.green.opacity(0)
                                ],
                                startPoint: .center,
                                endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                        .frame(
                            width: 100 * successRipple + CGFloat(index) * 20,
                            height: 100 * successRipple + CGFloat(index) * 20
                        )
                        .opacity(max(0, 1.0 - successRipple - CGFloat(index) * 0.2))
                }

                // Pulsing outer glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.green.opacity(0.3),
                                Color.green.opacity(0.1),
                                Color.green.opacity(0)
                            ],
                            center: .center,
                            startRadius: 30,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(glowPulse)
                    .blur(radius: 8)

                // Frosted glass inner layer
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 84, height: 84)
                    .overlay(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .shadow(color: .green.opacity(0.3), radius: 8, y: 0)

                // Main checkmark circle with gradient
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.green.opacity(0.95),
                                Color.green.opacity(0.75)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .green.opacity(0.5), radius: 16, y: 4)
                    .shadow(color: .green.opacity(0.3), radius: 24, y: 8)

                // Shimmer overlay
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.6),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 40, height: 100)
                    .rotationEffect(.degrees(-45))
                    .offset(x: shimmerOffset)
                    .mask(
                        Circle()
                            .frame(width: 80, height: 80)
                    )

                // Checkmark icon
                Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
            }
            .offset(y: floatOffset)
            .onAppear {
                // Expanding ripple
                withAnimation(.easeOut(duration: 0.8)) {
                    successRipple = 1.5
                }

                // Shimmer sweep (one-time)
                withAnimation(.easeInOut(duration: 1.0).delay(0.3)) {
                    shimmerOffset = 200
                }

                // Gentle floating
                withAnimation(
                    .easeInOut(duration: 2.5)
                    .repeatForever(autoreverses: true)
                ) {
                    floatOffset = -8
                }

                // Glow pulse
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                ) {
                    glowPulse = 1.2
                }
            }

            VStack(spacing: 8) {
                Text("Trade Plan Submitted")
                    .font(.title2.bold())

                Text("Order #: \(orderNumber)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("Submitted: \(currentTime)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            // Details
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.blue)
                    Text("Executes on \(executionDate, style: .date)")
                        .font(.subheadline)
                    Spacer()
                }

                HStack {
                    Image(systemName: "clock")
                        .foregroundStyle(.blue)
                    Text("Market open")
                        .font(.subheadline)
                    Spacer()
                }

                Divider()

                HStack {
                    Text("Hold:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(vest.holdShares.formatted()) shares")
                        .font(.subheadline.bold())
                }

                HStack {
                    Text("Sell:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(vest.sellShares.formatted()) shares")
                        .font(.subheadline.bold())
                }
            }
            .padding(16)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()

            // Close button
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    dismissing = true
                }

                // Dismiss after animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    dismiss()
                }
            }) {
                Text("Close")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(24)
        .frame(maxWidth: 400)
        .offset(y: dismissing ? -30 : 0)
        .blur(radius: dismissing ? 20 : 0)
        .opacity(dismissing ? 0 : 1)
    }

    // MARK: - Actions

    private func submitPlan() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            approvalState = .submitting
        }

        // Simulate 2 second submission
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                approvalState = .success
            }

            // Notify that plan was approved
            onConfirm()
        }
    }

    // MARK: - Helper Properties

    private var orderNumber: String {
        "SCH-2026-\(String(format: "%06d", Int.random(in: 100000...999999)))"
    }

    private var currentTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }

    // Execution date is 21 days after vest date (matches ExecutionTimelineCard)
    private var executionDate: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 21, to: vest.vestDate) ?? vest.vestDate
    }
}

#Preview {
    Text("Background")
        .sheet(isPresented: .constant(true)) {
            ApprovalConfirmationSheet(
                vest: VestEvent(
                    id: UUID(),
                    vestDate: Calendar.current.date(byAdding: .day, value: 47, to: Date())!,
                    companyName: "Steamboat Co",
                    sharesVesting: 3430,
                    ticker: "STBT",
                    stockPrice: 112.18,
                    stockPriceLastUpdated: Date(),
                    estimatedValue: 384777.40,
                    advisorRecommendation: AdvisorRecommendation(
                        advisorName: "Fred",
                        advisorFullName: "Fred Amsden",
                        advisorTitle: "Senior Wealth Advisor",
                        advisorCredentials: "CFP®",
                        advisorCompany: "Schwab Private Client",
                        advisorPhone: "(650) 555-1212",
                        advisorPhotoAsset: "AdvisorAvatar",
                        conversationDate: Date(),
                        conversationDuration: 22,
                        discussionPoints: [],
                        recommendationText: "Execute 70/30 split",
                        holdPercentage: 0.70,
                        sellPercentage: 0.30
                    ),
                    taxEstimate: nil,
                    timelineEvents: nil,
                    vestHistory: nil
                ),
                onConfirm: { print("Plan approved!") }
            )
        }
}
