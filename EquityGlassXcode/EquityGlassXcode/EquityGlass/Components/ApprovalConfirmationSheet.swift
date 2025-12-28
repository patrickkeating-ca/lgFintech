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

            // Execution details
            VStack(alignment: .leading, spacing: 12) {
                Text("\(vest.sharesVesting.formatted()) shares (RSU)")
                    .font(.headline)

                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.blue)
                    Text("Executes on \(vest.vestDate, style: .date)")
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
            }
            .padding(16)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Split breakdown
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
                .background(Color.green.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Sell
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
            }

            Spacer()

            // T&C disclaimer
            Text("By tapping Confirm Authorization, you agree to Schwab's Terms & Conditions for equity transactions.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            // Action buttons
            VStack(spacing: 12) {
                Button(action: {
                    submitPlan()
                }) {
                    Text("Confirm Authorization")
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

            // Success checkmark with ripple
            ZStack {
                // Expanding gradient ripple
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.green.opacity(0.6),
                                Color.green.opacity(0)
                            ],
                            startPoint: .center,
                            endPoint: .bottom
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 100 * successRipple, height: 100 * successRipple)
                    .opacity(1.0 - successRipple)

                // Checkmark circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.green.opacity(0.9), Color.green.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .green.opacity(0.4), radius: 12, y: 4)

                Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    successRipple = 1.5
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
                    Text("Executes on \(vest.vestDate, style: .date)")
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
