
import Foundation

enum Constants {
    enum API {
        static let baseURL = URL(string: "https://restcountries.com/v3.1")!
        static let maxFieldsPerRequest = 10
        static let baseFields = [
            "cca3", "name", "flags", "capital", "region",
            "subregion", "timezones", "population", "languages", "currencies"
        ]
        static let extraFields = ["cca3", "car", "coatOfArms"]
        static let logPrefix = "RestCountriesAPI"
        static let retryCount = 3
    }

    enum Storage {
        static let bookmarksKey = "bookmarked_country_ids"
    }
}
