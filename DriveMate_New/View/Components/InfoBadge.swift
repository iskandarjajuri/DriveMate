import SwiftUI

struct InfoBadge: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.black.opacity(0.7))
            Text(value)
                .font(.caption.weight(.medium))
                .foregroundColor(.black)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.green.opacity(0.1))
        )
    }
}
