
import Foundation

struct RestCountriesAPI {
    enum APIError: Error { case invalidURL, badStatus(Int) }

    private let session: URLSession
    private let baseURL = Constants.API.baseURL
    private let maxFieldsPerRequest = Constants.API.maxFieldsPerRequest
    private let retryCount = Constants.API.retryCount

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchAllCountries() async throws -> [CountryDTO] {
        let baseFields = Constants.API.baseFields
        let extraFields = Constants.API.extraFields

        let baseURL = try makeURL(fields: baseFields)
        let extraURL = try makeURL(fields: extraFields)

        async let baseData = fetchData(from: baseURL, label: "base")
        async let extraData = fetchData(from: extraURL, label: "extra")

        let baseDTOs = try JSONDecoder().decode([CountryDTO].self, from: try await baseData)
        let extraDTOs = try JSONDecoder().decode([CountryDTO].self, from: try await extraData)

        let extrasByID: [String: CountryDTO] = Dictionary(
            uniqueKeysWithValues: extraDTOs.compactMap { dto in
                guard let id = dto.cca3 else { return nil }
                return (id, dto)
            }
        )

        return baseDTOs.map { dto in
            guard let id = dto.cca3, let extra = extrasByID[id] else { return dto }
            return CountryDTO(
                cca3: dto.cca3,
                name: dto.name,
                flags: dto.flags,
                capital: dto.capital,
                region: dto.region,
                subregion: dto.subregion,
                timezones: dto.timezones,
                population: dto.population,
                languages: dto.languages,
                currencies: dto.currencies,
                car: extra.car ?? dto.car,
                coatOfArms: extra.coatOfArms ?? dto.coatOfArms
            )
        }
    }

    private func makeURL(fields: [String]) throws -> URL {
        guard fields.count <= maxFieldsPerRequest else { throw APIError.invalidURL }
        var components = URLComponents(url: baseURL.appendingPathComponent("all"), resolvingAgainstBaseURL: true)
        components?.queryItems = [
            .init(name: "fields", value: fields.joined(separator: ","))
        ]
        guard let url = components?.url else { throw APIError.invalidURL }
        return url
    }

    private func fetchData(from url: URL, label: String) async throws -> Data {
        var lastError: Error?

        for attempt in 1...retryCount {
            print("[\(Constants.API.logPrefix)] \(label) attempt \(attempt)/\(retryCount)")

            do {
                let (data, response) = try await session.data(from: url)
                if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                    throw APIError.badStatus(http.statusCode)
                }
                return data
            } catch {
                lastError = error

                if attempt < retryCount, shouldRetry(error) {
                    let delayMs = 500 * attempt
                    try? await Task.sleep(nanoseconds: UInt64(delayMs) * 1_000_000)
                    continue
                }

                throw error
            }
        }

        throw lastError ?? APIError.badStatus(500)
    }

    private func shouldRetry(_ error: Error) -> Bool {
        if let apiError = error as? APIError {
            switch apiError {
            case .badStatus(let code):
                return (500...599).contains(code)
            case .invalidURL:
                return false
            }
        }

        let nsError = error as NSError
        return nsError.domain == NSURLErrorDomain
    }
}
