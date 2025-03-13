import SwiftUI
import MapKit

struct LiveLocationView: View {
    @State private var selectedDriver: DriverLocation?
    @State private var isCardVisible: Bool = false
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var isGridVisible: Bool = true

    let drivers = sampleDrivers

    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, annotationItems: drivers) { driver in
                MapAnnotation(coordinate: driver.coordinate) {
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
                        Image(systemName: driver.iconName)
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
            .mapStyle(.standard)
            .onAppear {
                mapRegion = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }

            VStack {
                Spacer()
                
                if isGridVisible {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 12) {
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
                                .shadow(radius: 4)
                                .onTapGesture {
                                    withAnimation {
                                        mapRegion.center = driver.coordinate
                                        selectedDriver = driver
                                        isCardVisible = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 220) // ✅ Atur tinggi maksimal grid
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
                            .shadow(radius: 4)
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
                            .shadow(radius: 4)
                    }
                    
                    Button(action: {
                        withAnimation {
                            isGridVisible.toggle()
                        }
                    }) {
                        Image(systemName: isGridVisible ? "chevron.down.circle.fill" : "chevron.up.circle.fill")
                            .font(.title2)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                }
                .padding()
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
