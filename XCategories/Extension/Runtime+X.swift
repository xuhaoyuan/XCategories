//
//  Runtime+X.swift
//  qugame
//
//  Created by 许浩渊 on 2021/3/22.
//  Copyright © 2021 Duodian. All rights reserved.
//

import UIKit

@propertyWrapper
struct AssociatedObject<T> {
    var key: UnsafeRawPointer
    var defaultValue: T
    var wrappedValue: T {
        set {
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, key) as? T ?? defaultValue
        }
    }
    init(key: UnsafeRawPointer, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
