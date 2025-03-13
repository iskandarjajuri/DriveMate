import SwiftUI

struct DriverInfoCard: View {
    let driver: DriverLocation
    @State private var isPulsing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.fill")
                    .font(.title2)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                    )

                VStack(alignment: .leading) {
                    Text(driver.name)
                        .font(.headline)
                    Text("Available now")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()

                Button {
                    // Action call driver
                } label: {
                    Image(systemName: "phone.fill")
                        .padding()
                        .background(
                            Circle()
                                .fill(Color.green)
                        )
                        .foregroundColor(.white)
                }
            }

            Divider()

            HStack(spacing: 20) {
                InfoBadge(title: "clock.fill", value: "5 min")
                InfoBadge(title: "map.fill", value: "1.2 km")
                InfoBadge(title: "speedometer", value: "60 km/h")
            }
        }
        .padding()
        .background(
            VisualEffectBlur(blurStyle: .systemMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .scaleEffect(isPulsing ? 1.02 : 1)
        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isPulsing)
        .onAppear {
            isPulsing = true
        }
        .padding()
    }
}
