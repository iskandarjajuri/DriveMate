import Foundation

struct UserModel: Identifiable, Codable, Hashable {
    let id: String
    let email: String
    let password: String
    let userType: UserType
}

/// Enum untuk menentukan tipe pengguna (Admin atau Driver)
enum UserType: String, Codable {
    case admin
    case driver
}
