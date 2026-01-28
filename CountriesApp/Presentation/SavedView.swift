
import SwiftUI

struct SavedView: View {
    @EnvironmentObject var store: CountriesStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.savedResults) { country in
                    NavigationLink(value: country) {
                        CountryCardRow(
                            flagURL: country.flagPNGURL,
                            title: country.commonName,
                            subtitle: country.officialName,
                            footnote: country.capital.first ?? "",
                            isBookmarked: true,
                            onBookmarkTap: { store.toggleBookmark(countryID: country.id) }
                        )
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("nav.saved.title")
            .searchable(text: $store.savedSearchText, prompt: "search.prompt")
            .navigationDestination(for: Country.self) { country in
                CountryDetailsView(country: country)
            }
        }
    }
}
