import SwiftUI

/// Demo view for Sprint 1: Hero Feature (About This Plan + Advisor Conversation)
/// This demonstrates the advisor conversation context feature - the differentiating element for Disney pitch
struct VestExecutionDemoView: View {
    @State private var dataStore = DataStore()
    @State private var showConversationModal = false
    @State private var showVestDetailsModal = false
    @State private var showApprovalSheet = false
    @State private var planApproved = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient for visual depth
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        if let vest = dataStore.vestEvent {
                            // Sprint 2: Vest Card (tappable for tax breakdown)
                            VestCard(
                                vest: vest,
                                onTap: {
                                    showVestDetailsModal = true
                                }
                            )

                            // Sprint 1: About This Plan Card
                            if let recommendation = vest.advisorRecommendation {
                                AboutThisPlanCard(
                                    recommendation: recommendation,
                                    onTapAttribution: {
                                        showConversationModal = true
                                    }
                                )
                            }

                            // Sprint 3: Execution Timeline
                            ExecutionTimelineCard(vest: vest)

                            // Sprint 4: Trade Recommendation
                            TradeRecommendationCard(vest: vest)

                            // Sprint 5: Approval Buttons
                            if !planApproved {
                                ApprovalButtons(
                                    vest: vest,
                                    onApprove: {
                                        showApprovalSheet = true
                                    },
                                    onRequestChanges: {
                                        // TODO: Implement request changes flow
                                        print("Request changes tapped")
                                    }
                                )
                            } else {
                                // Approved state
                                VStack(spacing: 12) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title2)
                                            .foregroundStyle(.green)

                                        Text("Plan Approved")
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                    }

                                    Text("Your plan will execute on \(vest.vestDate, format: .dateTime.month(.abbreviated).day())")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.green.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal, 20)
                            }

                            // Placeholder for future components
                            Text("Future components will appear below:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 40)

                            VStack(alignment: .leading, spacing: 12) {
                                Label("Advisor Contact", systemImage: "circle")
                                    .foregroundStyle(.tertiary)
                            }
                            .font(.subheadline)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            // Loading or error state
                            VStack(spacing: 12) {
                                ProgressView()
                                Text("Loading Alex's data...")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 300)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Vest Execution (Sprint 1-5)")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showConversationModal) {
                if let recommendation = dataStore.vestEvent?.advisorRecommendation {
                    AdvisorConversationView(recommendation: recommendation)
                }
            }
            .sheet(isPresented: $showVestDetailsModal) {
                if let vest = dataStore.vestEvent {
                    VestDetailsSheet(vest: vest)
                }
            }
            .sheet(isPresented: $showApprovalSheet) {
                if let vest = dataStore.vestEvent {
                    ApprovalConfirmationSheet(vest: vest) {
                        planApproved = true
                    }
                }
            }
        }
        .onAppear {
            dataStore.loadScenario(.alex)
        }
    }
}

#Preview {
    VestExecutionDemoView()
}
