import SwiftUI

struct DriverInfoCard: View {
    let driver: DriverLocation
    @Binding var isVisible: Bool
    @State private var isPulsing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "person.fill")
                    .font(.title2)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(driver.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Available now")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
                
                Button(action: {
                    withAnimation {
                        isVisible = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                        )
                }
            }

            Divider()

            HStack(spacing: 12) {
                InfoBadge(title: "🕒 ETA", value: "5 min")
                InfoBadge(title: "📍 Distance", value: "1.2 km")
                InfoBadge(title: "🚗 Speed", value: "60 km/h")
            }
        }
        .padding()
        .background(
            VisualEffectBlur(blurStyle: .systemMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 6)
        )
        .scaleEffect(isPulsing ? 1.02 : 1)
        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isPulsing)
        .onAppear {
            isPulsing = true
        }
        .padding(.horizontal, 20)
    }
}
