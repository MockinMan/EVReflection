//
//  RealmListEVReflectable.swift
//  UnitTests
//
//  Created by Edwin Vermeer on 29/03/2017.
//  Copyright © 2017 evict. All rights reserved.
//

import Foundation
import RealmSwift


extension Object : EVReflectable {
    open override func setValue(_ value: Any?, forUndefinedKey key: String) {
        self.addStatusMessage(.IncorrectKey, message: "The class '\(EVReflection.swiftStringFromClass(self))' is not key value coding-compliant for the key '\(key)'")
        
        evPrint(.IncorrectKey, "WARNING: The class '\(EVReflection.swiftStringFromClass(self))' is not key value coding-compliant for the key '\(key)'\n❓ This could be a strange Realm List issue where tee key is reported undefined but it's still set.\n")
    }
}

// We have to use custom reflection for a Realm object because Mirror often does not work.
extension Object: EVCustomReflectable {
    /**
     If you have a custom type that requires special conversion, then you can extend it with the EVCustomReflectable protocol.
     
     - parameter value: The dictionary that will be converted to an object
     */
    public func constructWith(value: Any?) {
        if let jsonDict = value as? NSDictionary {
            EVReflection.setPropertiesfromDictionary(jsonDict, anyObject: self)
        }
    }
    
    /**
     If you have a custom type that requires special conversion, then you can extend it with the EVCustomReflectable protocol.
     Since Mirror does not work for a Realm Object we use the .value forKey
     
     - returns: Dictionary without custom properties key
     */
    public func toCodableValue() -> Any {
        let dict: NSMutableDictionary = self.toDictionary() as! NSMutableDictionary
        let newDict = NSMutableDictionary()
        
        for (key, _) in dict {
            let property: String = key as? String ?? ""
            guard let value = self.value(forKey:property) else { continue }
            if let detachable = value as? Object {
                newDict.setValue(detachable.toCodableValue(), forKey: property)
            } else if let detachable = value as? List {
                let result = NSMutableArray()
                detachable.forEach {
                    result.add($0.toCodableValue())
                }
                newDict.setValue(result, forKey: property)
            } else {
                newDict.setValue(value, forKey: property)
            }
        }
        return dict
    }
}

// We have to use custom reflection for a Realm list because Mirror often does not work.
extension List : EVCustomReflectable {
    /**
     If you have a custom type that requires special conversion, then you can extend it with the EVCustomReflectable protocol.
     
     - parameter value: The dictionary that will be converted to an object
     */
    public func constructWith(value: Any?) {
        if let array = value as? [NSDictionary] {
            self.removeAll()
            for dict in array {
                if let element: T = EVReflection.fromDictionary(dict, anyobjectTypeString: _rlmArray.objectClassName) as? T {
                    self.append(element)
                }
            }
        }
    }
    
    /**
     If you have a custom type that requires special conversion, then you can extend it with the EVCustomReflectable protocol.
     Since Mirror does not work for a Realm Object we use the .value forKey
     
     - returns: Dictionary without custom properties key
     */
    public func toCodableValue() -> Any {
        var q = [NSDictionary]()
        for case let e as Any in self {
            q.append((e as? EVReflectable)?.toDictionary([.PropertyConverter, .KeyCleanup, .PropertyMapping, .DefaultSerialize]) ?? NSDictionary())
        }
        return q
 
        // Why do we need all this code? Should be the same as this. But this crashes.
        //return self.enumerated().map { ($0.element as? EVReflectable)?.toDictionary() ?? NSDictionary() }
    }
}
