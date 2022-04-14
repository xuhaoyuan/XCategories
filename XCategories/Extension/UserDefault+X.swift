//
//  UserDefault+Circles.swift
//  Circles
//
//  Created by 许浩渊 on 2020/8/11.
//  Copyright © 2020 MoreTech. All rights reserved.
//

import UIKit

extension UserDefaults {

    @available(iOS 12.0, *)
    static var UserInterfaceStyle: UIUserInterfaceStyle {
        set { privateUserInterfaceStyle = newValue.rawValue }
        get { UIUserInterfaceStyle(rawValue: privateUserInterfaceStyle) ?? .unspecified }
    }
    @UserDefault(key: "UserInterfaceStyle", defaultValue: 0)
    private static var privateUserInterfaceStyle: Int

    @UserDefault(key: "LastVerifyPhoneTime", defaultValue: 0)
    static var LastVerifyPhoneTime: TimeInterval

    @UserDefault(key: "neverEvaluationShowBlackAlert", defaultValue: false)
    static var neverEvaluationShowBlackAlert: Bool

    static var preSelectedRoomType: RoomType {
        set { privateSelectedRoomType = newValue.rawValue }
        get { RoomType(rawValue: privateSelectedRoomType) ?? .normal }
    }
    @UserDefault(key: "preSelectedRoomType", defaultValue: RoomType.normal.rawValue)
    private static var privateSelectedRoomType: Int

    @UserDefault(key: "versionUpdateRecord", defaultValue: "")
    static var versionUpdateRecord: String
    
    @UserDefault(key: "gamingBackRoomAlert", defaultValue: true)
    static var gamingBackRoomAlert: Bool
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set {
            UserDefaults.standard.set(newValue, forKey: key) }
    }

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
