//
//  ViewController.swift
//  isSecureTextEntry iOS
//
//  Created by west on 28/10/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let uiKitTextFields = UITextField()
    private var captureSecuredViews: UIView?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var secureOverlay: UIView?

    var window: UIWindow?

    lazy var  container = ScreenshotPreventingView()


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
        // ini berhasil background hitam
//        if view.window != nil {
//        view.window?.makeSecure()
//        }

// =======================START==========================================
        // Atau periksa seluruh window:
//        if let w = UIApplication.shared.windows.first {
//            w.printSubviewTree()
//        }
        
//        passwordTextField.debugPrintHierarchy()
// =======================END==========================================

        // 3. Terapkan makeHiddenOnCapture pada layer view tersebut
//        passwordTextField.layer.makeHiddenOnCapture()
//        view.hideOnScreenshot(views: keyboardView)
       
//        view.enableProtectionWithCustom(withCustomView: showPrivacyOverlay())
        
//        ScureScreen().addScureContent(withSecureView: passwordTextField, withCustomView: showPrivacyOverlay())
        
        
        // Componen tapi gak bisa di klik componen textField nya, cocok untuk image dan konten
//        ScureScreen().addScureContent(withSecureView: passwordTextField)
        
        // ini berhasil
//        view.enableSecureWithCustomView(showPrivacyOverlay())
        
//        passwordTextField.enableProtectionWithBlackScreen()
//        view.enableProtectionWithBlackScreen()
        
    }
    
    
    func printAllUITextFieldSubviews() {
        let textField = UITextField()
        textField.layoutIfNeeded() // Pastikan view sudah di-render
        
        print("=== ALL UITEXTFIELD SUBVIEWS ===")
        
        // Print subviews biasa
        print("\n📱 SUBVIEWS:")
        textField.subviews.enumerated().forEach { index, subview in
            let className = String(describing: type(of: subview))
            print("\(index). \(className)")
        }
        
        // Print dengan Mirror untuk akses private properties
        print("\n🔍 MIRROR REFLECTION (All Properties):")
        let mirror = Mirror(reflecting: textField)
        for child in mirror.children {
            if let propertyName = child.label {
                let valueType = type(of: child.value)
                print("Property: \(propertyName) | Type: \(valueType)")
            }
        }
    }
    
    private let keyboardView: MaomaoKeyboard = {
           let keyboard = MaomaoKeyboard()
           keyboard.translatesAutoresizingMaskIntoConstraints = false
           return keyboard
       }()
    
    func addToggleInsideTextField(withTextField textField: UITextField, action: Selector, systemName name: String) {
        let toggleButton = UIButton(type: .custom)
        toggleButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            config.image = UIImage(systemName: name)
            config.baseBackgroundColor = .gray
            toggleButton.configuration = config
        } else {
            // Fallback untuk iOS < 15
            toggleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8) // Padding
            toggleButton.tintColor = .gray
            toggleButton.setImage(UIImage(systemName: name), for: .normal)
        }
        
        toggleButton.addTarget(self, action: action, for: .touchUpInside)
        
        textField.rightView = toggleButton
        textField.rightViewMode = .always
        textField.isSecureTextEntry = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController")
//        window?.makeSecuresss()
        
        container.translatesAutoresizingMaskIntoConstraints = false
//        container.setup(contentView: emailTextField)
        
        // Setup keyboard delegate
        keyboardView.delegate = self
        
        // Add subviews
//        view.addSubview(keyboardView)
        
        // Atur ukuran keyboard
        let keyboardHeight: CGFloat = 300
        keyboardView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: keyboardHeight)
        
        // Set sebagai inputView untuk kedua textfield
