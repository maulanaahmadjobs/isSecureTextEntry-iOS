// File: CALayer+PrivacyProtection.swift
import UIKit

private let uiKitTextField = UITextField()
private var captureSecuredViews: UIView?

// MARK: - CALayer Extension (DIPERBAIKI)
public extension CALayer {
    func makeHiddenOnCapture(withCustomView customView: UIView? = nil) {
        
        // Cari LayoutCanvasView
        let captureSecuredView: UIView? = captureSecuredViews
        ?? uiKitTextField.subviews
            .first(where: { NSStringFromClass(type(of: $0)).contains("LayoutCanvasView") })
        
        print(" INI 1 \(String(describing: captureSecuredView))") // Sama
        // Simpan layer asli
        let originalLayer = captureSecuredView?.layer
        print(" INI originalLayer 2 \(String(describing: originalLayer))")

        // Tukar dengan layer yang ingin diamankan
        captureSecuredView?.setValue(self, forKey: "layer")
        print(" INI 3 \(String(describing: captureSecuredView?.setValue(self, forKey: "layer")))")

        
//        uiKitTextField.isSecureTextEntry = false
        print(" INI 4 \(uiKitTextField.isSecureTextEntry)")

//        uiKitTextField.isSecureTextEntry = true
        print(" INI 5 \(uiKitTextField.isSecureTextEntry)")

        // Kembalikan layer asli
        captureSecuredView?.setValue(originalLayer, forKey: "layer")
        print(" INI 6 \(String(describing: captureSecuredView?.setValue(originalLayer, forKey: "layer")))")

//        uiKitTextField.leftView = captureSecuredView
        
        if let customView = customView {
            // Ada custom view, gunakan itu
            uiKitTextField.leftView = customView
            uiKitTextField.leftViewMode = .always
            
            // Setup replacement view agar sejajar
            setupReplacementView(customView)
            
            print("Layer dilindungi DENGAN custom view")
        } else {
            // Tidak ada custom view full view black
            uiKitTextField.leftView = captureSecuredView
            uiKitTextField.leftViewMode = .always
            
            print("Layer dilindungi TANPA custom view (hitam)")
        }
    }
    
    /// Setup replacement view agar sejajar dengan konten asli
    private func setupReplacementView(_ replacementView: UIView) {
        guard let parentView = self.delegate as? UIView else {
            print("Tidak bisa mendapatkan parent view")
            return
        }
        
        guard let superview = parentView.superview else {
            print("Parent view tidak punya superview")
            return
        }
        
        // Setup replacement view
        replacementView.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(replacementView)
        
        // Pin ke posisi yang SAMA PERSIS dengan konten asli
        NSLayoutConstraint.activate([
            replacementView.topAnchor.constraint(equalTo: parentView.topAnchor),
            replacementView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            replacementView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            replacementView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
        
        replacementView.alpha = 0 // Transparan saat normal
        
        // Deteksi saat akan screenshot
        observeScreenCapture(replacementView: replacementView)
    }
    
    /// Observasi screenshot dan tampilkan replacement
    private func observeScreenCapture(replacementView: UIView? = nil) {
        // Saat user ambil screenshot
        NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { [weak replacementView] _ in
            // Flash replacement sebentar
            UIView.animate(withDuration: 0.1) {
                replacementView?.alpha = 1
                print("Record 0")

            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.2) {
                    print("Record 3")
                    replacementView?.alpha = 0
                }
            }
        }
        
        /// Deteksi saat screen recording dimulai
        if #available(iOS 11.0, *) {
            NotificationCenter.default.addObserver(
                forName: UIScreen.capturedDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak replacementView] _ in
                if UIScreen.main.isCaptured {
                    replacementView?.alpha = 1
                    print("Record 1")
                } else {
                    print("Record 2")
                    replacementView?.alpha = 0
                }
            }
        }
    }
    
    func removeProtectionComponent() {
        uiKitTextField.isSecureTextEntry = false
        uiKitTextField.leftView?.removeFromSuperview()
        uiKitTextField.leftView = nil
        uiKitTextField.leftViewMode = .never
        
        uiKitTextField.text = nil
        uiKitTextField.removeFromSuperview()
    }
}

// MARK: - UIWindow Extension
public extension UIView {
    // Menutupi seluruh view (layer dari self)
    func enableProtectionWithBlackScreen() {
        self.layer.makeHiddenOnCapture()
    }
    
    func enableProtectionWithCustom(withCustomView componentView: UIView) {
        self.layer.makeHiddenOnCapture(withCustomView: componentView)
    }

