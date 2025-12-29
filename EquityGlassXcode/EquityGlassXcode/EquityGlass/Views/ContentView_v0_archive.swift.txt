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
                TimelineSheetView(events: events, vestHistory: vest.vestHistory)
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
    let vestHistory: [VestHistoryItem]?
    @Environment(\.dismiss) private var dismiss
    @State private var expandedItemId: UUID? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Vest History Section
                    if let history = vestHistory, !history.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("VEST HISTORY")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 16)

                            VStack(spacing: 12) {
                                ForEach(history) { item in
                                    VestHistoryRow(
                                        item: item,
                                        isExpanded: expandedItemId == item.id,
                                        onTap: {
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                                                if expandedItemId == item.id {
                                                    expandedItemId = nil
                                                } else {
                                                    expandedItemId = item.id
                                                }
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.top, 8)
                    }

                    // Timeline Events Section
                    VStack(alignment: .leading, spacing: 12) {
                        if vestHistory != nil && !vestHistory!.isEmpty {
                            Text("UPCOMING EVENTS")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 16)
                        }

                        TimelineCarouselView(events: events)
                    }
                }
                .padding(.bottom, 16)
            }
            .navigationTitle(vestHistory != nil && !vestHistory!.isEmpty ? "Timeline & Performance" : "Upcoming Events")
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

// MARK: - Vest History Row (Progressive Disclosure)
struct VestHistoryRow: View {
    let item: VestHistoryItem
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Collapsed state (always visible)
            collapsedContent
                .contentShape(Rectangle())
                .onTapGesture {
                    let generator = UIImpactFeedbackGenerator(style: isExpanded ? .light : .medium)
                    generator.impactOccurred()
                    onTap()
                }

            // Expanded state (shows on tap)
            if isExpanded {
                expandedContent
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(
            color: .black.opacity(isExpanded ? 0.2 : 0.05),
            radius: isExpanded ? 16 : 4,
            y: isExpanded ? 8 : 2
        )
        .scaleEffect(isExpanded ? 1.02 : 1.0)
        .padding(.horizontal, 16)
        .zIndex(isExpanded ? 1 : 0)
    }

    var collapsedContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Date and shares
            HStack(spacing: 8) {
                Text(item.vestDate, format: .dateTime.month(.abbreviated).year())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("•")
                    .foregroundStyle(.tertiary)

                Text("\(item.shares) sh")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                // Expand indicator
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            // Gain/Loss label and amount
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(item.status == .sold ? "Realized Gain" : "Unrealized Gain")
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(item.gainLoss >= 0 ? "+" : "")\(item.gainLoss, format: .currency(code: "USD").precision(.fractionLength(0)))")
                        .font(.title3.bold())

                    HStack(spacing: 4) {
                        Text("\(item.gainLoss >= 0 ? "+" : "")\(item.gainLossPercentage, specifier: "%.1f")%")
                            .font(.subheadline.bold())

                        Image(systemName: item.status == .sold ? "checkmark" : "arrow.up.right")
                            .font(.caption2)
                    }
                }
                .foregroundStyle(item.isPositive ? .green : .red)
            }
        }
    }

    var expandedContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .padding(.vertical, 4)

            // Full date and status
            HStack {
                Text(item.vestDate, format: .dateTime.month(.wide).day().year())
                    .font(.headline)

                Spacer()

                Text(item.status.rawValue.uppercased())
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(item.status == .sold ? Color.blue.opacity(0.15) : Color.orange.opacity(0.15))
                    .foregroundStyle(item.status == .sold ? .blue : .orange)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }

            // Details grid
            VStack(spacing: 12) {
                detailRow(label: "Shares Vested", value: "\(item.shares)")
                detailRow(label: "Vest Price", value: item.vestPrice.formatted(.currency(code: "USD")))

                if let currentPrice = item.currentPrice, item.status == .held {
                    detailRow(label: "Current Price", value: currentPrice.formatted(.currency(code: "USD")))
                    let priceChange = currentPrice - item.vestPrice
                    let percentChange = (priceChange / item.vestPrice) * 100
                    detailRow(
                        label: "Price Change",
                        value: String(format: "%@$%.2f (%@%.1f%%)",
                                    priceChange >= 0 ? "+" : "",
                                    abs(priceChange),
                                    percentChange >= 0 ? "+" : "",
                                    percentChange),
                        highlighted: true
                    )
                }

                if let soldPrice = item.soldPrice, let soldDate = item.soldDate, item.status == .sold {
                    detailRow(label: "Sale Price", value: soldPrice.formatted(.currency(code: "USD")))
                    detailRow(label: "Sold On", value: soldDate.formatted(.dateTime.month(.wide).day().year()))
                    let priceChange = soldPrice - item.vestPrice
                    let percentChange = (priceChange / item.vestPrice) * 100
                    detailRow(
                        label: "Price Change",
                        value: String(format: "%@$%.2f (%@%.1f%%)",
                                    priceChange >= 0 ? "+" : "",
                                    abs(priceChange),
                                    percentChange >= 0 ? "+" : "",
                                    percentChange),
                        highlighted: true
                    )
                }
            }

            // Lot number if available
            if let lotNumber = item.lotNumber {
                Divider()

                detailRow(label: "Lot #", value: lotNumber)

                if item.status == .held {
                    detailRow(label: "Held Since", value: item.vestDate.formatted(.dateTime.month(.wide).day().year()))
                }
            }
        }
    }

    func detailRow(label: String, value: String, highlighted: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(highlighted ? .subheadline.bold() : .subheadline)
                .foregroundStyle(highlighted ? (item.isPositive ? .green : .red) : .primary)
        }
    }
}

#Preview {
    ContentView()
}
