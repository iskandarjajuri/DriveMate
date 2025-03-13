import Foundation
import MapKit

struct DriverLocation: Identifiable, Equatable {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    let iconName: String 
    
    static func == (lhs: DriverLocation, rhs: DriverLocation) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
