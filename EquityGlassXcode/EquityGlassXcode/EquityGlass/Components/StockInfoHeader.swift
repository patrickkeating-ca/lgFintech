import SwiftUI

struct StockInfoHeader: View {
    let companyName: String
    let ticker: String
    let stockPrice: Double
    let lastUpdated: Date

    // Mock price change for demo
    private var priceChange: Double { 2.45 }
    private var percentChange: Double { (priceChange / (stockPrice - priceChange)) * 100 }
    private var isPositive: Bool { priceChange > 0 }
    private var changeColor: Color { isPositive ? .green : .red }

    var body: some View {
        HStack(alignment: .center) {
            // Ticker on left
            Text(ticker)
                .font(.headline)
                .foregroundStyle(.primary)

            Spacer()

            // Price info on right
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 8) {
                    Text("$\(stockPrice, specifier: "%.2f")")
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                        .monospacedDigit()

                    HStack(spacing: 4) {
                        Image(systemName: isPositive ? "arrow.up" : "arrow.down")
                            .font(.caption2)
                        Text("$\(abs(priceChange), specifier: "%.2f") (\(abs(percentChange), specifier: "%.2f")%)")
                            .font(.caption)
                            .monospacedDigit()
                    }
                    .foregroundStyle(changeColor)
                }

                Text("Updated \(lastUpdated, style: .relative) ago")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.primary.opacity(0.05), radius: 4, y: 2)
    }
}

#Preview {
    StockInfoHeader(
        companyName: "Steamboat Co",
        ticker: "STEAMBO",
        stockPrice: 112.18,
        lastUpdated: Calendar.current.date(byAdding: .hour, value: -3, to: Date())!
    )
    .padding()
}
