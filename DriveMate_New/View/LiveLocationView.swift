import SwiftUI
import MapKit

struct LiveLocationView: View {
    @State private var selectedDriver: DriverLocation?
    @State private var isCardVisible: Bool = false
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var mapPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @State private var isGridVisible: Bool = true
    @State private var isNavigating: Bool = false

    let drivers = sampleDrivers

    var body: some View {
        ZStack {
            Map(position: $mapPosition) {
                ForEach(drivers) { driver in
                    Annotation(driver.id, coordinate: driver.coordinate) { // Memperbaiki pemanggilan Annotation
                        Button {
                            withAnimation(.easeInOut) {
                                selectedDriver = driver
                                isCardVisible = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                withTransaction(Transaction(animation: nil)) { // ✅ Hindari animasi ekstra
                                    isCardVisible = false
                                    selectedDriver = nil
                                }
                            }
                        } label: {
                            Image(systemName: driver.iconName)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color.blue)
                                        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 2) // ✅ Shadow lebih ringan
                                )
                        }
                    }
                }
            }
            .mapStyle(.standard)

            VStack {
                Spacer()
                
                if isGridVisible {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 12) { // ✅ Gunakan LazyVStack agar lebih ringan
                            ForEach(drivers) { driver in
                                HStack(spacing: 12) {
                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.blue)
                                    
                                    Text(driver.name)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 3)
                                .onTapGesture {
                                    withAnimation {
                                        mapRegion.center = driver.coordinate
                                        selectedDriver = driver
                                        isCardVisible = true
                                        isNavigating = true // Menandakan navigasi sedang berlangsung
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 220)
                    .padding(.bottom, 8)
                }

                HStack(spacing: 12) {
                    Button(action: {
                        withAnimation {
                            mapRegion.span.latitudeDelta /= 1.5
                            mapRegion.span.longitudeDelta /= 1.5
                        }
                    }) {
                        Image(systemName: "plus.magnifyingglass")
                            .font(.title2)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    
                    Button(action: {
                        withAnimation {
                            mapRegion.span.latitudeDelta *= 1.5
                            mapRegion.span.longitudeDelta *= 1.5
                        }
                    }) {
                        Image(systemName: "minus.magnifyingglass")
                            .font(.title2)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                }
                .padding()
            }

            if isCardVisible {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    .background(
                        Group {
                            #if targetEnvironment(simulator)
                            Color.gray.opacity(0.3) // ✅ Warna solid di emulator
                            #else
                            Color.black.opacity(0.2)
                            #endif
                        }
                    )
                    .onTapGesture {
                        withAnimation {
                            isCardVisible = false
                            selectedDriver = nil
                        }
                    }

                if let driver = selectedDriver {
                    DriverInfoCard(driver: driver, isVisible: $isCardVisible)
                        .transition(.opacity) // ✅ Gunakan opacity saja
                        .presentationDetents([.medium]) // Menambahkan presentationDetents untuk modal
                        .transaction { $0.animation = nil } // Menambahkan transaction untuk mencegah animasi lambat
                        .animation(nil, value: isNavigating) // Menambahkan animation untuk mempercepat perpindahan
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
