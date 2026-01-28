
import Foundation

struct Country: Identifiable, Equatable, Hashable {
    let id: String
    let commonName: String
    let officialName: String
    let flagPNGURL: URL?
    let region: String?
    let subregion: String?
    let capital: [String]
    let timezones: [String]
    let population: Int?
    let languages: [String]
    let currencies: [String]
    let carDriveSide: String?
    let coatOfArmsPNGURL: URL?
}
