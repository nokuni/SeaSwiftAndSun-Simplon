//
//  UIImageViewExtension.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Yann Christophe Maertens on 12/12/2023.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
