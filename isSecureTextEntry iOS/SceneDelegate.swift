//
//  SceneDelegate.swift
//  isSecureTextEntry iOS
//
//  Created by west on 28/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
//        window?.makeSecuresss()

        // Lindungi seluruh window
//        window?.hideOnScreenshot(withCover: SecureOverlayView())

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        print("sceneDidDisconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("sceneDidBecomeActive")

    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("sceneWillResignActive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("sceneWillEnterForeground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("sceneDidEnterBackground")
    }

}

// MARK: - 1. Extension UIWindow untuk Screenshot Protection
extension UIWindow {
    
    func makeSecure() {
        DispatchQueue.main.async {
            
//            let privacyView = PrivacyProtectionViews(frame: self.bounds)
//            privacyView.backgroundColor = .blue
//            self.superview?.insertSubview(privacyView, at: 0)
//            privacyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            
            lazy var screenshotBlockLabel : UILabel = {
                let label = UILabel()
                label.text = "No ScreenShots Please"
                label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
                label.textAlignment = .center
                label.backgroundColor = .red
                return label
            }()
            
            self.superview?.addSubview(screenshotBlockLabel)
//            let privacyView = PrivacyProtectionViews(frame: self.bounds)
//
//            self.addSubview(privacyView)
        
//
            
            let field = UITextField()
            field.isSecureTextEntry = true
            self.addSubview(field)
            field.isUserInteractionEnabled = false
            field.backgroundColor = .red
            
            
//            self.layer.superlayer?.addSublayer(field.layer)
//            field.layer.sublayers?.last!.addSublayer(self.layer)
            // Setup layer (tetap hati-hati dengan ini)
            self.layer.superlayer?.addSublayer(field.layer)
            if let lastSublayer = field.layer.sublayers?.last {
                lastSublayer.addSublayer(self.layer)
            }
            
            field.leftView = screenshotBlockLabel
            field.leftViewMode = .always
            
//            field.semanticContentAttribute = .forceLeftToRight

        }
    }
}

// MARK: - 2. Privacy Protection Overlay View
class PrivacyProtectionView: UIView {
    private let blurEffect = UIBlurEffect(style: .light)
    private lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock.shield.fill")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Konten Dilindungi"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Add blur background
        addSubview(blurView)
        blurView.frame = bounds
        
        // Add icon
        addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Add message
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        backgroundColor = .systemBackground
    }
}

