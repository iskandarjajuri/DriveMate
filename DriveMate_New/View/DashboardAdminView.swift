import SwiftUI
import UIKit

// MARK: - Main Dashboard View
struct DashboardAdminView: View {
    // MARK: - Properties
    let user: UserModel
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showLogoutAlert = false
    @State private var profileScale: CGFloat = 1.0
    @State private var profileBlur: CGFloat = 0.0
    @Namespace var scrollNamespace
    @State private var scrollOffset: CGFloat = 0
    @State private var showDownloadSuccess = false
    @State private var downloadedFileURL: URL?
    @State private var isNavigating = false
    
    let reports: [DriverReport] = sampleReports
    
    // MARK: - UI Constants
    private let brandColor = Color(red: 0.1, green: 0.35, blue: 0.7)
    private let gradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.3, green: 0.7, blue: 1.0), Color(red: 0.1, green: 0.4, blue: 0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Main Body
    var body: some View {
        if viewModel.isCheckingAuth {
            ProgressView("Memeriksa sesi...")
        } else if !viewModel.isLoggedIn || viewModel.userType != "admin" {
            LoginView()
        } else {
            NavigationStack {
                ZStack {
                    gradient.ignoresSafeArea()
                    
                    // MARK: - Scroll Content
                    ScrollViewReader { proxy in
                        ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 30) {
                                
                                // MARK: - Header Section
                                GeometryReader { geo in
                                    let minY = geo.frame(in: .named("scroll")).minY
                                    VStack(spacing: 15) {
                                        // Profile Image
                                        Image(systemName: "person.crop.circle.fill")
                                            .font(.system(size: 80))
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(
                                                .white,
                                                AngularGradient(
                                                    gradient: Gradient(colors: [brandColor, .white]),
                                                    center: .center
                                                )
                                            )
                                            
                                        
                                        // User Info
                                        VStack(spacing: 5) {
                                            Text("Dashboard Admin")
                                                .font(.title2.weight(.black))
                                                .foregroundColor(.white)
                                            
                                            Text(user.email)
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.9))
                                        }
                                    }
                                    .frame(width: geo.size.width, height: 280 + (minY > 0 ? minY : 0))
                                }
                                .frame(height: 280)
                                .id("header")
                                
                                // MARK: - Features Grid
                                LazyVGrid(
                                    columns: [GridItem(.adaptive(minimum: 160), spacing: 20)],
                                    spacing: 20
                                ) {
                                    FeatureTile(
                                        title: "Live Tracking",
                                        icon: "location.north.line.fill",
                                        color: brandColor,
                                        destination: LiveLocationView()
                                    )
                                    .id("liveTracking")
                                    .transaction { $0.animation = nil }
                                    
                                    FeatureTile(
                                        title: "Reports",
                                        icon: "chart.bar.doc.horizontal",
                                        color: .green,
                                        destination: ReportsView(reports: reports)
                                    )
                                    .id("reports")
                                    .transaction { $0.animation = nil }
                                    
                                    Button(action: {
                                        isNavigating = true
                                        downloadReports()
                                    }) {
                                        FeatureTileContent(
                                            title: "Download Reports",
                                            icon: "arrow.down.doc.fill",
                                            color: .indigo
                                        )
                                    }
                                    .id("download")
                                    .transaction { $0.animation = nil }
                                }
                                .contentMargins(.horizontal, 16, for: .scrollContent)
                                .padding(.horizontal, 16)
                                
                                // MARK: - Recent Reports
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Recent Reports")
                                        .font(.headline.weight(.semibold))
                                        .foregroundColor(.white)
                                        .contentMargins(.horizontal, 16, for: .scrollContent)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(reports) { report in
                                                ReportCard(report: report)
                                                    .frame(width: 280, height: 150)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .animation(.easeOut(duration: 0.15), value: reports.count) // ✅ Lebih cepat
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.bottom, 40)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .preference(
                                            key: ViewOffsetKey.self,
                                            value: proxy.frame(in: .named("scroll")).minY
                                        )
                                }
                            )
                            .onPreferenceChange(ViewOffsetKey.self) { value in
                                if abs(scrollOffset - value) > 30 { // ✅ Hanya update jika perubahan cukup besar
                                    print("Scroll Offset: \(value)") // ✅ Debugging perubahan scroll
                                    self.scrollOffset = value
                                }
                            }
                        }
                        .coordinateSpace(name: "scroll")
                        .contentMargins(.top, 16, for: .scrollContent)
                        .animation(nil, value: isNavigating)
                    }
                }
                
                // MARK: - Toolbar
                #if os(iOS)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showLogoutAlert = true }) {
                            GradientIcon(
                                systemName: "power",
                                gradient: LinearGradient(
                                    colors: [.red, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .padding(12)
                            .background(Color.white.opacity(0.2), in: Circle()) // ✅ Lebih ringan untuk emulator
                        }
                    }
                }
                #endif
                
                // MARK: - Alert
                .alert("Konfirmasi Logout", isPresented: $showLogoutAlert) {
                    Button("Batal", role: .cancel) { }
                    Button("Logout", role: .destructive) { logout() }
                } message: {
                    Text("Apakah Anda yakin ingin logout?")
                }
                .alert("✅ Laporan berhasil disimpan!", isPresented: $showDownloadSuccess, actions: {
                    Button("Buka File") {
                        if let fileURL = downloadedFileURL {
                            #if os(macOS)
                            NSWorkspace.shared.open(fileURL)
                            #else
                            UIApplication.shared.open(fileURL)
                            #endif
                        }
                    }
                    Button("Tutup", role: .cancel) { }
                }, message: {
                    if let fileURL = downloadedFileURL {
                        Text("File disimpan di:\n\(fileURL.path)")
                    }
                })
            }
        }
    }
    
    // MARK: - Methods
    private func downloadReports() {
        ReportDownloader.generateCSV(for: reports) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fileURL):
                    downloadedFileURL = fileURL
                    showDownloadSuccess = true
                    print("✅ File berhasil disimpan di \(fileURL)")
                case .failure(let error):
                    print("❌ Gagal mendownload laporan: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func logout() {
        viewModel.logout()
    }
}

