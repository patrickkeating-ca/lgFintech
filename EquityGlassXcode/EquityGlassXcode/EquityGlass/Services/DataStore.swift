import Foundation
import Observation

@Observable
class DataStore {
    var vestEvent: VestEvent?
    var isLoading = false
    var error: Error?

    init() {
        loadVestEvent()
    }

    func loadVestEvent() {
        isLoading = true
        error = nil

        guard let url = Bundle.main.url(forResource: "vest-event", withExtension: "json") else {
            error = NSError(domain: "DataStore", code: 404, userInfo: [NSLocalizedDescriptionKey: "vest-event.json not found"])
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
}
