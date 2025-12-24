import SwiftUI

struct StockInfoHeader: View {
    let companyName: String
    let ticker: String
    let stockPrice: Double
    let lastUpdated: Date

    var body: some View {
        VStack(spacing: 12) {
            // Company name and ticker
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(companyName)
                    .font(.title2.bold())
                    .foregroundStyle(.primary)

                Text(ticker)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.regularMaterial)
                    .clipShape(Capsule())
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Stock price
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("$\(stockPrice, specifier: "%.2f")")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .monospacedDigit()

                VStack(alignment: .leading, spacing: 2) {
                    Text("per share")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("Updated \(lastUpdated, style: .relative) ago")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
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
