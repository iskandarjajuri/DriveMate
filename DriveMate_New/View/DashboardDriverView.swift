import SwiftUI

struct DashboardDriverView: View {
    let user: UserModel
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showLogoutAlert = false
    @State private var showSignaturePad = false
    @AppStorage("isTappedIn") private var isTappedIn: Bool = false
    @AppStorage("isTappedOut") private var isTappedOut: Bool = false
    @AppStorage("isChecklistSubmitted") private var isChecklistSubmitted: Bool = false
    @AppStorage("isSafetyCommitted") private var isSafetyCommitted: Bool = false
    @AppStorage("isSOPRead") private var isSOPRead: Bool = false
    @State private var previousWorkHours: [String] = ["08:00 - 17:00", "07:00 - 16:00", "09:00 - 18:00"]
    @Namespace var scrollNamespace
    @State private var scrollOffset: CGFloat = 0
    @State private var isTapped = false
    
    
    // UI Constants
    private let brandColor = Color(red: 0.1, green: 0.35, blue: 0.7)
    private let gradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.indigo]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        if viewModel.isCheckingAuth {
            ProgressView("Memeriksa sesi...")
        } else if !viewModel.isLoggedIn || viewModel.userType != "driver" {
            LoginView()
        } else {
            NavigationStack {
                ZStack {
                    gradient.ignoresSafeArea()
                    
                    ScrollViewReader { proxy in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 30) {
                                
                                // MARK: - Header Section
                                VStack(spacing: 12) {
                                    Image(systemName: "person.crop.circle.fill")
                                        .font(.system(size: 80))
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.white, brandColor)
                                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                                    
                                    VStack(spacing: 4) {
                                        Text("Dashboard Driver")
                                            .font(.title2.weight(.bold))
                                            .foregroundColor(.white)
                                        
                                        Text(user.email)
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.9))
                                    }
                                    .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 40)
                                .frame(height: 280)
                                .id("header")
                                
                                // MARK: - Features Grid
                                LazyVGrid(
                                    columns: [GridItem(.adaptive(minimum: 160), spacing: 20)],
                                    spacing: 20
                                ) {
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                            showSignaturePad = true
                                            isTapped.toggle()
                                        }
                                    }) {
                                        FeatureTileContent(
                                            title: isTappedIn ? "Tap Out" : "Tap In",
                                            icon: "checkmark.circle.fill",
                                            color: isTappedIn ? .red : .green
                                        )
                                    }
                                    .disabled(isTappedIn && isTappedOut)
                                    .scaleEffect(isTapped ? 0.9 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: isTapped)
                                    .onChange(of: showSignaturePad) { _ in
                                        isTapped = false
                                    }
                                    
                                    FeatureTile(
                                        title: isChecklistSubmitted ? "Checklist Selesai ✅" : "Cek List Kendaraan",
                                        icon: isChecklistSubmitted ? "checkmark.circle.fill" : "wrench.fill",
                                        color: isChecklistSubmitted ? .green : .blue,
                                        destination: ChecklistView()
                                    )
                                    .scaleEffect(isTapped ? 0.9 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: isTapped)
                                    
                                    FeatureTile(
                                        title: isSafetyCommitted ? "Komitmen Disetujui ✅" : "Safety Komitmen",
                                        icon: isSafetyCommitted ? "checkmark.circle.fill" : "shield.lefthalf.filled",
                                        color: isSafetyCommitted ? .green : .orange,
                                        destination: SafetyCommitmentView()
                                    )
                                    .scaleEffect(isTapped ? 0.9 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: isTapped)
                                    
                                    FeatureTile(
                                        title: isSOPRead ? "SOP Dibaca ✅" : "Baca SOP Pekerjaan",
                                        icon: isSOPRead ? "checkmark.circle.fill" : "doc.text.fill",
                                        color: isSOPRead ? .green : .purple,
                                        destination: SOPView()
                                    )
                                    .scaleEffect(isTapped ? 0.9 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: isTapped)
                                }
                                .padding(.horizontal, 16)
                                
                                // MARK: - Riwayat Jam Kerja
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Riwayat Jam Kerja")
                                        .font(.headline.weight(.semibold))
                                        .foregroundColor(.white)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(previousWorkHours, id: \.self) { work in
                                                VStack {
                                                    Text(formattedDate(from: work))
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                    
                                                    Text(work)
                                                        .font(.subheadline.weight(.semibold))
                                                        .padding()
                                                        .frame(width: 180, height: 80)
                                                        .background(Color.white.opacity(0.9))
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                        .shadow(radius: 4)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                    }
                                }
                                .padding(.horizontal)
                                
                            }
                            .padding(.bottom, 40)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: ViewOffsetKey.self, value: proxy.frame(in: .named("scroll")).minY)
                                }
                            )
                            .onPreferenceChange(ViewOffsetKey.self) { value in
                                self.scrollOffset = value
                            }
                        }
                        .coordinateSpace(name: "scroll")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showLogoutAlert = true }) {
                            GradientIcon(systemName: "power", gradient: LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .padding(12)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }
                }
                .alert("Konfirmasi Logout", isPresented: $showLogoutAlert) {
                    Button("Batal", role: .cancel) { }
                    Button("Logout", role: .destructive) { viewModel.logout() }
                } message: {
                    Text("Apakah Anda yakin ingin logout?")
                }
                .sheet(isPresented: $showSignaturePad) {
                    SignaturePadView { signature, timestamp in
                        DispatchQueue.main.async {
                            if isTappedIn {
                                isTappedOut = true
                                isTappedIn = false
                            } else {
                                isTappedIn = true
                                isTappedOut = false
                            }
                            showSignaturePad = false
                        }
                    }
                }
                
            }
        }
    }
    // MARK: - Date Formatter Helper Function
    private func formattedDate(from work: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm - HH:mm"
        if let date = formatter.date(from: work) {
            formatter.dateFormat = "EEEE, d MMM yyyy"
            return formatter.string(from: date)
        }
        return "Tanggal tidak valid"
    }
    
    // MARK: - Preview
    struct DashboardDriverView_Previews: PreviewProvider {
        static var previews: some View {
            let previewAuthViewModel = AuthViewModel()
            previewAuthViewModel.user = UserModel(
                id: "2",
                email: "driver@nusatoyotetsu.com",
                password: "",
                userType: .driver
            )

            return DashboardDriverView(user: previewAuthViewModel.user!)
                .environmentObject(previewAuthViewModel) // Pastikan ini ada
        }
    }
}
