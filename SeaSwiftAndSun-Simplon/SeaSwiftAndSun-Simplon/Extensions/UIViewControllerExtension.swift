//
//  UIViewControllerExtension.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Yann Christophe Maertens on 15/12/2023.
//

import UIKit
import SwiftUI

extension UIViewController {
    func addSwiftUIView<V: View>(swiftUIView: V) -> UIView {
        // 1
        let vc = UIHostingController(rootView: swiftUIView)
        
        let newView = vc.view!
        newView.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        view.addSubview(newView)
        NSLayoutConstraint.activate([
            newView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        vc.didMove(toParent: self)
        
        return newView
    }
}
