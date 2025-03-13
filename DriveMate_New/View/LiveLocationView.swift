import SwiftUI
import MapKit

struct LiveLocationView: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedDriver: DriverLocation?
    @State private var isCardVisible: Bool = false

    let drivers: [DriverLocation] = [
        DriverLocation(id: "1", name: "Budi", coordinate: .jakarta),
        DriverLocation(id: "2", name: "Ani", coordinate: .jakarta.offsetRandomly()),
        DriverLocation(id: "3", name: "Dewi", coordinate: .jakarta.offsetRandomly())
    ]

    var body: some View {
        ZStack {
            Map(position: $position) {
                ForEach(drivers) { driver in
                    Annotation(driver.name, coordinate: driver.coordinate) {
                        Button {
                            withAnimation(.easeInOut) {
                                selectedDriver = driver
                                isCardVisible = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                withAnimation(.easeInOut) {
                                    isCardVisible = false
                                    selectedDriver = nil
                                }
                            }
                        } label: {
                            Image(systemName: "car.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color.blue)
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                                )
                        }
                    }
                }
            }
            .mapStyle(.standard)
            .onAppear {
                position = .region(.jakartaMetro)
            }

            VStack {
                Text("🚗 Live Driver Tracking")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 6)
                    .padding(.top, 60)
                Spacer()
            }

            if isCardVisible {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isCardVisible = false
                            selectedDriver = nil
                        }
                    }

                if let driver = selectedDriver {
                    DriverInfoCard(driver: driver, isVisible: $isCardVisible)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct LiveLocationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LiveLocationView()
                .preferredColorScheme(.light)
        }
    }
}
