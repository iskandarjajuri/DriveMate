import SwiftUI

struct InfoBadge: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.gray) // Menghindari opacity
            Text(value)
                .font(.caption.weight(.medium))
                .foregroundColor(.black)
        }
        .padding(8)
        .frame(minWidth: 80, maxWidth: .infinity) // Membatasi ukuran minimum
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(white: 0.95)) // Warna solid lebih ringan dari opacity
        )
    }
}
