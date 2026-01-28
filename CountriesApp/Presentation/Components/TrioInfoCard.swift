
import SwiftUI

struct TrioInfoCard: View {
    let left: (String, String)
    let middle: (String, String)
    let right: (String, String)

    var body: some View {
        HStack {
            TrioColumn(title: left.0, value: left.1)
            Spacer()
            TrioColumn(title: middle.0, value: middle.1)
            Spacer()
            TrioColumn(title: right.0, value: right.1)
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .shadow(radius: 2, y: 1)
    }
}

private struct TrioColumn: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.subheadline)
        }
    }
}
