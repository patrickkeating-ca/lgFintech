import SwiftUI

/// Demo view for Sprint 1: Hero Feature (About This Plan + Advisor Conversation)
/// This demonstrates the advisor conversation context feature - the differentiating element for Disney pitch
struct VestExecutionDemoView: View {
    @State private var dataStore = DataStore()
    @State private var showVestDetailsModal = false
    @State private var showApprovalSheet = false
    @State private var showTimeline = false
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
                                // Approved state - View Trade Order button
                                Button(action: {
                                    // TODO: Show trade order details
                                    print("View Trade Order tapped")
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "doc.text.fill")
                                            .font(.title2)
                                            .foregroundStyle(.blue)

                                        Text("View Trade Order")
                                            .font(.headline)
                                            .foregroundStyle(.primary)

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.blue.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(Color.blue.opacity(0.2), lineWidth: 1)
                                    )
                                }
                                .padding(.horizontal, 20)

                                // Sprint 3: Execution Timeline (only shown after approval)
                                ExecutionTimelineCard(vest: vest)
                            }

                            // Sprint 6: Your Schwab Advisor
                            if let recommendation = vest.advisorRecommendation {
                                AdvisorContactCard(recommendation: recommendation)
                            }
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let vest = dataStore.vestEvent, let events = vest.timelineEvents, !events.isEmpty {
                        Button(action: {
                            showTimeline = true
                        }) {
                            Image(systemName: "calendar")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                }
            }
            .sheet(isPresented: $showTimeline) {
                if let vest = dataStore.vestEvent, let events = vest.timelineEvents {
                    TimelineSheetView(events: events, vestHistory: vest.vestHistory)
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

#Preview("Light Mode") {
    VestExecutionDemoView()
}

#Preview("Dark Mode") {
    VestExecutionDemoView()
        .preferredColorScheme(.dark)
}
