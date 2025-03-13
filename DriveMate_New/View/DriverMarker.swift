import SwiftUI

struct DriverMarker: View {
    let driver: DriverLocation
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: driver.iconName) // ✅ Icon dinamis per driver
                .font(.system(size: isSelected ? 28 : 22, weight: .bold))
                .padding()
                .background(
                    Circle()
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                )
                .foregroundColor(.white)
                .shadow(radius: 6)
            
            Text(driver.name)
                .font(.caption.weight(.medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )
        }
        .onTapGesture(perform: onSelect)
        .scaleEffect(isSelected ? 1.15 : 1)
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}
