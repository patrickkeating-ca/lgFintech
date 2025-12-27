import SwiftUI

struct VestDetailsSheet: View {
    let vest: VestEvent
    @Environment(\.dismiss) var dismiss
    @State private var showValueRange = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Estimate section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("ESTIMATE")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .tracking(0.5)

                        VStack(spacing: 12) {
                            HStack {
                                Text("Total Shares")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(vest.sharesVesting.formatted())")
                                    .font(.body.bold())
                                    .foregroundStyle(.primary)
                            }

                            HStack {
                                Text("Current Stock Price")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(vest.stockPrice, format: .currency(code: "USD"))
                                    .font(.body.bold())
                                    .foregroundStyle(.primary)
                                    .monospacedDigit()
                            }

                            Divider()

                            HStack {
                                Text("Estimated Gross Value")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(vest.estimatedValue, format: .currency(code: "USD"))
                                    .font(.title3.bold())
                                    .foregroundStyle(.primary)
                                    .monospacedDigit()
                            }
                        }

                        // Disclaimer
                        Text("Value will change based on stock price at vest date (\(vest.vestDate, style: .date)).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        // Value range explorer link
                        Button(action: {
                            showValueRange = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chart.xyaxis.line")
                                    .font(.subheadline)
                                    .foregroundStyle(.blue)
                                Text("See value range")
                                    .font(.subheadline)
                                    .foregroundStyle(.blue)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                            }
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                    }

                    // Tax withholding section
                    if let tax = vest.taxEstimate {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("ESTIMATED TAX WITHHOLDING")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .tracking(0.5)

                            VStack(spacing: 12) {
                                // Federal tax
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Federal Tax")
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                        Text("\(tax.federalRate * 100, specifier: "%.1f")%")
                                            .font(.caption)
                                            .foregroundStyle(.tertiary)
                                    }
                                    Spacer()
                                    Text(tax.federalTax, format: .currency(code: "USD"))
                                        .font(.body.bold())
                                        .foregroundStyle(.primary)
                                        .monospacedDigit()
                                }

                                // State tax
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("CA State Tax")
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                        Text("\(tax.stateRate * 100, specifier: "%.1f")%")
                                            .font(.caption)
                                            .foregroundStyle(.tertiary)
                                    }
                                    Spacer()
                                    Text(tax.stateTax, format: .currency(code: "USD"))
                                        .font(.body.bold())
                                        .foregroundStyle(.primary)
                                        .monospacedDigit()
                                }

                                // FICA tax
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("FICA")
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                        Text("\(tax.ficaRate * 100, specifier: "%.1f")%")
                                            .font(.caption)
                                            .foregroundStyle(.tertiary)
                                    }
                                    Spacer()
                                    Text(tax.ficaTax, format: .currency(code: "USD"))
                                        .font(.body.bold())
                                        .foregroundStyle(.primary)
                                        .monospacedDigit()
                                }

                                Divider()

                                // Net value
                                HStack {
                                    Text("Estimated Net Value")
                                        .font(.body.bold())
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Text(tax.netValue, format: .currency(code: "USD"))
                                        .font(.title3.bold())
                                        .foregroundStyle(.primary)
                                        .monospacedDigit()
                                }
                            }

                            // Tax disclaimer
                            Text("Tax withholding automatically deducted at vest. Consult tax advisor for specific situation.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .padding(20)
            }
            .background(.ultraThinMaterial)
            .navigationTitle("Vest Value Breakdown")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $showValueRange) {
            ValueRangeSheet(vest: vest)
        }
    }
}

#Preview {
    Text("Background Content")
        .sheet(isPresented: .constant(true)) {
            VestDetailsSheet(
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
