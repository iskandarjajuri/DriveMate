import SwiftUI

/// **SignaturePadView** - Tampilan utama untuk presensi berbasis tanda tangan.
/// Menyediakan opsi Tap In dan Tap Out dengan validasi tanda tangan.
struct SignaturePadView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var signature: UIImage? = nil
    @State private var selectedOption: PresenceType? = nil
    @State private var showAlert = false
    @State private var isTappedIn = false
    @State private var isTappedOut = false
    @State private var isProcessing = false
    @State private var successMessage: String? = nil
    
    var onComplete: (UIImage?, Date) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Presensi")
                .font(.title.weight(.bold))
                .foregroundColor(.primary)
                .padding(.top, 20)
            
            // Pilihan Presensi
            Picker("Pilih Presensi", selection: $selectedOption) {
                Text("Masuk").tag(PresenceType.checkIn as PresenceType?)
                Text("Keluar").tag(PresenceType.checkOut as PresenceType?)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .disabled(isTappedIn && selectedOption == .checkIn)
            
            if selectedOption == .checkOut {
                Text("Silakan tanda tangan untuk presensi keluar")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(radius: 8)
                        .frame(height: 250)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )

                    SignatureCanvas(signature: $signature)
                        .frame(height: 250)
                }
                .padding(.horizontal)
                .overlay(
                    VStack {
                        Text("Silakan tanda tangan di area ini")
                            .font(.footnote)
                            .foregroundColor(.gray.opacity(0.8))
                            .padding(.top, 5)
                    },
                    alignment: .top
                )
            }
            
            if let message = successMessage {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding(.top, 10)
                    .transition(.opacity)
            }
            
            HStack(spacing: 16) {
                Button(action: {
                    guard !isProcessing else { return }
                    isProcessing = true
                    print("📌 Proses Tap \(selectedOption == .checkIn ? "In" : "Out") dimulai...")

                    if selectedOption == .checkOut && signature == nil {
                        showAlert = true
                        isProcessing = false
                        print("⚠️ Gagal: Tap Out memerlukan tanda tangan.")
                    } else {
                        let currentDate = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "EEEE, dd MMM yyyy - HH:mm:ss"
                        let formattedDate = formatter.string(from: currentDate)
                        
                        DispatchQueue.main.async {
                            print("✅ Tap \(selectedOption == .checkIn ? "In" : "Out") berhasil pada \(formattedDate)")
                            onComplete(signature, currentDate)

                            if selectedOption == .checkIn {
                                isTappedIn = true
                                isTappedOut = false
                            } else if selectedOption == .checkOut {
                                isTappedOut = true
                                isTappedIn = false
                            }

                            isProcessing = false

                            // Hapus pesan sukses setelah beberapa detik
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                successMessage = nil
                            }

                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    Label(selectedOption == .checkOut ? "Tap Out" : "Tap In", systemImage: selectedOption == .checkOut ? "checkmark.circle.fill" : "arrow.right.circle.fill")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedOption == .checkOut
                            ? (isTappedOut ? Color.green.opacity(0.5) : Color.green.opacity(0.85))
                            : (isTappedIn ? Color.blue.opacity(0.5) : Color.blue.opacity(0.85))
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 5)
                        .scaleEffect(isProcessing ? 0.95 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: isProcessing)
                }
                .disabled((selectedOption == .checkIn && isTappedIn) || (selectedOption == .checkOut && isTappedOut))
                .padding(.horizontal)
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Tanda Tangan Diperlukan"), message: Text("Silakan tanda tangan sebelum submit."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // MARK: - Enum Presence Type
    enum PresenceType {
        case checkIn
        case checkOut
    }
    
    // MARK: - Signature Canvas
    struct SignatureCanvas: UIViewRepresentable {
        @Binding var signature: UIImage?
        
        class Coordinator: NSObject {
            var parent: SignatureCanvas
            var path = UIBezierPath()
            var shapeLayer = CAShapeLayer()
            
            init(parent: SignatureCanvas) {
                self.parent = parent
                super.init()
            }
            
            /// **Mengupdate jalur gambar tanda tangan saat pengguna menggambar.**
            func updatePath() {
                shapeLayer.path = path.cgPath
            }
            
            /// **Menyimpan tanda tangan ke dalam format gambar (UIImage).**
            /// - Parameter view: UIView yang menampung tanda tangan.
            func updateSignatureImage(view: UIView) {
                UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
                parent.signature = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                print("📸 Tanda tangan berhasil disimpan sebagai gambar.")
            }
            
            @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
                guard let view = gesture.view else { return }
                let touchPoint = gesture.location(in: view)
                
                switch gesture.state {
                case .began:
                    print("✏️ Tanda tangan dimulai di titik: \(touchPoint)")
                    path.move(to: touchPoint)
                case .changed:
                    path.addLine(to: touchPoint)
                    updatePath()
                case .ended:
                    print("✅ Tanda tangan selesai.")
                    updateSignatureImage(view: view)
                default:
                    break
                }
            }
        }
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
        }
        
        func makeUIView(context: Context) -> UIView {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            
            let shapeLayer = context.coordinator.shapeLayer
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.lineWidth = 3
            shapeLayer.fillColor = nil
            shapeLayer.lineJoin = .round
            shapeLayer.lineCap = .round
            view.layer.addSublayer(shapeLayer)
            
            let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.panGesture(_:)))
            panGesture.maximumNumberOfTouches = 1
            view.addGestureRecognizer(panGesture)
            
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {}
    }
    
    // MARK: - Preview
    struct SignaturePadView_Previews: PreviewProvider {
        static var previews: some View {
            SignaturePadView { _, _ in }
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
    }
}
