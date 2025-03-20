import SwiftUI

import SwiftUI

struct DriverInfoCard: View {
    let driver: DriverLocation
    @Binding var isVisible: Bool
    @State private var isPulsing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 12) {
                Image(systemName: "person.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.blue)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(driver.name)
                        .font(.headline.weight(.bold))
                        .foregroundColor(.primary)
                    Text("Available now")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }

                Spacer()

                Button(action: {
                    withAnimation {
                        isVisible = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color.red)
                        )
                }
            }

            Divider()
                .background(Color.gray.opacity(0.5))

            HStack(spacing: 16) {
                InfoBadge(title: "🕒 ETA", value: "5 min")
                InfoBadge(title: "📍 Distance", value: "1.2 km")
                InfoBadge(title: "🚗 Speed", value: "60 km/h")
            }
        }
        .padding(20)
        .background(
            Group {
                #if targetEnvironment(simulator)
                Color.white.opacity(0.2)
                #else
                VisualEffectBlur(blurStyle: .systemThinMaterial)
                #endif
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
        .scaleEffect(isPulsing ? 1.02 : 1)
        .animation(.easeInOut(duration: 1).repeatCount(3, autoreverses: true), value: isPulsing)
        .onAppear {
            isPulsing = true
        }
        .padding(.horizontal, 20)
    }
}
