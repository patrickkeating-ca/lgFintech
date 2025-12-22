import SwiftUI

struct TaxWithholdingLayers: View {
    let taxEstimate: TaxEstimate
    @State private var expandedLayer: TaxLayer? = nil

    enum TaxLayer: String, CaseIterable {
        case gross = "Gross Value"
        case federal = "Federal Tax"
        case state = "State Tax"
        case fica = "FICA"
        case net = "Net After Taxes"

        var icon: String {
            switch self {
            case .gross: return "arrow.up.circle.fill"
            case .federal: return "building.columns.fill"
            case .state: return "map.fill"
            case .fica: return "heart.circle.fill"
            case .net: return "checkmark.circle.fill"
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tax Withholding Breakdown")
                .font(.title2.bold())
                .padding(.bottom, 4)

            VStack(spacing: 8) {
                // Gross value (starting point)
                layerCard(
                    layer: .gross,
                    amount: taxEstimate.grossValue,
                    percentage: nil,
                    isDeduction: false
                )

                // Federal tax
                layerCard(
                    layer: .federal,
                    amount: taxEstimate.federalTax,
                    percentage: taxEstimate.federalRate,
                    isDeduction: true
                )

                // State tax (only if > 0)
                if taxEstimate.stateTax > 0 {
                    layerCard(
                        layer: .state,
                        amount: taxEstimate.stateTax,
                        percentage: taxEstimate.stateRate,
                        isDeduction: true
                    )
                }

                // FICA
                layerCard(
                    layer: .fica,
                    amount: taxEstimate.ficaTax,
                    percentage: taxEstimate.ficaRate,
                    isDeduction: true
                )

                Divider()
                    .padding(.vertical, 4)

                // Net value (final result)
                layerCard(
                    layer: .net,
                    amount: taxEstimate.netValue,
                    percentage: nil,
                    isDeduction: false
                )
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    func layerCard(
        layer: TaxLayer,
        amount: Double,
        percentage: Double?,
        isDeduction: Bool
    ) -> some View {
        let isExpanded = expandedLayer == layer

        VStack(alignment: .leading, spacing: isExpanded ? 12 : 6) {
            HStack {
                Image(systemName: layer.icon)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(layer.rawValue)
                        .font(layer == .gross || layer == .net ? .headline.bold() : .subheadline)
                        .foregroundStyle(layer == .gross || layer == .net ? .primary : .secondary)

                    if let percentage = percentage {
                        Text("\(Int(percentage * 100))% rate")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }

                Spacer()

                Text("\(isDeduction ? "-" : "")~\(amount.formatted(.currency(code: "USD")))")
                    .font(layer == .gross || layer == .net ? .title3.bold() : .body)
                    .foregroundStyle(.primary)
            }

            if isExpanded {
                expandedContent(for: layer)
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
            color: .black.opacity(isExpanded ? 0.2 : 0),
            radius: isExpanded ? 12 : 2,
            x: 0,
            y: isExpanded ? 4 : 1
        )
        .scaleEffect(isExpanded ? 1.02 : 1.0)
        .zIndex(isExpanded ? 1 : 0)
        .animation(.smooth(duration: 0.4), value: isExpanded)
        .onTapGesture {
            withAnimation(.smooth(duration: 0.4)) {
                if expandedLayer == layer {
                    expandedLayer = nil
                } else {
                    expandedLayer = layer
                }
            }
        }
    }

    @ViewBuilder
    func expandedContent(for layer: TaxLayer) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            switch layer {
            case .gross:
                Text("Total value of shares vesting based on current estimated price. This is the amount that will be added to your W-2 as income.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

            case .federal:
                VStack(alignment: .leading, spacing: 4) {
                    Text("Federal income tax withheld at vest. Your actual tax liability may differ based on your total annual income.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack {
                        Text("Withholding rate:")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        Text("\(Int(taxEstimate.federalRate * 100))%")
                            .font(.caption2.bold())
                            .foregroundStyle(.secondary)
                    }
                }

            case .state:
                VStack(alignment: .leading, spacing: 4) {
                    Text("State income tax withheld. Varies by state - some states have no income tax.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack {
                        Text("Withholding rate:")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        Text("\(Int(taxEstimate.stateRate * 100))%")
                            .font(.caption2.bold())
                            .foregroundStyle(.secondary)
                    }
                }

            case .fica:
                VStack(alignment: .leading, spacing: 4) {
                    Text("Social Security and Medicare taxes. Rate may vary if you've exceeded Social Security wage base.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack {
                        Text("Withholding rate:")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        Text("\(Int(taxEstimate.ficaRate * 100))%")
                            .font(.caption2.bold())
                            .foregroundStyle(.secondary)
                    }
                }

            case .net:
                Text("Amount available after all tax withholdings. This is the cash you'll actually receive, minus any shares sold to cover taxes.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.top, 4)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            // Alex's scenario (with state tax)
            TaxWithholdingLayers(taxEstimate: TaxEstimate(
                grossValue: 175000,
                federalTax: 48475,
                federalRate: 0.277,
                stateTax: 19250,
                stateRate: 0.11,
                ficaTax: 2625,
                ficaRate: 0.015
            ))

            // Marcus's scenario (no state tax)
            TaxWithholdingLayers(taxEstimate: TaxEstimate(
                grossValue: 30600,
                federalTax: 7344,
                federalRate: 0.24,
                stateTax: 0,
                stateRate: 0,
                ficaTax: 459,
                ficaRate: 0.015
            ))
        }
        .padding()
    }
    .background(.black)
}
