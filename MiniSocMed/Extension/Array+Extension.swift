//
//  Array+Extension.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 26/03/23.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        if indices ~= index {
            return self[index]
        } else {
            return nil
        }
    }
}
