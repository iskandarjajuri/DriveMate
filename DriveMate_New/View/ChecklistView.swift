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
                                .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.3), value: checklistItems[index].1)

                            Text(checklistItems[index].0)
                                .font(.headline)
                                .foregroundColor(.primary)

                            Spacer()

                            Toggle("", isOn: $checklistItems[index].1)
                                .labelsHidden()
                                .animation(.easeInOut(duration: 0.3), value: checklistItems[index].1)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        .shadow(radius: 3)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3), value: checklistItems[index].1)
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }

            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Checklist")
    }
}

struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView()
    }
}
