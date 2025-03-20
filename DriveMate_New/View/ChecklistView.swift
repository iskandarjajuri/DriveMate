import SwiftUI

struct ChecklistView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var checklistItems = [
        ("Lampu Berfungsi", false),
        ("Ban Dalam Kondisi Baik", false),
        ("Rem Berfungsi", false),
        ("Klakson Berfungsi", false),
        ("Bahan Bakar Cukup", false),
        ("Wiper Berfungsi", false),
        ("Spion Tidak Pecah", false),
        ("AC Dingin", false),
        ("Oli Mesin Cukup", false),
        ("Sistem Kelistrikan Aman", false)
    ]
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isNavigating = false

    var allChecked: Bool {
        return checklistItems.allSatisfy { $0.1 }
    }

    var body: some View {
        VStack {
            Text("Checklist Kendaraan")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(0..<checklistItems.count, id: \.self) { index in
                        HStack {
                            Image(systemName: checklistItems[index].1 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(checklistItems[index].1 ? .green : .red)
                                .font(.title)
                                .scaleEffect(checklistItems[index].1 ? 1.2 : 1.0)
                            
                            Text(checklistItems[index].0)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Toggle("", isOn: $checklistItems[index].1)
                                .labelsHidden()
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1) // ✅ Shadow lebih ringan
                        .animation(nil, value: checklistItems[index].1) // ✅ Hanya satu animasi
                    }
                }
                .padding()
            }
            
            Button(action: {
                if allChecked {
                    alertMessage = "Checklist berhasil dikirim! Terima kasih telah melakukan pemeriksaan kendaraan."
                } else {
                    alertMessage = "Mohon pastikan semua item checklist sudah diperiksa sebelum mengirim."
                }
                showAlert = true
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(allChecked ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(!allChecked)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Feedback"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        withTransaction(Transaction(animation: nil)) { // ✅ Menghindari animasi berlebih
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }

            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Checklist")
        .transaction { $0.animation = nil } // ✅ Menghindari animasi lambat
    }
}

struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView()
    }
}
