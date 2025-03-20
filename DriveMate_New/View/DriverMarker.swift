import SwiftUI

struct DriverMarker: View {
    let driver: DriverLocation
    let isSelected: Bool
    let onSelect: () -> Void
    @State private var isNavigating: Bool = false // Menambahkan state untuk navigasi

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: driver.iconName)
                .font(.system(size: isSelected ? 28 : 22, weight: .bold))
                .padding()
                .background(
                    Circle()
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                )
                .foregroundColor(.white)
                .shadow(radius: isSelected ? 4 : 2) // ✅ Shadow lebih ringan
            
            Text(driver.name)
                .font(.caption.weight(.medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Group {
                        #if targetEnvironment(simulator)
                        Color.white.opacity(0.5) // Warna solid di emulator
                        #else
                        Capsule().fill(.ultraThinMaterial)
                        #endif
                    }
                )
        }
        .onTapGesture(perform: onSelect)
        .scaleEffect(isSelected ? 1.15 : 1)
        .transaction { transaction in
            transaction.animation = nil // Menambahkan .transaction untuk menghindari re-render berulang
        }
        .animation(nil, value: isNavigating) // Menambahkan animasi navigasi
        .presentationDetents([.medium]) // Menggunakan .presentationDetents untuk modal
    }
}