//        passwordTextField.inputView = keyboardView
        
        view.backgroundColor = .white
        
        addToggleInsideTextField(withTextField: passwordTextField, action: #selector(togglePasswordVisibility), systemName: "eye.slash")
        
        // PENTING: Disable keyboard sistem iOS
        // Set inputView ke empty view agar keyboard sistem tidak muncul
//        passwordTextField.inputView = UIView()
        
        // Disable auto-correction dan spell checking
//        passwordTextField.autocorrectionType = .no
//        passwordTextField.spellCheckingType = .no
    }
       
    @objc func keyboardWilDisplay(notification: Notification) {
        if let keyboardFrame:NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardrectangle = keyboardFrame.cgRectValue
            let keyboardheight = keyboardrectangle.height
            
            // Cari keyboard view dalam hierarchy
//            if let keyboardView = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.subviews.first(where: {
//                String(describing: type(of: $0)).hasPrefix("UIInputSetContainer")
//            }) {
//                view.hideOnScreenshot(views: [keyboardView])
//            }
        }
        
        
    }

    @objc func togglePasswordVisibility( sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()

        if passwordTextField.isSecureTextEntry {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        
//        let currentText = passwordTextField.text
//        passwordTextField.text = ""
//        passwordTextField.text = currentText
        
    }
    
    func showPrivacyOverlay() -> UIView {
        let privacyView = UIView(frame: UIScreen.main.bounds)
        privacyView.backgroundColor = .systemBackground
        
        // Header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: privacyView.bounds.width, height: 100))
        headerView.backgroundColor = .secondarySystemBackground
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.frame = CGRect(x: 20, y: 50, width: 60, height: 30)
        closeButton.addTarget(self, action: #selector(dismissOverlay), for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.text = "Contact Info"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: headerView.center.x, y: 65)
        
        // Content
        let messageLabel = UILabel()
        messageLabel.text = "Screenshots are blocked for added privacy"
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.frame = CGRect(x: 40, y: 150, width: privacyView.bounds.width - 80, height: 80)
        
        // Lock Icon
        let lockIcon = UIImageView(image: UIImage(systemName: "lock.shield"))
        lockIcon.tintColor = .systemGray
        lockIcon.frame = CGRect(x: (privacyView.bounds.width - 60)/2, y: 250, width: 60, height: 60)
        
        privacyView.addSubview(headerView)
        privacyView.addSubview(closeButton)
        privacyView.addSubview(titleLabel)
        privacyView.addSubview(messageLabel)
        privacyView.addSubview(lockIcon)
        privacyView.tag = 1001
        
        // Add to window agar menutup seluruh screen
        if let window = view.window {
            window.addSubview(privacyView)
        }
        
        return privacyView
    }
    
    @objc private func dismissOverlay() {
        view.removeSecureProtection()
//        view.window?.viewWithTag(1001)?.removeFromSuperview()
    }
}

extension UIView {
    func printSubviewTree(indent: String = "") {
        // class name + memory address + frame
        let clsName = String(describing: type(of: self))
        print("\(indent)\(clsName) — \(Unmanaged.passUnretained(self).toOpaque()) frame=\(self.frame)")
        for sub in self.subviews {
            sub.printSubviewTree(indent: indent + "    \n")
        }
    }
}

extension UITextField {
    func debugPrintHierarchy() {
        print("=== UITEXTFIELD DEBUG HIERARCHY ===")
        print("Frame: \(frame)")
        print("Bounds: \(bounds)")
        print("Subviews count: \(subviews.count)")
        
        subviews.enumerated().forEach { index, subview in
            let className = String(describing: type(of: subview))
            print("\n🎯 Subview \(index): \(className)")
            print("   - Frame: \(subview.frame)")
            print("   - Hidden: \(subview.isHidden)")
            print("   - Alpha: \(subview.alpha)")
            print("   - Sub-subviews: \(subview.subviews.count)")
            
            // Print sub-subviews juga
            subview.subviews.enumerated().forEach { subIndex, subSubview in
                let subClassName = String(describing: type(of: subSubview))
                print("     ↳ \(subIndex). \(subClassName)")
            }
        }
    }
}

extension ViewController: MaomaoKeyboardDelegate {
    
    func keyboardDidTapKey(_ key: String) {
        // Tambahkan angka ke text field
        passwordTextField.text = (passwordTextField.text ?? "") + key
    }
        
    func keyboardDidTapDelete() {
        // Hapus karakter terakhir dari text field
        if let text = passwordTextField.text, !text.isEmpty {
            passwordTextField.text = String(text.dropLast())
        }
    }
}
