//
//  NSObject+Extension.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 26/03/23.
//

import Foundation

extension NSObject {
    static func className() -> String {
        return (NSStringFromClass(self).components(separatedBy: ".").last).safeUnwrap()
    }
}
