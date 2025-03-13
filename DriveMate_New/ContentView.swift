import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        if authViewModel.isCheckingAuth {
            ProgressView("Memeriksa sesi...")
                .onAppear {
                    print("🔄 Memeriksa status autentikasi...")
                }
        } else if !authViewModel.isLoggedIn {
            LoginView()
                .environmentObject(authViewModel)
        } else if let user = authViewModel.user {
            if authViewModel.userType == "admin" {
                DashboardAdminView(user: user)
                    .environmentObject(authViewModel)
            } else {
                DashboardDriverView(user: user)
                    .environmentObject(authViewModel)
            }
        } else {
            LoginView()
                .environmentObject(authViewModel)
        }
    }
}

#Preview {
    let previewAuthViewModel = AuthViewModel()
    previewAuthViewModel.user = UserModel(
        id: "12345",
        email: "admin@example.com",
        password: "dummyPassword",
        userType: UserType.admin
    ) // Data dummy

    return ContentView()
        .environmentObject(previewAuthViewModel)
}
