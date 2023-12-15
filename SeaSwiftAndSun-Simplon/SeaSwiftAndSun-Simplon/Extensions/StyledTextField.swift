//
//  StyledTextField.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Tatiana Simmer on 13/12/2023.
//

import Foundation
import UIKit

class StyledTextField: UITextField {
    var label: UILabel =  {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLabel(labelName: "")
    }
    
    required init?(coder: NSCoder, labelName: String) {
        super.init(coder: coder)
        setupStyle()
        setupLabel(labelName: labelName)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
        setupLabel(labelName: "")
    }
    
    private func setupStyle() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor(hex: "0077B6").cgColor
        self.layer.borderWidth = 1.0
        self.font = UIFont(name: "Helvetica", size: 16)
        self.textColor = .black
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = .always
        self.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    
    private func setupLabel(labelName: String) {
        self.addSubview(label)
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: topAnchor, constant: -2).isActive = true
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
