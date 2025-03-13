import Foundation

struct DriverReport: Identifiable {
    let id = UUID()
    let driverName: String
    let cleanliness: String
    let safetyCommitment: String
    let healthCondition: String
    let workingHours: String
}
