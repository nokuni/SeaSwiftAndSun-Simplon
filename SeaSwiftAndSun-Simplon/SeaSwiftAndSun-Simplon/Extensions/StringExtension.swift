//
//  StringExtension.swift
//  SeaSwiftAndSun-Simplon
//
//  Created by Yann Christophe Maertens on 11/12/2023.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

extension String {
    func isLastCharacter(_ character: Character) -> Bool {
        guard !self.isEmpty else { return false }
        return self.last == character
    }
}
