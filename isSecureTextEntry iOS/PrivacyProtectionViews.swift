import UIKit

// MARK: - View utama yang mencegah screenshot
class PrivacyProtectionViews: UIView {
    
    /// Properti untuk mengaktifkan/menonaktifkan proteksi screenshot
    /// Ketika true, konten tidak bisa di-screenshot atau di-record
    ///
    
    private var contentView: UIView?
    private let textField = UITextField()
    
    /// Properti untuk mengaktifkan/menonaktifkan proteksi screenshot
    /// Ketika true, konten tidak bisa di-screenshot atau di-record
    public var isSecureTextEntry = true {
        
        // Menggunakan fitur isSecureTextEntry dari UITextField
        // Untuk memblokir screenshot (sama seperti input password)
        didSet {
            textField.isSecureTextEntry = isSecureTextEntry
        }
        
        // Override untuk sinkronisasi user interaction antara view utama dan container tersembunyi
        // Ini mencegah bug freeze ketika menggunakan scrollview di dalam view ini
//        public override var isUserInteractionEnabled: Bool {
//            
//            didSet {
//                
//            }
//        }
    }
    
    
// Buat overlay full screen

    func overlay() {
        guard let window = UIApplication.shared.windows.first else { return }
        let overlayView = UIView(frame: window.bounds)
        overlayView.backgroundColor = .systemBackground
        
        // Logo tengah
        let iconView = UIImageView(image: UIImage(systemName: "camera.fill"))
        iconView.tintColor = .systemGreen
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        // Label judul
        let titleLabel = UILabel()
        titleLabel.text = "Screenshot Blocked"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Label deskripsi
        let messageLabel = UILabel()
        messageLabel.text = "It looks like you tried to take a screenshot.\nFor added privacy, view once messages don’t let you do this."
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = .secondaryLabel
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Logo WhatsApp
        let logo = UIImageView(image: UIImage(named: "whatsapp_logo")) // Pastikan ada di asset
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false

        // Tambahkan semua view
        overlayView.addSubview(iconView)
        overlayView.addSubview(titleLabel)
        overlayView.addSubview(messageLabel)
        overlayView.addSubview(logo)
        window.addSubview(overlayView)
        
        // Atur layout pakai Auto Layout
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor, constant: -80),
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -40),
            
            logo.bottomAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            logo.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 120),
            logo.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // (Opsional) animasi muncul
        overlayView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            overlayView.alpha = 1
        }
    }
    
}

