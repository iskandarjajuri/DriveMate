import MapKit

extension CLLocationCoordinate2D {
    static let jakarta = CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456)
    
    func offsetRandomly() -> CLLocationCoordinate2D {
        let randomLat = Double.random(in: -0.01...0.01)
        let randomLon = Double.random(in: -0.01...0.01)
        return CLLocationCoordinate2D(
            latitude: self.latitude + randomLat,
            longitude: self.longitude + randomLon
        )
    }
}
