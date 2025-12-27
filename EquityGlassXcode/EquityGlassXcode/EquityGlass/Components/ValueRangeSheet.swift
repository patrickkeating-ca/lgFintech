import SwiftUI
import Charts

struct ValueRangeSheet: View {
    let vest: VestEvent
    @Environment(\.dismiss) var dismiss
    @State private var selectedPrice: Double?
    @State private var showDataTable = false

    // Calculate price range (±10%)
    private var priceRange: [PricePoint] {
        let currentPrice = vest.stockPrice
        let minPrice = currentPrice * 0.9
        let maxPrice = currentPrice * 1.1
        let step = (maxPrice - minPrice) / 10

        return (0...10).map { i in
            let price = minPrice + (Double(i) * step)
            let grossValue = price * Double(vest.sharesVesting)
            let netValue = calculateNetValue(grossValue: grossValue)
            return PricePoint(stockPrice: price, netValue: netValue)
        }
    }

    // Calculate Y-axis range (round to nice increments)
    private var yAxisRange: ClosedRange<Double> {
        let maxNetValue = priceRange.map { $0.netValue }.max() ?? 0
        // Round up to nearest 50K
        let roundedMax = ceil(maxNetValue / 50000) * 50000
        return 0...roundedMax
    }

    private var currentPricePoint: PricePoint {
        let grossValue = vest.estimatedValue
        let netValue = calculateNetValue(grossValue: grossValue)
        return PricePoint(stockPrice: vest.stockPrice, netValue: netValue)
    }

