import SwiftUI

/// Main view for Equity Glass v1.0
/// Demonstrates vest execution flow with advisor recommendations and trade approval
struct ContentView: View {
    @State private var dataStore = DataStore()
    @State private var showVestDetailsModal = false
    @State private var showApprovalSheet = false
    @State private var showTimeline = false
    @State private var showTradeOrderSheet = false
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
                            // Vest Card (tappable for tax breakdown)
                            VestCard(
                                vest: vest,
                                onTap: {
                                    showVestDetailsModal = true
                                }
                            )

                            // Trade Recommendation
                            TradeRecommendationCard(vest: vest)

                            // Approval Buttons
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
                                    showTradeOrderSheet = true
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

                                // Execution Timeline (only shown after approval)
                                ExecutionTimelineCard(vest: vest)
                            }

                            // Your Schwab Advisor
                            if let recommendation = vest.advisorRecommendation {
                                AdvisorContactCard(recommendation: recommendation)
                            }
                        } else {
                            // Loading or error state
                            VStack(spacing: 12) {
                                ProgressView()
                                Text("Loading vest data...")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 300)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Equity Glass")
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
            .sheet(isPresented: $showTradeOrderSheet) {
                if let vest = dataStore.vestEvent {
                    ViewTradeOrderSheet(vest: vest)
                }
            }
        }
        .onAppear {
            dataStore.loadScenario(.alex)
        }
    }
}

// MARK: - Timeline Sheet View
struct TimelineSheetView: View {
    let events: [TimelineEvent]
    let vestHistory: [VestHistoryItem]?
    @Environment(\.dismiss) private var dismiss

    // Filter events within 90 days
    private var eventsWithin90Days: [TimelineEvent] {
        events.filter { $0.daysUntil <= 90 && !$0.isPast }
            .sorted { $0.date < $1.date }
    }

    // Events beyond 90 days
    private var eventsBeyond90Days: [TimelineEvent] {
        events.filter { $0.daysUntil > 90 }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Upcoming Events Section (now first)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("UPCOMING EVENTS")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)

                        // TabView with page style for swipeable cards with dots
                        TabView {
                            // Events within 90 days
                            ForEach(eventsWithin90Days) { event in
                                TimelineCardView(event: event)
                                    .padding(.horizontal, 16)
                            }

                            // Future events list card (if any events beyond 90 days)
                            if !eventsBeyond90Days.isEmpty {
                                FutureEventsCard(events: eventsBeyond90Days)
                                    .padding(.horizontal, 16)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                        .frame(height: 280)
                    }
                    .padding(.top, 8)

                    // Vest History Section (now condensed table)
                    if let history = vestHistory, !history.isEmpty {
                        VestHistoryTableView(history: history)
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

// MARK: - Future Events Card (90+ days)
struct FutureEventsCard: View {
    let events: [TimelineEvent]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: "calendar.badge.clock")
                .font(.title2)
                .foregroundStyle(.blue)

            Text("Future Events")
                .font(.title3.bold())

            Text("Events scheduled 90+ days out")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(events) { event in
                        HStack(spacing: 8) {
                            Image(systemName: event.type.icon)
                                .font(.system(size: 12))
                                .foregroundStyle(eventColor(for: event.type))
                                .frame(width: 20, height: 20)
                                .background(eventColor(for: event.type).opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 4))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(event.title)
                                    .font(.caption.bold())
                                    .foregroundStyle(.primary)
                                Text(event.date, style: .date)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text("\(event.daysUntil)d")
                                .font(.caption2.monospacedDigit())
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.primary.opacity(0.1), radius: 10, y: 5)
    }

    // Match equity type badge colors
    private func eventColor(for type: EventType) -> Color {
        switch type {
        case .vest: return .blue // RSU
        case .esppPurchase: return .purple // ESPP
        case .performanceReview: return .orange // PSU (performance-related)
        default:
            // Fallback to original color mapping
            switch type.color {
            case "blue": return .blue
            case "green": return .green
            case "orange": return .orange
            case "red": return .red
            case "purple": return .purple
            case "yellow": return .yellow
            case "gray": return .gray
            case "cyan": return .cyan
            default: return .blue
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

// MARK: - Vest History Table View
struct VestHistoryTableView: View {
    let history: [VestHistoryItem]

    // Detect consistent split pattern
    private var detectedSplitPattern: String? {
        // TODO: Implement split pattern detection when model includes split percentages
        // For now, placeholder logic
        return nil // e.g., "70/30" if consistent pattern found
    }

    // Sort latest first (reverse chronological)
    private var sortedHistory: [VestHistoryItem] {
        history.sorted { $0.vestDate > $1.vestDate }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with subtle split pattern indicator
            HStack {
                Text("VEST HISTORY")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)

                if let pattern = detectedSplitPattern {
                    Text("•")
                        .foregroundStyle(.tertiary)
                    Text("Strategy: \(pattern)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)

            // Condensed table
            VStack(spacing: 0) {
                // Table header
                HStack(spacing: 6) {
                    Text("Date")
                        .frame(width: 55, alignment: .leading)
                    Text("Type")
                        .frame(width: 45, alignment: .leading)
                    Text("Split")
                        .frame(width: 50, alignment: .center)
                    Spacer()
                    Text("Realized")
                        .frame(width: 65, alignment: .trailing)
                    Text("Unrealized")
                        .frame(width: 75, alignment: .trailing)
                }
                .font(.caption2.bold())
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.quaternary.opacity(0.5))

                // Table rows (latest first)
                ForEach(Array(sortedHistory.enumerated()), id: \.element.id) { index, item in
                    VestHistoryTableRow(item: item)

                    if index < sortedHistory.count - 1 {
                        Divider()
                            .padding(.leading, 12)
                    }
                }
            }
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.white.opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Vest History Table Row
struct VestHistoryTableRow: View {
    let item: VestHistoryItem

    var body: some View {
        HStack(spacing: 6) {
            // Date (abbreviated)
            Text(item.vestDate.formatted(.dateTime.month(.abbreviated).year(.twoDigits)))
                .font(.caption)
                .frame(width: 55, alignment: .leading)

            // Type badge
            Text(item.type?.rawValue ?? "RSU")
                .font(.caption2.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(vestTypeBadgeColor)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .frame(width: 45, alignment: .leading)

            // Split (e.g., "70H/30S" or "100S" or "100H")
            Text(item.splitDisplay)
                .font(.caption2.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(width: 50, alignment: .center)

            Spacer(minLength: 4)

            // Realized G/L (for sold portion)
            if let realized = item.realizedGainLoss {
                Text(realized, format: .currency(code: "USD").precision(.fractionLength(0)))
                    .font(.caption.bold().monospacedDigit())
                    .foregroundStyle(realized >= 0 ? .green : .red)
                    .frame(width: 65, alignment: .trailing)
            } else {
                Text("—")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .frame(width: 65, alignment: .trailing)
            }

            // Unrealized G/L (for held portion)
            if let unrealized = item.unrealizedGainLoss {
                Text(unrealized, format: .currency(code: "USD").precision(.fractionLength(0)))
                    .font(.caption.bold().monospacedDigit())
                    .foregroundStyle(unrealized >= 0 ? .green : .red)
                    .frame(width: 75, alignment: .trailing)
            } else {
                Text("—")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .frame(width: 75, alignment: .trailing)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    private var vestTypeBadgeColor: Color {
        switch item.type {
        case .RSU: return .blue
        case .ESPP: return .purple
        case .PSU: return .orange
        case .none: return .blue
        }
    }
}

#Preview {
    ContentView()
}
