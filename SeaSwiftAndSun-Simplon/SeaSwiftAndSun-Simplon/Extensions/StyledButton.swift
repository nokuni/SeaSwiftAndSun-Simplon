//
//  StyledButton.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Tatiana Simmer on 14/12/2023.
//

import Foundation
import UIKit

class StyledButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }
    
    private func setStyle() {
        
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor(hex: "334195")
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor(hex: "334195").cgColor
        self.layer.borderWidth = 1.0
        self.titleLabel?.font = UIFont(name: "Print Clearly", size: 30)
        self.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
        self.layer.masksToBounds = false
    }
}
