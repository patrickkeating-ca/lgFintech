import Foundation
import Observation

@Observable
class DataStore {
    var vestEvent: VestEvent?
    var isLoading = false
    var error: Error?
    var currentScenario: Scenario = .alex

    init() {
        loadScenario(currentScenario)
    }

    func loadScenario(_ scenario: Scenario) {
        currentScenario = scenario
        isLoading = true
        error = nil

        guard let url = Bundle.main.url(forResource: scenario.fileName, withExtension: "json") else {
            error = NSError(domain: "DataStore", code: 404, userInfo: [NSLocalizedDescriptionKey: "\(scenario.fileName).json not found"])
            isLoading = false
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            vestEvent = try decoder.decode(VestEvent.self, from: data)
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }

    // Legacy method for backwards compatibility
    func loadVestEvent() {
        loadScenario(currentScenario)
    }
}
