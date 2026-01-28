
import SwiftUI

struct SearchView: View {
    @EnvironmentObject var store: CountriesStore

    var body: some View {
        NavigationStack {
            Group {
                if store.isLoading && store.allCountries.isEmpty {
                    ProgressView()
                } else {
                    List {
                        ForEach(store.searchResults) { country in
                            NavigationLink(value: country) {
                                CountryCardRow(
                                    flagURL: country.flagPNGURL,
                                    title: country.commonName,
                                    subtitle: country.officialName,
                                    footnote: country.capital.first ?? "",
                                    isBookmarked: store.isBookmarked(country.id),
                                    onBookmarkTap: { store.toggleBookmark(countryID: country.id) }
                                )
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("nav.search.title")
            .searchable(text: $store.searchText, prompt: "search.prompt")
            .navigationDestination(for: Country.self) { country in
                CountryDetailsView(country: country)
            }
            .refreshable { await store.reload() }
        }
    }
}