// MARK: - Scroll Tracking
struct ViewOffsetKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

// MARK: - Preview
struct DashboardAdminView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardAdminView(user: UserModel(id: "1", email: "admin@nusatoyotetsu.com", password: "", userType: .admin))
            .environmentObject(AuthViewModel())
    }
}

// MARK: - Custom Components
struct FeatureTileContent: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.9))
                .clipShape(Circle())
            
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 140)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: color.opacity(0.2), radius: 16, x: 0, y: 8)
        )
        #if os(iOS)
        .hoverEffect(.lift)
        #endif
    }
}

struct FeatureTile<Destination: View>: View {
    let title: String
    let icon: String
    let color: Color
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            FeatureTileContent(title: title, icon: icon, color: color)
        }
        .buttonStyle(ScaleButtonStyle())
        .transaction { $0.animation = nil }
    }
}

struct ReportCard: View {
    let report: DriverReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.white)
                Text(report.driverName)
                    .font(.subheadline.weight(.medium))
                
                Spacer()
                
                StatusIndicator(health: report.healthCondition)
            }
            
            Divider().background(Color.white.opacity(0.2))
            
            HStack {
                InfoBadge(title: "Kebersihan", value: report.cleanliness)
                InfoBadge(title: "Jam Kerja", value: report.workingHours)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1) // ✅ Lebih ringan
        )
        .padding(.horizontal)
    }
}

struct StatusIndicator: View {
    let health: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(health == "Sehat" ? Color.green : Color.orange)
                .frame(width: 10, height: 10)
            
            Text(health)
                .font(.caption2)
                .foregroundColor(.white)
        }
        .padding(6)
        .background(Capsule().fill(Color.black.opacity(0.2)))
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct GradientIcon: View {
    let systemName: String
    let gradient: LinearGradient
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(gradient)
            .frame(width: 36, height: 36)
    }
}
