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
        
        // Simpan layer asli
        let originalLayer = captureSecuredView?.layer
        
        // Tukar dengan layer yang ingin diamankan
        captureSecuredView?.setValue(self, forKey: "layer")
        
        uiKitTextField.isSecureTextEntry = false
        uiKitTextField.isSecureTextEntry = true
        
        // Kembalikan layer asli
        captureSecuredView?.setValue(originalLayer, forKey: "layer")
        
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
                    self.removeProtectionComponent()
                    replacementView?.alpha = 0
                }
            }
        }
    }
    
    func removeProtectionComponent() {
        uiKitTextField.isSecureTextEntry = false
        uiKitTextField.leftView = nil
        uiKitTextField.leftViewMode = .never
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
