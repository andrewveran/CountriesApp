//
//  CountriesStoreFilterTests.swift
//  CountriesApp
//
//  Created by Jorge Leal  on 27/01/26.
//

import XCTest
@testable import CountriesApp

final class CountriesStoreFilterTests: XCTestCase {

    func testFilter_withLessThan2Chars_returnsAll() {
        let countries = makeCountries()

        XCTAssertEqual(CountriesStore.filter(countries, query: ""), countries)
        XCTAssertEqual(CountriesStore.filter(countries, query: "a"), countries)
        XCTAssertEqual(CountriesStore.filter(countries, query: " "), countries) // trimmed -> ""
    }

    func testFilter_isCaseInsensitive_andMatchesCommonName() {
        let countries = makeCountries()

        let result = CountriesStore.filter(countries, query: "cOl")
        XCTAssertEqual(result.map(\.id), ["COL"]) // Colombia
    }

    func testFilter_matchesOfficialName() {
        let countries = makeCountries()

        let result = CountriesStore.filter(countries, query: "united mexican")
        XCTAssertEqual(result.map(\.id), ["MEX"])
    }

    func testFilter_matchesCapital() {
        let countries = makeCountries()

        let result = CountriesStore.filter(countries, query: "bog")
        XCTAssertEqual(result.map(\.id), ["COL"])
    }

    func testFilter_noMatches_returnsEmpty() {
        let countries = makeCountries()

        let result = CountriesStore.filter(countries, query: "zz")
        XCTAssertTrue(result.isEmpty)
    }

    func testFilter_trimsWhitespace() {
        let countries = makeCountries()

        let result = CountriesStore.filter(countries, query: "  meX  ")
        XCTAssertEqual(result.map(\.id), ["MEX"])
    }
}

// MARK: - Helpers
private func makeCountries() -> [Country] {
    [
        Country(
            id: "COL",
            commonName: "Colombia",
            officialName: "Republic of Colombia",
            flagPNGURL: nil,
            region: "Americas",
            subregion: "South America",
            capital: ["Bogotá"],
            timezones: ["UTC-05:00"],
            population: 50_000_000,
            languages: ["Spanish"],
            currencies: ["COP ($ Colombian peso)"],
            carDriveSide: "right",
            coatOfArmsPNGURL: nil
        ),
        Country(
            id: "MEX",
            commonName: "Mexico",
            officialName: "United Mexican States",
            flagPNGURL: nil,
            region: "Americas",
            subregion: "North America",
            capital: ["Mexico City"],
            timezones: ["UTC-06:00"],
            population: 120_000_000,
            languages: ["Spanish"],
            currencies: ["MXN ($ Mexican peso)"],
            carDriveSide: "right",
            coatOfArmsPNGURL: nil
        )
    ]
}
