import MapKit
import SwiftUI

extension MapCameraPosition {
    static let jakartaMetro = MapCameraPosition.region(
        MKCoordinateRegion(
            center: .jakarta,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
}
