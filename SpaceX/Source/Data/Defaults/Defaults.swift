//
//  Defaults.swift
//  SpaceX
//
//  Created by Alex Stergiou on 30/04/2021.
//

import Foundation

let Defaults = UserDefaults.standard

//Protocol wrapper around UserDefaults, for the required functionality of this excercise

protocol DefaultsType: AnyObject {
    subscript<T: DefaultsValueType>(key: DefaultsKey<T>) -> T? { get set }
    func data<T>(_ key: DefaultsKey<T>) -> Data?
    func hasKey<T>(_ key: DefaultsKey<T>) -> Bool
}

extension UserDefaults: DefaultsType {

    public subscript<T: DefaultsValueType>(key: DefaultsKey<T>) -> T? {
        get { return object(forKey: key.key) as? T }
        set { set(newValue, forKey: key.key) }
    }

    func data<T>(_ key: DefaultsKey<T>) -> Data? {
        return data(forKey: key.key)
    }

    public func hasKey<T>(_ key: DefaultsKey<T>) -> Bool {
        return object(forKey: key.key) != nil
    }
}

public protocol DefaultsValueType { }
extension URL: DefaultsValueType { }
extension Array: DefaultsValueType { }
extension Dictionary: DefaultsValueType { }
extension String: DefaultsValueType { }
extension Data: DefaultsValueType { }
extension Bool: DefaultsValueType { }
extension Int: DefaultsValueType { }
extension Float: DefaultsValueType { }
extension Double: DefaultsValueType { }
extension Date: DefaultsValueType { }
extension Set: DefaultsValueType { }

open class DefaultsKeys {
    fileprivate init() {}
}

open class DefaultsKey<T: DefaultsValueType>: DefaultsKeys {
    public let key: String

    public init(_ key: String) {
        self.key = key
        super.init()
    }
}

