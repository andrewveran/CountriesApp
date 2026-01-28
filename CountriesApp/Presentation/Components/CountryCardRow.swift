
import SwiftUI

struct CountryCardRow: View {
    let flagURL: URL?
    let title: String
    let subtitle: String
    let footnote: String
    let isBookmarked: Bool
    let onBookmarkTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            AsyncImage(url: flagURL) { phase in
                switch phase {
                case .empty:
                    Rectangle().opacity(0.08).overlay(ProgressView())
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Rectangle().opacity(0.08).overlay(Image(systemName: "flag"))
                @unknown default:
                    Rectangle().opacity(0.08)
                }
            }
            .frame(width: 52, height: 36)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline).fontWeight(.semibold)
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
                Text(footnote).font(.caption2).foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onBookmarkTap) {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.subheadline)
            }
            .buttonStyle(.borderless)
        }
        .padding(12)
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .shadow(radius: 2, y: 1)
        .padding(.vertical, 6)
    }
}
