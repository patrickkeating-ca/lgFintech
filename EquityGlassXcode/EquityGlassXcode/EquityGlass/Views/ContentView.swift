import SwiftUI

struct ContentView: View {
    @State private var dataStore = DataStore()
    @State private var showConversation = false
    @State private var showTimeline = false

    var body: some View {
        NavigationStack {
            ZStack {
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()

            if dataStore.isLoading {
                loadingView
            } else if let error = dataStore.error {
                errorView(error)
            } else if let vest = dataStore.vestEvent {
                mainContent(vest)
            } else {
                emptyView
            }
        }
        .navigationTitle("Equity Vest")
        .navigationBarTitleDisplayMode(.large)
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
                TimelineSheetView(events: events)
            }
        }
        }
    }

    func mainContent(_ vest: VestEvent) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                // Scenario picker
                ScenarioPicker(selectedScenario: $dataStore.currentScenario) { scenario in
                    dataStore.loadScenario(scenario)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 8)

                // Stock info header
                StockInfoHeader(
                    companyName: vest.companyName,
                    ticker: vest.ticker,
                    stockPrice: vest.stockPrice,
                    lastUpdated: vest.stockPriceLastUpdated
                )
                .padding(.horizontal)

                // Privacy blur card
                VestCard(vest: vest)
                    .padding(.horizontal)

                // Advisor hero card (premium feature)
                if let recommendation = vest.advisorRecommendation {
                    AdvisorHeroCard(recommendation: recommendation, vest: vest) {
                        showConversation = true
                    }
                    .padding(.horizontal)
                }

                // Tax withholding layers
                if let taxEstimate = vest.taxEstimate {
                    TaxWithholdingLayers(taxEstimate: taxEstimate)
                        .padding(.horizontal)
                }

                Spacer(minLength: 40)
            }
        }
        .sheet(isPresented: $showConversation) {
            if let recommendation = vest.advisorRecommendation {
                AdvisorConversationView(recommendation: recommendation)
            }
        }
    }

    var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)

            Text("Loading...")
                .font(.headline)
        }
        .padding(32)
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 20)
    }

    func errorView(_ error: Error) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(.orange)

            Text("Error Loading Data")
                .font(.headline)

            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(action: {
                dataStore.loadVestEvent()
            }) {
                Text("Try Again")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(32)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 20)
        .padding()
    }

    var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("No Vest Data")
                .font(.headline)

            Text("Add vest-event.json to Resources/Data")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
    }
}

// MARK: - Timeline Sheet View
struct TimelineSheetView: View {
    let events: [TimelineEvent]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    TimelineCarouselView(events: events)
                        .padding(.top, 8)
                }
            }
            .navigationTitle("Upcoming Events")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
