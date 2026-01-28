
import Foundation

final class UserDefaultsBookmarksRepository: BookmarksRepository {
    enum StorageError: Error { case encodingFailed, decodingFailed }

    private let key = Constants.Storage.bookmarksKey
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadBookmarkedIDs() throws -> Set<String> {
        guard let data = defaults.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode(Set<String>.self, from: data)
        } catch {
            throw StorageError.decodingFailed
        }
    }

    func saveBookmarkedIDs(_ ids: Set<String>) throws {
        do {
            let data = try JSONEncoder().encode(ids)
            defaults.set(data, forKey: key)
        } catch {
            throw StorageError.encodingFailed
        }
    }
}
