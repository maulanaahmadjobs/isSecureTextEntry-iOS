//
//  HiddenContent.swift
//  isSecureTextEntry iOS
//
//  Created by west on 04/11/25.
//

import UIKit

/// Hati-hati, jika Anda menambahkan view ke subview yang telah dikeluarkan dari recognizer ini,
/// memanggil getter akan menghasilkan nilai nil.
struct HiddenContent {

    /// Error yang mungkin terjadi
    private enum Error: Swift.Error {
        case unsupportedOSVersion(version: Float)
        case desiredContainerNotFound(_ containerName: String)
    }
    
    func getHiddentContener(from view: UIView) throws -> UIView {
        // Dapatkan nama class container sesuai versi iOS
        let containerName = try getHiddenContenTypeStringRepresentation()
        
        // Cari subview yang sesuai dengan nama container
        let containers = view.subviews.filter { subview in
            type(of: subview).description() == containerName
        }
        
        // Pastikan container ditemukan
        guard let container = containers.first else {
            throw Error.desiredContainerNotFound(containerName)
        }
        
        return container
    }
    
    /// Mengembalikan nama class container tersembunyi sesuai versi iOS
    /// Apple mengubah nama internal class ini di setiap versi iOS
    private func getHiddenContenTypeStringRepresentation() throws -> String {
        // iOS 15 ke atas menggunakan _UITextLayoutCanvasView
        if #available(iOS 15, *) {
            return "_UITextLayoutCanvasView"
        }
        
        // iOS 13-14 menggunakan _UITextFieldCanvasView
        if #available(iOS 14, *) {
            return "_UITextFieldCanvasView"
        }
        
        // iOS 12 menggunakan _UITextFieldContentView
        if #available(iOS 12, *) {
            return "_UITextFieldContentView"
        }
        
        // Jika iOS lebih lama dari iOS 12, throw error
        let currentIOSVersion = (UIDevice.current.systemVersion as NSString).floatValue
        throw Error.unsupportedOSVersion(version: currentIOSVersion)

    }
}
