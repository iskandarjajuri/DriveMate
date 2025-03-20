import SwiftUI
import UIKit

enum PresenceType {
    case checkIn
    case checkOut
}

struct SignaturePadView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var signature: UIImage? = nil
    @State private var selectedOption: PresenceType? = nil
    @State private var showAlert = false
    @State private var isTappedIn = false
    @State private var isTappedOut = false
    @State private var isProcessing = false
    @State private var successMessage: String? = nil
    @State private var isNavigating = false
    
    var onComplete: (UIImage?, Date) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Presensi")
                .font(.title.weight(.bold))
                .foregroundColor(.primary)
                .padding(.top, 20)
            
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
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1) // ✅ Shadow lebih ringan
                        .frame(height: 250)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )

                    SignatureCanvas(signature: $signature)
                        .frame(height: 250)
                }
                .padding(.horizontal)
            }
            
            if let message = successMessage {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding(.top, 10)
                    .transition(.opacity)
                    .animation(nil, value: isNavigating)
            }
            
            HStack(spacing: 16) {
                Button(action: {
                    guard !isProcessing else { return }
                    isProcessing = true

                    if selectedOption == .checkOut && signature == nil {
                        showAlert = true
                        isProcessing = false
                    } else {
                        let currentDate = Date()

                        DispatchQueue.main.async {
                            onComplete(signature, currentDate)

                            if selectedOption == .checkIn {
                                isTappedIn = true
                                isTappedOut = false
                            } else if selectedOption == .checkOut {
                                isTappedOut = true
                                isTappedIn = false
                            }

                            isProcessing = false

                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withTransaction(Transaction(animation: nil)) { // ✅ Menghindari animasi berlebih
                                    successMessage = nil
                                }
                            }

                            isNavigating = true
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    Label(selectedOption == .checkOut ? "Tap Out" : "Tap In", systemImage: selectedOption == .checkOut ? "checkmark.circle.fill" : "arrow.right.circle.fill")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedOption == .checkOut ? Color.green.opacity(0.85) : Color.blue.opacity(0.85))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1) // ✅ Shadow lebih ringan
                        .scaleEffect(isProcessing ? 0.95 : 1.0)
                        .transaction { $0.animation = nil } // ✅ Mencegah animasi berlebih
                }
                .disabled((selectedOption == .checkIn && isTappedIn) || (selectedOption == .checkOut && isTappedOut))
                .padding(.horizontal)
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Tanda Tangan Diperlukan"), message: Text("Silakan tanda tangan sebelum submit."), dismissButton: .default(Text("OK")))
        }
        .presentationDetents([.medium])
    }
}

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

        @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
            let touchPoint = gesture.location(in: gesture.view)

            switch gesture.state {
            case .began:
                path.move(to: touchPoint)
            case .changed:
                path.addLine(to: touchPoint)
                shapeLayer.path = path.cgPath
            case .ended:
                parent.captureSignature(view: gesture.view!)
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
        view.backgroundColor = UIColor.white

        let shapeLayer = context.coordinator.shapeLayer
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.fillColor = nil
        shapeLayer.lineJoin = .round
        shapeLayer.lineCap = .round
        view.layer.addSublayer(shapeLayer)

        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.panGesture(_:)))
        view.addGestureRecognizer(panGesture)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func captureSignature(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
