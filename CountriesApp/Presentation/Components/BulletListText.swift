
import SwiftUI

struct BulletListText: View {
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if items.isEmpty {
                Text("placeholder.emdash").font(.subheadline)
            } else {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 6) {
                        Text("bullet.dot").foregroundStyle(.secondary)
                        Text(item).font(.subheadline)
                    }
                }
            }
        }
    }
}
