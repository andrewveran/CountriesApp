
import Foundation

protocol CountriesRepository {
    func fetchAllCountries() async throws -> [Country]
}
