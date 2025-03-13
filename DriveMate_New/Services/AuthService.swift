import Foundation
import CryptoKit
import Security

/// **AuthService** - Layanan otentikasi berbasis simulasi dengan penyimpanan di Keychain.
class AuthService {
    static let shared = AuthService()
    
    private let loggedInUserKey = "com.yourapp.loggedInUser"
    private let queue = DispatchQueue(label: "com.yourapp.authservice", attributes: .concurrent)
    
    // **Database Dummy untuk Simulasi Login**
    private let users: [UserModel] = [
        UserModel(id: "1", email: "admin@nusatoyotetsu.com", password: AuthService.hashPassword("admin123"), userType: .admin),
        UserModel(id: "2", email: "driver1@nusatoyotetsu.com", password: AuthService.hashPassword("driver123"), userType: .driver),
        UserModel(id: "3", email: "driver2@nusatoyotetsu.com", password: AuthService.hashPassword("driver123"), userType: .driver)
    ]
    
    // **Fungsi untuk Melakukan Login**
    func login(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        queue.async {
            print("🔍 Mencoba login dengan email: \(email)")

            guard self.isValidEmail(email) else {
                print("❌ Email tidak valid!")
                DispatchQueue.main.async {
                    completion(.failure(AuthError.invalidEmail))
                }
                return
            }
            
            guard !password.isEmpty else {
                print("❌ Password kosong!")
                DispatchQueue.main.async {
                    completion(.failure(AuthError.invalidPassword))
                }
                return
            }
            
            let hashedPassword = Self.hashPassword(password)
            print("🔑 Password setelah hash: \(hashedPassword)")

            if let user = self.users.first(where: { $0.email == email && $0.password == hashedPassword }) {
                print("✅ Login berhasil untuk \(user.email), menyimpan ke Keychain.")
                self.saveUserLocally(user)
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } else {
                print("❌ Login gagal! Email atau password salah.")
                DispatchQueue.main.async {
                    completion(.failure(AuthError.userNotFound))
                }
            }
        }
    }
    
    // **Fungsi untuk Logout dan Menghapus Data dari Keychain**
    func logout(completion: @escaping () -> Void) {
        queue.async {
            print("🔓 Logout dipanggil, menghapus user dari Keychain.")
            self.deleteUserFromKeychain()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    // **Fungsi untuk Mendapatkan User yang Sudah Login dari Keychain**
    func getLoggedInUser() -> UserModel? {
        if let userData = self.loadUserFromKeychain(),
           let user = try? JSONDecoder().decode(UserModel.self, from: userData) {
            print("✅ User ditemukan di Keychain: \(user.email)")
            return user
        }
        print("❌ Tidak ada user yang login di Keychain.")
        return nil
    }
    
    // **Menyimpan User ke Keychain Setelah Login Berhasil**
    private func saveUserLocally(_ user: UserModel) {
        if let encoded = try? JSONEncoder().encode(user) {
            print("💾 Menyimpan user ke Keychain: \(user.email)")
            saveToKeychain(data: encoded)
        } else {
            print("❌ Gagal mengencode user untuk disimpan di Keychain.")
        }
    }
    
    // **Hash Password dengan SHA-256 untuk Keamanan**
    private static func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    // **Memeriksa Format Email**
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // MARK: - **Keychain Helpers**
    
    // **Simpan Data ke Keychain**
    private func saveToKeychain(data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: loggedInUserKey,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        // Hapus data lama jika ada
        SecItemDelete(query as CFDictionary)
        
        // Tambahkan data baru ke Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("✅ Data berhasil disimpan ke Keychain.")
        } else {
            print("❌ Gagal menyimpan data ke Keychain, status: \(status)")
        }
    }
    
    // **Ambil Data User dari Keychain**
    private func loadUserFromKeychain() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: loggedInUserKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            print("✅ Data ditemukan di Keychain.")
            return result as? Data
        } else {
            print("❌ Data tidak ditemukan di Keychain, status: \(status)")
            return nil
        }
    }
    
    // **Hapus Data User dari Keychain Saat Logout**
    private func deleteUserFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: loggedInUserKey
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("✅ Data berhasil dihapus dari Keychain.")
        } else {
            print("❌ Gagal menghapus data dari Keychain, status: \(status)")
        }
    }
}

/// **Error Handling untuk Autentikasi**
enum AuthError: Error, LocalizedError {
    case userNotFound
    case invalidEmail
    case invalidPassword
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "Akun tidak ditemukan! Silakan hubungi HRD PT Nusa Toyotetsu."
        case .invalidEmail:
            return "Email tidak valid."
        case .invalidPassword:
            return "Password salah."
        }
    }
}
