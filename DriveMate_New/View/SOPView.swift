import SwiftUI

struct SOPView: View {
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            List {
                // MARK: - Keselamatan (Safety)
                Section(header: Text("Keselamatan")
                    .font(.headline)
                    .foregroundColor(.blue)) {
                    
                    SOPRow(icon: "car.side.fill", title: "Periksa Kendaraan", description: "Pastikan kendaraan dalam kondisi prima sebelum berangkat.", color: .blue)
                    
                    SOPRow(icon: "shield.fill", title: "Gunakan Sabuk Pengaman", description: "Selalu gunakan sabuk pengaman dan pastikan penumpang juga menggunakannya.", color: .red)
                    
                    SOPRow(icon: "speedometer", title: "Patuhi Batas Kecepatan", description: "Jangan melebihi batas kecepatan yang telah ditentukan.", color: .orange)
                    
                    SOPRow(icon: "phone.down.fill", title: "Hindari Penggunaan Ponsel", description: "Gunakan hands-free jika perlu menerima panggilan.", color: .purple)
                    
                    SOPRow(icon: "cloud.rain.fill", title: "Berhati-hati di Cuaca Ekstrem", description: "Kurangi kecepatan saat hujan atau kondisi jalan licin.", color: .gray)
                }
                
                // MARK: - Keramahan (Hospitality)
                Section(header: Text("Keramahan")
                    .font(.headline)
                    .foregroundColor(.green)) {
                    
                    SOPRow(icon: "hand.wave.fill", title: "Sapa dengan Ramah", description: "Selalu menyapa penumpang atau pelanggan dengan senyuman.", color: .green)
                    
                    SOPRow(icon: "bubble.left.and.bubble.right.fill", title: "Berkomunikasi dengan Baik", description: "Gunakan bahasa yang sopan dan profesional.", color: .blue)
                    
                    SOPRow(icon: "hand.thumbsup.fill", title: "Bantu Penumpang", description: "Jika diperlukan, bantu penumpang memasukkan atau mengeluarkan barang.", color: .yellow)
                }
                
                // MARK: - Tanggung Jawab Pengemudi
                Section(header: Text("Tanggung Jawab Pengemudi")
                    .font(.headline)
                    .foregroundColor(.orange)) {
                    
                    SOPRow(icon: "clock.fill", title: "Datang Tepat Waktu", description: "Pastikan selalu datang sesuai jadwal.", color: .cyan)
                    
                    SOPRow(icon: "doc.text.fill", title: "Lengkapi Dokumen Perjalanan", description: "Pastikan surat-surat kendaraan dan identitas tersedia setiap saat.", color: .brown)
                    
                    SOPRow(icon: "fuelpump.fill", title: "Isi Bahan Bakar Sesuai Prosedur", description: "Pastikan kendaraan memiliki bahan bakar yang cukup sebelum perjalanan.", color: .blue)
                    
                    SOPRow(icon: "wrench.and.screwdriver.fill", title: "Lapor Kendala Teknis", description: "Segera laporkan jika ada kerusakan atau masalah pada kendaraan.", color: .gray)
                    
                    SOPRow(icon: "heart.fill", title: "Jaga Kesehatan", description: "Pastikan dalam kondisi sehat dan fit sebelum mengemudi.", color: .red)
                }
            }
            .navigationTitle("SOP Pengemudi")
            
            // Tombol Mengerti
            Button(action: {
                showAlert = true
            }) {
                Text("Mengerti")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Terima Kasih"),
                    message: Text("Anda telah memahami SOP Pengemudi."),
                    dismissButton: .default(Text("OK")) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
}

// MARK: - SOP Row Component
struct SOPRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Preview
struct SOPView_Previews: PreviewProvider {
    static var previews: some View {
        SOPView()
    }
}
