import SwiftUI

struct ContentView: View {
    @State private var dataStore = DataStore()
    @State private var showConversation = false

    var body: some View {
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
    }

    func mainContent(_ vest: VestEvent) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                // App title
                Text("Equity Vest")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)

                // Scenario picker
                ScenarioPicker(selectedScenario: $dataStore.currentScenario) { scenario in
                    dataStore.loadScenario(scenario)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                // Privacy blur card
                VestCard(vest: vest)
                    .padding(.horizontal)

                // Split visualization
                if vest.advisorRecommendation != nil {
                    SplitVisualization(vest: vest) {
                        showConversation = true
                    }
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

#Preview {
    ContentView()
}
