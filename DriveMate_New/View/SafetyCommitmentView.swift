import SwiftUI

struct SafetyCommitmentView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var commitments = [
        ("Gunakan Sabuk Pengaman", false),
        ("Tidak Menggunakan HP Saat Berkendara", false),
        ("Mematuhi Rambu Lalu Lintas", false),
        ("Tidak Berkendara Saat Mengantuk", false),
        ("Patuhi Kecepatan Maksimum", false),
        ("Periksa Kendaraan Sebelum Berkendara", false),
        ("Jaga Jarak Aman dengan Kendaraan Lain", false),
        ("Gunakan Lampu Sein Saat Berbelok", false),
        ("Tidak Mengemudi di Bawah Pengaruh Alkohol", false),
        ("Selalu Waspada terhadap Pejalan Kaki", false),
        ("Gunakan Helm Saat Mengendarai Motor", false),
        ("Pastikan Rem Berfungsi dengan Baik", false)
    ]
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var allChecked: Bool {
        return commitments.allSatisfy { $0.1 }
    }

    var body: some View {
        VStack {
            Text("Komitmen Keselamatan")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            Text("Keselamatan di jalan bukan hanya tentang aturan, tetapi juga tentang kepedulian. Mari kita berkendara dengan aman untuk diri sendiri dan orang lain.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(0..<commitments.count, id: \.self) { index in
                        HStack {
                            Image(systemName: commitments[index].1 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(commitments[index].1 ? .green : .red)
                                .font(.title)
                                .scaleEffect(commitments[index].1 ? 1.2 : 1.0)
                                .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.3), value: commitments[index].1)

                            Text(commitments[index].0)
                                .font(.headline)
                                .foregroundColor(.primary)

                            Spacer()

                            Toggle("", isOn: $commitments[index].1)
                                .labelsHidden()
                                .animation(.easeInOut(duration: 0.3), value: commitments[index].1)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        .shadow(radius: 3)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3), value: commitments[index].1)
                    }
                }
                .padding()
            }

            Button(action: {
                if allChecked {
                    alertMessage = "Terima kasih telah berkomitmen terhadap keselamatan berkendara!"
                } else {
                    alertMessage = "Mohon pastikan semua komitmen telah dipilih sebelum mengirim."
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
        .navigationTitle("Safety Commitment")
    }
}

struct SafetyCommitmentView_Previews: PreviewProvider {
    static var previews: some View {
        SafetyCommitmentView()
    }
}
