
import Foundation

struct CountryDTO: Decodable {
    struct Name: Decodable {
        let common: String?
        let official: String?
    }

    struct Flags: Decodable {
        let png: String?
        let svg: String?
        let alt: String?
    }

    struct CoatOfArms: Decodable {
        let png: String?
        let svg: String?
    }

    struct Car: Decodable {
        let side: String?
    }

    struct CurrencyInfo: Decodable {
        let name: String?
        let symbol: String?
    }

    let cca3: String?
    let name: Name?
    let flags: Flags?
    let capital: [String]?
    let region: String?
    let subregion: String?
    let timezones: [String]?
    let population: Int?
    let languages: [String: String]?
    let currencies: [String: CurrencyInfo]?
    let car: Car?
    let coatOfArms: CoatOfArms?
}

extension CountryDTO {
    func toDomain() -> Country? {
        guard let id = cca3, !id.isEmpty else { return nil }

        let common = name?.common?.trimmingCharacters(in: .whitespacesAndNewlines)
        let official = name?.official?.trimmingCharacters(in: .whitespacesAndNewlines)

        let commonName = (common?.isEmpty == false) ? common! : String(localized: "country.unknown")
        let officialName = (official?.isEmpty == false) ? official! : commonName

        let flagURL = URL(string: flags?.png ?? "")
        let coatURL = URL(string: coatOfArms?.png ?? "")

        let langs = languages?.values.sorted() ?? []
        let currencyStrings = CountryDTO.formatCurrencies(currencies)

        return Country(
            id: id,
            commonName: commonName,
            officialName: officialName,
            flagPNGURL: flagURL,
            region: region,
            subregion: subregion,
            capital: capital ?? [],
            timezones: timezones ?? [],
            population: population,
            languages: langs,
            currencies: currencyStrings,
            carDriveSide: car?.side,
            coatOfArmsPNGURL: coatURL
        )
    }

    private static func formatCurrencies(_ dict: [String: CurrencyInfo]?) -> [String] {
        guard let dict else { return [] }
        return dict
            .sorted(by: { $0.key < $1.key })
            .map { code, info in
                let name = info.name ?? ""
                let symbol = info.symbol ?? ""
                let middle = [symbol, name].filter { !$0.isEmpty }.joined(separator: " ")
                return middle.isEmpty ? code : "\(code) (\(middle))"
            }
    }
}
