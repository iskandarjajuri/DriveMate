import SwiftUI

struct DashboardDriverView: View {
    let user: UserModel
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showLogoutAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Dashboard Driver")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Selamat datang, \(user.email)")
                .font(.headline)
                .foregroundColor(.gray)

            Spacer()
        }
        .navigationTitle("Dashboard Driver")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { // ✅ Hanya biarkan tombol Logout
                Button(action: {
                    showLogoutAlert = true
                }) {
                    Label("Logout", systemImage: "power")
                        .foregroundColor(.red)
                }
            }
        }
        .alert("Konfirmasi Logout", isPresented: $showLogoutAlert) {
            Button("Batal", role: .cancel) { }
            Button("Logout", role: .destructive) {
                logout()
            }
        } message: {
            Text("Apakah Anda yakin ingin logout?")
        }
    }

    private func logout() {
        viewModel.logout()
    }
}
