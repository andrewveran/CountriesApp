
import SwiftUI

struct CountryDetailsView: View {
    @EnvironmentObject var store: CountriesStore
    let country: Country

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {

                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: country.flagPNGURL) { phase in
                        switch phase {
                        case .empty:
                            Rectangle().opacity(0.08)
                                .overlay(ProgressView())
                        case .success(let image):
                            image.resizable().scaledToFill()
                        case .failure:
                            Rectangle().opacity(0.08)
                                .overlay(Image(systemName: "flag").font(.title2))
                        @unknown default:
                            Rectangle().opacity(0.08)
                        }
                    }
                    .frame(height: 220)
                    .clipped()
                    .cornerRadius(14)

                    Button {
                        store.toggleBookmark(countryID: country.id)
                    } label: {
                        Image(systemName: store.isBookmarked(country.id) ? "bookmark.fill" : "bookmark")
                            .font(.title3)
                            .padding(10)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .padding(10)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 2) {
                    Text(country.commonName).font(.headline)
                    Text(country.officialName).font(.subheadline).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.background, in: RoundedRectangle(cornerRadius: 14))
                .shadow(radius: 2, y: 1)
                .padding(.horizontal)

                TrioInfoCard(
                    left: (String(localized: "detail.region"),
                           country.region ?? String(localized: "placeholder.emdash")),
                    middle: (String(localized: "detail.subregion"),
                             country.subregion ?? String(localized: "placeholder.emdash")),
                    right: (String(localized: "detail.capital"),
                            country.capital.first ?? String(localized: "placeholder.emdash"))
                )
                .padding(.horizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {

                    InfoTile(title: String(localized: "detail.timezones")) {
                        BulletListText(items: Self.trimmedList(country.timezones))
                    }

                    InfoTile(title: String(localized: "detail.population")) {
                        Text(Formatters.population(country.population))
                            .font(.subheadline)
                    }

                    InfoTile(title: String(localized: "detail.languages")) {
                        BulletListText(items: Self.trimmedList(country.languages))
                    }

                    InfoTile(title: String(localized: "detail.currencies")) {
                        BulletListText(items: Self.trimmedList(country.currencies))
                    }

                    DriveSideTile(activeSide: country.carDriveSide)

                    InfoTile(title: String(localized: "detail.coat_of_arms")) {
                        AsyncImage(url: country.coatOfArmsPNGURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(maxWidth: .infinity, minHeight: 52)
                            case .success(let image):
                                image.resizable().scaledToFit()
                                    .frame(maxWidth: .infinity, minHeight: 52)
                            case .failure:
                                Text("placeholder.emdash")
                                    .frame(maxWidth: .infinity, minHeight: 52)
                            @unknown default:
                                Text("placeholder.emdash")
                                    .frame(maxWidth: .infinity, minHeight: 52)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 18)
            }
            .padding(.top, 10)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private static func trimmedList(_ items: [String]) -> [String] {
        guard items.count > 3 else { return items }
        return Array(items.prefix(2)) + [String(localized: "placeholder.ellipsis")]
    }
}
