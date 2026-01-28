
import SwiftUI

struct DriveSideTile: View {
    let activeSide: String?

    var body: some View {
        InfoTile(title: String(localized: "detail.drive_side.title")) {
            HStack(spacing: 10) {
                sideBadge(String(localized: "detail.drive_side.left"),
                          isActive: (activeSide?.lowercased() == "left"))
                Image(systemName: "steeringwheel")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                sideBadge(String(localized: "detail.drive_side.right"),
                          isActive: (activeSide?.lowercased() == "right"))
            }
        }
    }

    private func sideBadge(_ text: String, isActive: Bool) -> some View {
        Text(text)
            .font(.caption).fontWeight(isActive ? .bold : .regular)
            .foregroundStyle(isActive ? .primary : .secondary)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(isActive ? Color.primary.opacity(0.10) : Color.secondary.opacity(0.08),
                        in: RoundedRectangle(cornerRadius: 10))
    }
}
