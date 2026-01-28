
import Foundation

enum Formatters {
    static func population(_ value: Int?) -> String {
        guard let value else { return String(localized: "placeholder.emdash") }
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
