import SwiftUI

struct SOPView: View {
    @State private var showAlert = false
    @State private var isNavigating = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) { // ✅ LazyVStack untuk menghindari re-render berlebih
                    // MARK: - Keselamatan (Safety)
                    Section(header: Text("Keselamatan")
                        .font(.headline)
                        .foregroundColor(.blue)) {
                        
                        SOPRow(icon: "car.side.fill", title: "Periksa Kendaraan", description: "Pastikan kendaraan dalam kondisi prima sebelum berangkat.", color: .blue).id(UUID())

                        SOPRow(icon: "shield.fill", title: "Gunakan Sabuk Pengaman", description: "Selalu gunakan sabuk pengaman dan pastikan penumpang juga menggunakannya.", color: .red).id(UUID())

                        SOPRow(icon: "speedometer", title: "Patuhi Batas Kecepatan", description: "Jangan melebihi batas kecepatan yang telah ditentukan.", color: .orange).id(UUID())
                    }

                    // MARK: - Keramahan (Hospitality)
                    Section(header: Text("Keramahan")
                        .font(.headline)
                        .foregroundColor(.green)) {
                        
                        SOPRow(icon: "hand.wave.fill", title: "Sapa dengan Ramah", description: "Selalu menyapa penumpang atau pelanggan dengan senyuman.", color: .green).id(UUID())

                        SOPRow(icon: "bubble.left.and.bubble.right.fill", title: "Berkomunikasi dengan Baik", description: "Gunakan bahasa yang sopan dan profesional.", color: .blue).id(UUID())
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("SOP Pengemudi")
            .transaction { $0.animation = nil } // ✅ Menghindari animasi berlebih
            
            // Tombol Mengerti
            Button(action: {
                showAlert = true
            }) {
                Text("Mengerti")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.blue
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1) // ✅ Shadow lebih ringan
                    )
                    .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Terima Kasih"),
                    message: Text("Anda telah memahami SOP Pengemudi."),
                    dismissButton: .default(Text("OK")) {
                        withTransaction(Transaction(animation: nil)) { // ✅ Menghindari animasi berlebih
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
