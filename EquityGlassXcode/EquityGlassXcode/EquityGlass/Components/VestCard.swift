import SwiftUI
import LocalAuthentication

struct VestCard: View {
    let vest: VestEvent


    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            Text("UPCOMING VEST")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Company name
            Text(vest.companyName)
                .font(.title2.bold())

            // Vest date and countdown
            HStack {
                Text(vest.vestDate, style: .date)
                    .font(.subheadline)
                Text("•")
                    .foregroundStyle(.secondary)
                Text("\(vest.daysUntilVest) days")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Divider()
                .padding(.vertical, 4)

            // Share count (always visible)
            Text("\(vest.sharesVesting.formatted()) shares")
                .font(.headline)

            // Dollar amount (always visible)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(vest.estimatedValue, format: .currency(code: "USD"))")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .contentTransition(.numericText(value: vest.estimatedValue))
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Disclaimer
                Text("Amount may change based on stock price")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }


        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)


        .accessibilityElement(children: .combine)
        .accessibilityLabel("Vest amount: \(vest.estimatedValue.formatted(.currency(code: "USD")))")
        .accessibilityHint("")
    }




}

#Preview {
    VestCard(vest: VestEvent(
        id: UUID(),
        vestDate: Calendar.current.date(byAdding: .day, value: 47, to: Date())!,
        companyName: "Steamboat Co.",
        sharesVesting: 2500,
        estimatedValue: 127450.00,
        advisorRecommendation: nil,
        taxEstimate: nil
    ))
    .padding()
}
