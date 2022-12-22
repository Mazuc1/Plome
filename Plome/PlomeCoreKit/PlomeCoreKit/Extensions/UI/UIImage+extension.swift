//
//  UIImage+extension.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 24/11/2022.
//

import UIKit

public extension UIImage {
    func url(name: String) -> URL? {
        let imagePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(name).png"
        let imageUrl = URL(fileURLWithPath: imagePath)

        do {
            try pngData()?.write(to: imageUrl)
            return imageUrl
        } catch {
            return nil
        }
    }
}

public extension UIImage {
    func imageResize(sizeChange: CGSize) -> UIImage {
        let hasAlpha = true
        let scale: CGFloat = 0.0

        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}
