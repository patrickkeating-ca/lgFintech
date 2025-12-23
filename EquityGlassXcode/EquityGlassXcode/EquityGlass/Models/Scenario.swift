import Foundation

enum Scenario: String, CaseIterable, Identifiable {
    case marcus = "Marcus Rodriguez"
    case alex = "Alex Chen"

    var id: String { rawValue }

    var fileName: String {
        switch self {
        case .marcus: return "scenario-marcus"
        case .alex: return "scenario-alex"
        }
    }

    var subtitle: String {
        switch self {
        case .marcus: return "IT Manager • Steamboat Co"
        case .alex: return "VP Content Strategy • Steamboat Co"
        }
    }
}
