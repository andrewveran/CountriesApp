//
//  CountryDTOMappingTests.swift
//  CountriesApp
//
//  Created by Jorge Leal  on 27/01/26.
//

import XCTest
@testable import CountriesApp

final class CountryDTOMappingTests: XCTestCase {

    func testToDomain_returnsNil_whenMissingCCA3() throws {
        let dto = try decodeDTO(json: """
        {
          "name": { "common": "NoId", "official": "NoId Official" }
        }
        """)
        XCTAssertNil(dto.toDomain())
    }

    func testToDomain_mapsNamesAndBasicFields() throws {
        let dto = try decodeDTO(json: """
        {
          "cca3": "COL",
          "name": { "common": "Colombia", "official": "Republic of Colombia" },
          "flags": { "png": "https://example.com/flag.png" },
          "capital": ["Bogotá"],
          "region": "Americas",
          "subregion": "South America",
          "timezones": ["UTC-05:00"],
          "population": 50000000,
          "car": { "side": "right" },
          "coatOfArms": { "png": "https://example.com/coa.png" }
        }
        """)

        let country = dto.toDomain()
        XCTAssertNotNil(country)

        XCTAssertEqual(country?.id, "COL")
        XCTAssertEqual(country?.commonName, "Colombia")
        XCTAssertEqual(country?.officialName, "Republic of Colombia")
        XCTAssertEqual(country?.capital, ["Bogotá"])
        XCTAssertEqual(country?.region, "Americas")
        XCTAssertEqual(country?.subregion, "South America")
        XCTAssertEqual(country?.timezones, ["UTC-05:00"])
        XCTAssertEqual(country?.population, 50_000_000)
        XCTAssertEqual(country?.carDriveSide, "right")
        XCTAssertEqual(country?.flagPNGURL?.absoluteString, "https://example.com/flag.png")
        XCTAssertEqual(country?.coatOfArmsPNGURL?.absoluteString, "https://example.com/coa.png")
    }

    func testToDomain_formatsLanguages_sortedByValue() throws {
        let dto = try decodeDTO(json: """
        {
          "cca3": "MEX",
          "name": { "common": "Mexico", "official": "United Mexican States" },
          "languages": {
            "spa": "Spanish",
            "nah": "Nahuatl",
            "maya": "Mayan"
          }
        }
        """)

        let country = dto.toDomain()
        XCTAssertEqual(country?.languages, ["Mayan", "Nahuatl", "Spanish"])
    }

    func testToDomain_formatsCurrencies_codeAndSymbolAndName_sortedByCode() throws {
        let dto = try decodeDTO(json: """
        {
          "cca3": "USA",
          "name": { "common": "United States", "official": "United States of America" },
          "currencies": {
            "USD": { "name": "United States dollar", "symbol": "$" },
            "AAA": { "name": "Test Currency", "symbol": "T" }
          }
        }
        """)

        let country = dto.toDomain()
        XCTAssertEqual(country?.currencies, [
            "AAA (T Test Currency)",
            "USD ($ United States dollar)"
        ])
    }
}

// MARK: - Helper
private func decodeDTO(json: String) throws -> CountryDTO {
    let data = Data(json.utf8)
    return try JSONDecoder().decode(CountryDTO.self, from: data)
}
