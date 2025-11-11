//
//  MaomaoKeyboard.swift
//  isSecureTextEntry iOS
//
//  Created by west on 06/11/25.
//

import UIKit

// MARK: - Deletage Protocol
protocol MaomaoKeyboardDelegate: AnyObject {
    func keyboardDidTapKey(_ key: String)
    func keyboardDidTapDelete()
}

// MARK: - Keyboard Key Model
struct KeyboardKey {
    let number: String
    let letters: String?
    let isDelete: Bool
    
    init(number: String, letters: String? = nil, isDelete: Bool = false) {
        self.number = number
        self.letters = letters
        self.isDelete = isDelete
    }
}

// MARK: - Custom Keyboard View (UIKit Programmatic)
class MaomaoKeyboard: UIView {
    
    // Container untuk keyboard custom
    let keyboardContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Delegate untuk mengirim input ke TextField
    weak var delegate: MaomaoKeyboardDelegate?
    
    // Array Button untuk menyimpan referensi semua tombol
    private var button: [UIButton] = []
    
    // Data untuk setiap tombol keyboard
    private let keyboardData : [[KeyboardKey]] = [
        [KeyboardKey(number: "1"), KeyboardKey(number: "2", letters: "ABC"), KeyboardKey(number: "3", letters: "DEF")],
        [KeyboardKey(number: "0"), KeyboardKey(number: "⌫", isDelete: true)]
    ]
    
    // MARK: - Initialization
    /// Membuat view secara programmatic (dalam code)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewKeyboard()
    }
    
    // MARK: - Initialization
    /// View dibuat dari Interface Builder (Storyboard/XIB)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViewKeyboard()
    }
    
    // MARK: - Setup View
    private func setupViewKeyboard() {
//        // Gradient layer untuk background
//        let gradientLayer = CAGradientLayer()
//        
//        // 1. Tentukan warna gradient
//         // Format UIColor: red, green, blue, alpha (0-1)
//        let topColor = UIColor(red: 0.4, green: 0.2, blue: 0.15, alpha: 1.0).cgColor
//        let bottomColor = UIColor(red: 0.5, green: 0.15, blue: 0.15, alpha: 1.0).cgColor
//        
//        // 2. Set warna ke gradient layer
//        // Array ini menentukan urutan warna dari atas ke bawah
//        gradientLayer.colors = [topColor, bottomColor]
//        
//        // 3. Set corner radius (sudut melengkung)
//        gradientLayer.cornerRadius = 20
//        
//        // 4. Set frame gradient sesuai ukuran container
//        gradientLayer.frame = keyboardContainer.bounds
//        
//        // 5. Tambahkan gradient layer ke container
//        // insertSublayer at: 0 = layer paling belakang (background)
//        keyboardContainer.layer.insertSublayer(gradientLayer, at: 0)
        
        backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
       
    }
    
    func setupConstraints() {
        
        
        NSLayoutConstraint.activate([
            keyboardContainer.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            keyboardContainer.leadingAnchor.constraint(equalTo: leftAnchor, constant: 20),
            keyboardContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            keyboardContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20)
        ])
        
    }
        
    // Membuat stack view untuk setiap baris
    private func createRowStackView(for row: [KeyboardKey], rowIndex: Int) -> UIStackView {
        let stackView = UIStackView()
        
        return stackView
    }
}
