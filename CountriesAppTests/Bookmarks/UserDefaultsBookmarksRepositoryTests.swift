//
//  UserDefaultsBookmarksRepositoryTests.swift
//  CountriesApp
//
//  Created by Jorge Leal  on 27/01/26.
//

import XCTest
@testable import CountriesApp

final class UserDefaultsBookmarksRepositoryTests: XCTestCase {

    private var defaults: UserDefaults!
    private var repo: UserDefaultsBookmarksRepository!

    override func setUp() {
        super.setUp()
        let suiteName = "test.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)!
        repo = UserDefaultsBookmarksRepository(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: defaultsSuiteName(defaults))
        repo = nil
        defaults = nil
        super.tearDown()
    }

    func testLoad_whenNoValue_returnsEmptySet() throws {
        let ids = try repo.loadBookmarkedIDs()
        XCTAssertEqual(ids, [])
    }

    func testSaveThenLoad_roundTrip() throws {
        let input: Set<String> = ["COL", "MEX", "USA"]
        try repo.saveBookmarkedIDs(input)

        let loaded = try repo.loadBookmarkedIDs()
        XCTAssertEqual(loaded, input)
    }

    func testLoad_withCorruptedData_throws() {
        // Write bad data into same key
        defaults.set(Data([0x00, 0x01, 0x02]), forKey: "bookmarked_country_ids")

        XCTAssertThrowsError(try repo.loadBookmarkedIDs())
    }
}

// MARK: - Helper
private func defaultsSuiteName(_ defaults: UserDefaults) -> String {
    // This is a little hacky but works for test cleanup.
    // If Apple changes internals, you can remove persistent domain only if you track suiteName yourself.
    return defaults.dictionaryRepresentation().keys.contains("NSGlobalDomain")
        ? "NSGlobalDomain"
        : defaults.description
}
