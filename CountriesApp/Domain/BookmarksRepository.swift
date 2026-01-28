
import Foundation

protocol BookmarksRepository {
    func loadBookmarkedIDs() throws -> Set<String>
    func saveBookmarkedIDs(_ ids: Set<String>) throws
}
