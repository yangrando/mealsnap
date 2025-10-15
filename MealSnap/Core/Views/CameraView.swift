//
//  CameraView.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 24/09/25.
//
import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    
    @Binding var capturedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraVC = CameraViewController()
        cameraVC.onPhotoCaptured = { image in
            self.capturedImage = image
            self.presentationMode.wrappedValue.dismiss()
        }
        return cameraVC
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
    }
}

struct CameraViewWithUI: View {
    @Binding var capturedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    @State private var showingFlash = false
    
    var body: some View {
        ZStack {
            CameraView(capturedImage: $capturedImage)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("camera_cancel_button")
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Spacer()
                
                VStack(spacing: 20) {
                    Text("camera_instruction")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .background(Color.black.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            takePhoto()
                        }) {
                            ZStack {
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                                    .frame(width: 80, height: 80)
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                    .scaleEffect(showingFlash ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.1), value: showingFlash)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(.bottom, 40)
            }
            
            if showingFlash {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                    .animation(.easeInOut(duration: 0.2), value: showingFlash)
            }
        }
    }
    
    private func takePhoto() {
        withAnimation {
            showingFlash = true
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            showingFlash = false
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            findCameraViewController(in: rootVC)?.takePhoto()
        }
    }
    
    private func findCameraViewController(in viewController: UIViewController) -> CameraViewController? {
        if let cameraVC = viewController as? CameraViewController {
            return cameraVC
        }
        
        for child in viewController.children {
            if let found = findCameraViewController(in: child) {
                return found
            }
        }
        
        if let presented = viewController.presentedViewController {
            return findCameraViewController(in: presented)
        }
        
        return nil
    }
}

struct SafeCameraView: View {
    @Binding var capturedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    @State private var cameraError: String?
    
    var body: some View {
        Group {
            if let error = cameraError {
                VStack(spacing: 20) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("camera_error_title")
                        .font(.title2)
                        .bold()
                    
                    Text(error)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("camera_error_close_button")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 40)
                }
                .onAppear {
                    checkCameraPermission()
                }
            } else {
                CameraViewWithUI(capturedImage: $capturedImage)
                    .onAppear {
                        checkCameraPermission()
                    }
            }
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied, .restricted:
            cameraError = NSLocalizedString("camera_permission_denied", comment: "")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if !granted {
                        cameraError = NSLocalizedString("camera_permission_denied", comment: "")
                    }
                }
            }
        case .authorized:
            cameraError = nil
        @unknown default:
            cameraError = NSLocalizedString("camera_error_unknown", comment: "")
        }
    }
}
