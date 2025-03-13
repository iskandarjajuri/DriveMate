import SwiftUI
import Combine

/// **AuthViewModel** - ViewModel untuk mengelola autentikasi dalam aplikasi.
class AuthViewModel: ObservableObject {
    // **Variabel yang dipantau oleh UI**
    @Published var email: String = ""  // Input email dari pengguna
    @Published var password: String = ""  // Input password dari pengguna
    @Published var isLoading: Bool = false  // Status loading saat login berlangsung
    @Published var user: UserModel? = nil  // Data user yang sedang login
    @Published var errorMessage: String?  // Pesan error jika login gagal
    
    /// **Validasi apakah form bisa dikirim**
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && !isLoading
    }
    
    /// **Inisialisasi ViewModel**
    /// - Fungsi ini akan memeriksa apakah ada user yang sudah login sebelumnya dari Keychain
    init() {
        DispatchQueue.main.async {
            self.user = AuthService.shared.getLoggedInUser()
            if let user = self.user {
                print("✅ User ditemukan di Keychain: \(user.email)")
            } else {
                print("❌ Tidak ada user yang login di Keychain.")
            }
        }
    }
    
    /// **Fungsi Login**
    /// - Mengirimkan email dan password ke `AuthService`
    /// - Jika berhasil, user akan disimpan dan UI akan diperbarui
    /// - Jika gagal, menampilkan pesan error
    func login() {
        print("🔍 Mencoba login dengan email: \(email)")
        
        guard isFormValid else {
            errorMessage = "Email dan Password harus diisi!"
            print("❌ Form tidak valid!")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        AuthService.shared.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let user):
                    print("✅ Login berhasil! User: \(user.email), Role: \(user.userType)")
                    self?.user = user
                case .failure(let error):
                    print("❌ Login gagal: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// **Fungsi Logout**
    /// - Menghapus user dari Keychain
    /// - Mengosongkan semua variabel di ViewModel
    func logout() {
        print("🔓 Logout dipanggil, menghapus user dari Keychain.")
        
        AuthService.shared.logout { [weak self] in
            DispatchQueue.main.async {
                self?.resetState()
                print("✅ Logout berhasil, state direset.")
            }
        }
    }
    
    /// **Reset State**
    /// - Membersihkan input email dan password setelah logout
    private func resetState() {
        email = ""
        password = ""
        isLoading = false
        errorMessage = nil
        user = nil  // ✅ Pastikan user dihapus agar UI kembali ke login
    }
}
