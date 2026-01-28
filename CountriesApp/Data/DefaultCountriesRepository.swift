
import Foundation

final class DefaultCountriesRepository: CountriesRepository {
    private let api: RestCountriesAPI

    init(api: RestCountriesAPI) {
        self.api = api
    }

    func fetchAllCountries() async throws -> [Country] {
        let dtos = try await api.fetchAllCountries()
        let countries = dtos.compactMap { $0.toDomain() }

        return countries.sorted { $0.commonName.localizedCaseInsensitiveCompare($1.commonName) == .orderedAscending }
    }
}

