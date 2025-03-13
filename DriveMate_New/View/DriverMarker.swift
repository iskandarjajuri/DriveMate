import SwiftUI

struct DriverMarker: View {
    let driver: DriverLocation
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "car.fill")
                .font(.title3)
                .padding()
                .background(
                    Circle()
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                )
                .foregroundColor(.white)
                .shadow(radius: 4)
            
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
        .scaleEffect(isSelected ? 1.2 : 1)
        .animation(.easeInOut, value: isSelected)
    }
}