    func removeProtectionComponent() {
        self.layer.removeProtectionComponent()
    }
}

struct ScureScreen {
    
    /// Tambahkan overlay keamanan ke view
    /// - Parameters:
    ///   - scureView: View yang ingin dilindungi (misal: passwordTextField)
    ///   - customView: Custom view yang muncul saat screenshot/recording (misal: showPrivacyOverlay())
    func addScureContent(withSecureView scureView: UIView, withCustomView customView: UIView? = nil) {
    
        guard let parentView = scureView.superview else {
            print("Parent view tidak punya superview")
            return
        }
        
        // Hapus existing secure view jika ada
        parentView.viewWithTag(8888)?.removeFromSuperview()
        
        // Buat overlay view
//        let overlay = withCustomView? ?? self.UIView()  // ← YOUR DESIGN sebagai default!
        var overlay: UIView
        if let customView = customView {
            overlay = customView
        } else {
            // Default: view hitam
            overlay = UIView()
            overlay.backgroundColor = .black
        }

        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.tag = 8888
        
//        parentView.addSubview(overlay)
        
        var targetView: UIView
        if let parentView = scureView.superview {
            targetView = parentView
            parentView.addSubview(overlay)
            
            NSLayoutConstraint.activate([
                overlay.topAnchor.constraint(equalTo: scureView.topAnchor),
                overlay.leadingAnchor.constraint(equalTo: scureView.leadingAnchor),
                overlay.trailingAnchor.constraint(equalTo: scureView.trailingAnchor),
                overlay.bottomAnchor.constraint(equalTo: scureView.bottomAnchor)
            ])
        } else {
            
            targetView = scureView
            scureView.addSubview(overlay)
            
            NSLayoutConstraint.activate([
                overlay.topAnchor.constraint(equalTo: scureView.topAnchor),
                overlay.leadingAnchor.constraint(equalTo: scureView.leadingAnchor),
                overlay.trailingAnchor.constraint(equalTo: scureView.trailingAnchor),
                overlay.bottomAnchor.constraint(equalTo: scureView.bottomAnchor)
            ])
        }
        
        overlay.alpha = 0 // Transparant saat normal
        observeScreenCaptures(secureView: overlay)
        
        print("Secure overlay ditambahkan - Custom: \(customView != nil)")

    }
    
    /// Observasi screenshot dan recording
    private func observeScreenCaptures(secureView: UIView? = nil) {
        // Saat user ambil screenshot
        NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { [weak secureView] _ in
            // Flash replacement sebentar
            
//            UIView.animate(withDuration: 0.1) {
//                secureView?.alpha = 1
//                print("Screenshot terdeteksi")
//            } completion: { _ in
//                UIView.animate(withDuration: 0.3, delay: 0.2) {
//                    secureView?.alpha = 0
//                    print("Screenshot selesai")
//                }
//            }
            // Langsung tampilkan
//            DispatchQueue.main.async {  // Pindah ke main thread
//                    secureView?.alpha = 1
//                    print("Screenshot terdeteksi")
//                }
            
                secureView?.alpha = 1
                print("Screenshot terdeteksi")
//                
                // Kembalikan setelah delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    secureView?.alpha = 0
                    print("Screenshot selesai")
                }
        }
        
        /// Deteksi saat screen recording dimulai
        if #available(iOS 11.0, *) {
            NotificationCenter.default.addObserver(
                forName: UIScreen.capturedDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak secureView] _ in
                if UIScreen.main.isCaptured {
                    secureView?.alpha = 1
                    print("Screen recording dimulai")
                } else {
                    print("Screen recording berhenti")
                    secureView?.alpha = 0
                }
            }
        }
    }
    
    /// Hapus secure overlay dari parent view
    func removeSecureContent(from parentView: UIView) {
        parentView.viewWithTag(8888)?.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
        print("Secure content dihapus")
    }
}

// MARK: - UIView Extension (Helper Methods)
public extension UIView {
    
    /// Lindungi view dengan overlay hitam saat screenshoot/recording
    func enableSecureWithBlackScreen() {
        ScureScreen().addScureContent(withSecureView: self, withCustomView: nil)
    }
    
    /// Lindungi view dengan custom view saat screenshoot/recording
    ///  - Parameter customView: View yang akan muncul saat screenshot/recording
    func enableSecureWithCustomView(_ customView: UIView) {
        ScureScreen().addScureContent(withSecureView: self, withCustomView: customView)
    }
    
    /// Hapus proteksi dari view
    func removeSecureProtection() {
        guard let parent = self.superview else { return }
        ScureScreen().removeSecureContent(from: parent)
    }
}
