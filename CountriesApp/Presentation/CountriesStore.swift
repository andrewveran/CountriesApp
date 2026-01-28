
import Foundation
import Combine

@MainActor
final class CountriesStore: ObservableObject {
    @Published var searchText: String = ""
    @Published var savedSearchText: String = ""

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    @Published private(set) var allCountries: [Country] = []
    @Published private(set) var searchResults: [Country] = []
    @Published private(set) var savedResults: [Country] = []

    @Published private(set) var bookmarkedIDs: Set<String> = []

    private let countriesRepo: CountriesRepository
    private let bookmarksRepo: BookmarksRepository
    private var cancellables = Set<AnyCancellable>()
    private var didBootstrap = false

    init(countriesRepo: CountriesRepository, bookmarksRepo: BookmarksRepository) {
        self.countriesRepo = countriesRepo
        self.bookmarksRepo = bookmarksRepo
        bindSearch()
    }

    func bootstrapIfNeeded() async {
        guard !didBootstrap else { return }
        didBootstrap = true
        await reload()
    }

    func reload() async {
        isLoading = true
        errorMessage = nil

        do {
            async let countriesTask = countriesRepo.fetchAllCountries()
            let bookmarks = try bookmarksRepo.loadBookmarkedIDs()
            let countries = try await countriesTask

            allCountries = countries
            bookmarkedIDs = bookmarks
            recomputeLists()
        } catch {
            errorMessage = Self.describe(error)
        }

        isLoading = false
    }

    func toggleBookmark(countryID: String) {
        if bookmarkedIDs.contains(countryID) {
            bookmarkedIDs.remove(countryID)
        } else {
            bookmarkedIDs.insert(countryID)
        }

        do {
            try bookmarksRepo.saveBookmarkedIDs(bookmarkedIDs)
        } catch {
            errorMessage = String(localized: "error.save_bookmarks")
        }

        recomputeLists()
    }

    func isBookmarked(_ id: String) -> Bool {
        bookmarkedIDs.contains(id)
    }

    func clearError() {
        errorMessage = nil
    }


    private func bindSearch() {
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(180), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.recomputeLists() }
            .store(in: &cancellables)

        $savedSearchText
            .removeDuplicates()
            .debounce(for: .milliseconds(180), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.recomputeLists() }
            .store(in: &cancellables)
    }

    private func recomputeLists() {
        searchResults = Self.filter(allCountries, query: searchText)

        let savedCountries = allCountries.filter { bookmarkedIDs.contains($0.id) }
        savedResults = Self.filter(savedCountries, query: savedSearchText)
    }

    nonisolated static func filter(_ countries: [Country], query: String) -> [Country] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard q.count >= 2 else { return countries }
        let needle = q.lowercased()

        return countries.filter { c in
            if c.commonName.lowercased().contains(needle) { return true }
            if c.officialName.lowercased().contains(needle) { return true }
            if c.capital.joined(separator: " ").lowercased().contains(needle) { return true }
            return false
        }
    }

    private static func describe(_ error: Error) -> String {
        if let apiError = error as? RestCountriesAPI.APIError {
            switch apiError {
            case .invalidURL:
                return String(localized: "error.invalid_url")
            case .badStatus(let code):
                return String(format: String(localized: "error.http"), code)
            }
        }

        if let decoding = error as? DecodingError {
            switch decoding {
            case .dataCorrupted:
                return String(localized: "error.decode_data")
            case .keyNotFound(let key, _):
                return String(format: String(localized: "error.decode_missing_field"), key.stringValue)
            case .typeMismatch(let type, _):
                return String(format: String(localized: "error.decode_type_mismatch"), String(describing: type))
            case .valueNotFound(let type, _):
                return String(format: String(localized: "error.decode_missing_value"), String(describing: type))
            @unknown default:
                return String(localized: "error.decode_generic")
            }
        }

        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            return String(format: String(localized: "error.network"), nsError.localizedDescription)
        }

        return String(localized: "error.generic")
    }
}