    private func calculateNetValue(grossValue: Double) -> Double {
        guard let tax = vest.taxEstimate else { return grossValue }
        let totalTaxRate = tax.federalRate + tax.stateRate + tax.ficaRate
        return grossValue * (1 - totalTaxRate)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Intro text
                    VStack(alignment: .leading, spacing: 8) {
                        Text("VALUE RANGE SCENARIO")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .tracking(0.5)

                        Text("See how stock price changes affect your net value after taxes")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // Chart section
                    VStack(alignment: .leading, spacing: 16) {
                        // Chart
                        Chart {
                            // Area gradient (fintech green/teal)
                            ForEach(priceRange) { point in
                                AreaMark(
                                    x: .value("Price", point.stockPrice),
                                    y: .value("Net Value", point.netValue)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.green.opacity(0.25),
                                            Color.teal.opacity(0.15),
                                            Color.green.opacity(0.05)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }

                            // Line on top
                            ForEach(priceRange) { point in
                                LineMark(
                                    x: .value("Price", point.stockPrice),
                                    y: .value("Net Value", point.netValue)
                                )
                                .foregroundStyle(Color.green)
                                .lineStyle(StrokeStyle(lineWidth: 2.5))
                            }

                            // Current price marker at bottom
                            RuleMark(x: .value("Current", vest.stockPrice))
                                .foregroundStyle(Color.secondary.opacity(0.6))
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 3]))
                                .annotation(position: .bottom, alignment: .center, spacing: 4) {
                                    VStack(spacing: 2) {
                                        Image(systemName: "arrowtriangle.down.fill")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                        Text(vest.stockPrice, format: .currency(code: "USD"))
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 4)
                                    .background(Color(uiColor: .systemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .strokeBorder(Color.secondary.opacity(0.3), lineWidth: 1)
                                    )
                                }

                            // Selected point indicator with annotation
                            if let selectedPrice = selectedPrice,
                               let selectedPoint = priceRange.first(where: { abs($0.stockPrice - selectedPrice) < 1.0 }) {
                                PointMark(
                                    x: .value("Price", selectedPoint.stockPrice),
                                    y: .value("Net Value", selectedPoint.netValue)
                                )
                                .foregroundStyle(Color.green)
                                .symbolSize(120)
                                .annotation(position: .top, alignment: .center, spacing: 12) {
                                    VStack(spacing: 4) {
                                        Text(selectedPoint.stockPrice, format: .currency(code: "USD"))
                                            .font(.caption.bold())
                                            .foregroundColor(.primary)
                                        Text("Gross: \(selectedPoint.stockPrice * Double(vest.sharesVesting), format: .currency(code: "USD").precision(.fractionLength(0)))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text("Net: \(selectedPoint.netValue, format: .currency(code: "USD").precision(.fractionLength(0)))")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.primary)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color(uiColor: .systemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(Color.secondary.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: Color.primary.opacity(0.15), radius: 8, y: 4)
                                }
                            }
                        }
                        .frame(height: 280)
                        .chartXScale(domain: (vest.stockPrice * 0.9)...(vest.stockPrice * 1.1))
                        .chartYScale(domain: yAxisRange)
                        .chartXAxis {
                            AxisMarks(values: .automatic(desiredCount: 6)) { value in
                                AxisGridLine()
                                AxisValueLabel {
                                    if let price = value.as(Double.self) {
                                        Text(price, format: .currency(code: "USD").precision(.fractionLength(0)))
                                            .font(.caption2)
                                    }
                                }
                            }
                        }
                        .chartYAxis {
                            AxisMarks(values: .stride(by: 50000)) { value in
                                AxisGridLine()
                                AxisValueLabel {
                                    if let netValue = value.as(Double.self) {
                                        Text(netValue / 1000, format: .number.precision(.fractionLength(0)))
                                            .font(.caption2)
                                        + Text("K")
                                            .font(.caption2)
                                    }
                                }
                            }
                        }
                        .chartXAxisLabel("Stock Price at Vest", alignment: .center)
                        .chartYAxisLabel("Net Value After Taxes", alignment: .center)
                        .chartGesture { chart in
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let location = value.location
                                    if let price: Double = chart.value(atX: location.x) {
                                        // Clamp to our range
                                        let clampedPrice = max(vest.stockPrice * 0.9, min(vest.stockPrice * 1.1, price))
                                        selectedPrice = clampedPrice
                                    }
                                }
                                .onEnded { _ in
                                    // Keep selection visible
                                }
                        }

                        // Hint text (only when nothing selected)
                        if selectedPrice == nil {
                            Text("Tap anywhere on the chart to see values at different prices")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 8)
                        }
                    }

                    // Data table (expandable for accessibility)
                    VStack(alignment: .leading, spacing: 12) {
                        Button(action: {
                            withAnimation {
                                showDataTable.toggle()
                            }
                        }) {
                            HStack {
                                Text("View data table")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Image(systemName: showDataTable ? "chevron.up" : "chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)

                        if showDataTable {
                            VStack(spacing: 0) {
                                // Table header
                                HStack {
                                    Text("Stock Price")
                                        .font(.caption.bold())
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Net Value")
                                        .font(.caption.bold())
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.secondary.opacity(0.1))

                                Divider()

                                // Table rows
                                ForEach(priceRange) { point in
                                    HStack {
                                        Text(point.stockPrice, format: .currency(code: "USD"))
                                            .font(.body)
                                            .foregroundStyle(.primary)
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                        Text(point.netValue, format: .currency(code: "USD"))
                                            .font(.body.bold())
                                            .foregroundStyle(.primary)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(abs(point.stockPrice - vest.stockPrice) < 0.5 ? Color.blue.opacity(0.05) : Color.clear)

                                    if point.id != priceRange.last?.id {
                                        Divider()
                                    }
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(Color.secondary.opacity(0.2), lineWidth: 1)
                            )
                        }
                    }

                    // Disclaimer
                    Text("Illustrative range based on stock price variation. Actual value determined at vest. Based on \(vest.sharesVesting.formatted()) shares with estimated tax withholding.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(20)
            }
            .background(.ultraThinMaterial)
            .navigationTitle("Value Range Scenario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.caption)
                            Text("Back")
                                .font(.body)
                        }
                    }
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

// Model for price points
struct PricePoint: Identifiable {
    let id = UUID()
    let stockPrice: Double
    let netValue: Double
}

#Preview {
    Text("Background")
        .sheet(isPresented: .constant(true)) {
            ValueRangeSheet(
                vest: VestEvent(
                    id: UUID(),
                    vestDate: Calendar.current.date(byAdding: .day, value: 47, to: Date())!,
                    companyName: "Steamboat Co",
                    sharesVesting: 3430,
                    ticker: "STBT",
                    stockPrice: 112.18,
                    stockPriceLastUpdated: Date(),
                    estimatedValue: 384777.40,
                    advisorRecommendation: nil,
                    taxEstimate: TaxEstimate(
                        grossValue: 384777.40,
                        federalTax: 106583.34,
                        federalRate: 0.277,
                        stateTax: 42325.51,
                        stateRate: 0.11,
                        ficaTax: 5771.66,
                        ficaRate: 0.015
                    ),
                    timelineEvents: nil,
                    vestHistory: nil
                )
            )
        }
}
