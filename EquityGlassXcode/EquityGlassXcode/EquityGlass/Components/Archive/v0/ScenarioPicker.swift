import SwiftUI

struct ScenarioPicker: View {
    @Binding var selectedScenario: Scenario
    let onScenarioChange: (Scenario) -> Void

    var body: some View {
        Menu {
            ForEach(Scenario.allCases) { scenario in
                Button(action: {
                    selectedScenario = scenario
                    onScenarioChange(scenario)
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(scenario.rawValue)
                            .font(.headline)
                        Text(scenario.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedScenario.rawValue)
                        .font(.headline)
                    Text(selectedScenario.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Image(systemName: "chevron.down.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.blue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    ScenarioPicker(
        selectedScenario: .constant(.alex),
        onScenarioChange: { _ in }
    )
}
