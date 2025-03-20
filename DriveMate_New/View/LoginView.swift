import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @FocusState private var focusedField: Field?
    @State private var navigateToDashboard: Bool = false
    @State private var isNavigating: Bool = false
    
    enum Field { case email, password }
    
    // Warna brand Nusa Toyotetsu (Biru)
    private let brandColor = Color(red: 0.1, green: 0.35, blue: 0.7)  // Biru lebih terang
    private let lightBrandColor = Color(red: 0.1, green: 0.35, blue: 0.7, opacity: 0.2) // Biru terang transparan
    
    private let gradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.3, green: 0.7, blue: 1.0), Color(red: 0.1, green: 0.4, blue: 0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    @State private var isChecklistSubmitted = false
    @State private var isSafetyCommitted = false
    @State private var isSOPRead = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                gradient
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Header Section
                    VStack(spacing: 24) {
                        Image(systemName: "car.2.fill")
                            .font(.system(size: 64, weight: .bold))
                            .foregroundColor(brandColor)
                            .shadow(color: brandColor.opacity(0.2), radius: 3, x: 0, y: 2) // Shadow lebih ringan
                            .symbolEffect(.pulse, options: .repeat(3))
                        
                        Text("DriveMate")
                            .font(.system(size: 36, weight: .heavy, design: .rounded))
                            .foregroundColor(brandColor)
                            .shadow(radius: 2)
                    }
                    .padding(.bottom, 40)
                    
                    // Form Section
                    VStack(spacing: 28) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("EMAIL")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                            
                            TextField("example@nusatoyotetsu.co.id", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.none)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(UIColor.secondarySystemBackground)) // Warna solid lebih ringan
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(focusedField == .email ? brandColor : Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                )
                                .focused($focusedField, equals: .email)
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("PASSWORD")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                            
                            SecureField("••••••••", text: $viewModel.password)
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(UIColor.secondarySystemBackground)) // Warna solid lebih ringan
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(focusedField == .password ? brandColor : Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                )
                                .focused($focusedField, equals: .password)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 8)
                    
                    // Login Button
                    Button(action: {
                        viewModel.login()
                    }) {
                        HStack(spacing: 12) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "arrow.forward.circle.fill")
                                    .imageScale(.large)
                            }
                            
                            Text(viewModel.isLoading ? "Memproses..." : "Mulai")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            brandColor
                                .cornerRadius(12)
                                .shadow(color: brandColor.opacity(0.3), radius: 3, y: 2) // Shadow lebih ringan
                        )
                        .foregroundColor(.white)
                        .scaleEffect(viewModel.isLoading ? 0.97 : 1)
                        .transaction { $0.animation = nil } // Mencegah animasi berlebih
                    }
                    .disabled(viewModel.isLoading || !viewModel.isFormValid)
                    .opacity(viewModel.isLoading || !viewModel.isFormValid ? 0.7 : 1)
                    .padding(.horizontal, 32)
                    
                    .onChange(of: viewModel.user) { _, newUser in
                        if newUser != nil {
                            navigateToDashboard = true
                        }
                    }
                    
                    // Error Message
                    if let error = viewModel.errorMessage {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.octagon.fill")
                                .foregroundColor(.red)
                            
                            Text(error)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.95))
                        )
                        .padding(.top, 16)
                    }
                    
                    Spacer()
                    
                    // Footer
                    HStack(spacing: 10) {
                        Image(systemName: "person.badge.key.fill")
                            .foregroundColor(.gray)
                        
                        Text("Tidak punya akun? Hubungi HRD PT Nusa Toyotetsu")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 32)
                }
                .navigationDestination(isPresented: Binding(
                    get: { viewModel.user != nil },
                    set: { if !$0 { viewModel.logout() } }
                )) {
                    if let user = viewModel.user {
                        switch user.userType {
                        case .admin:
                            DashboardAdminView(user: user)
                                .environmentObject(viewModel)
                                .transaction { $0.animation = nil } // Mencegah animasi berlebih
                                .presentationDetents([.medium]) // Menyesuaikan ukuran presentasi modal
                        case .driver:
                            DashboardDriverView(user: user)
                                .environmentObject(viewModel)
                                .transaction { $0.animation = nil } // Mencegah animasi berlebih
                                .presentationDetents([.medium]) // Menyesuaikan ukuran presentasi modal
                        }
                    }
                }
                .animation(nil, value: isNavigating)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .accentColor(brandColor) // Warna aksen global
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// **AuthViewModelPreview** - Dummy ViewModel untuk Preview di Xcode
class AuthViewModelPreview: AuthViewModel {
    override init() {
        super.init()
        self.user = nil  // Pastikan user di-set ke nil agar preview tetap di LoginView
    }
}

// **Preview untuk Xcode Canvas**
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModelPreview())  // Gunakan ViewModel khusus untuk preview
    }
}
