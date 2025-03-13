import MapKit

extension MKCoordinateRegion {
    static let jakartaMetro = MKCoordinateRegion(
        center: .jakarta,
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
}
