
import SwiftUI

@main
struct CountriesAppApp: App {
    var body: some Scene {
        WindowGroup {
            let api = RestCountriesAPI()
            let countriesRepo = DefaultCountriesRepository(api: api)
            let bookmarksRepo = UserDefaultsBookmarksRepository()
            RootView(store: CountriesStore(countriesRepo: countriesRepo, bookmarksRepo: bookmarksRepo))
        }
    }
}
