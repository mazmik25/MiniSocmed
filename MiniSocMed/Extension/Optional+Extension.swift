//
//  Optional+Extension.swift
//  MiniSocMed
//
//  Created by Azmi Muhammad on 26/03/23.
//

import Foundation

extension Optional {
    func safeUnwrap(_ def: Wrapped) -> Wrapped {
        if let self = self {
            return self
        } else {
            return def
        }
    }
}

extension Optional where Wrapped: ExpressibleByStringLiteral {
    func safeUnwrap() -> Wrapped {
        if let self = self {
            return self
        } else {
            return ""
        }
    }
}

extension Optional where Wrapped: Numeric {
    func safeUnwrap() -> Wrapped {
        if let self = self {
            return self
        } else {
            return .zero
        }
    }
}

extension Optional where Wrapped: ExpressibleByArrayLiteral {
    func safeUnwrap() -> Wrapped {
        if let self = self {
            return self
        } else {
            return []
        }
    }
}

extension Optional where Wrapped: ExpressibleByDictionaryLiteral {
    func safeUnwrap() -> Wrapped {
        if let self = self {
            return self
        } else {
            return [:]
        }
    }
}
