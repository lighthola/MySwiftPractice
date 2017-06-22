//
//  Log.swift
//  
//
//  Created by Andyy Hope on 14/04/2016.
//  http://www.andyyhope.com
//  @andyyhope


import Foundation

enum log {
    case ln(_: String)
    case url(_: String)
    case error(_: NSError)
    case date(_: NSDate)
    case obj(_: AnyObject)
    case any(_: Any)
}

postfix operator /

postfix func / (target: log?) {
    guard let target = target else { return }
    
    func log<T>(_ emoji: String, _ object: T) {
        print(emoji + " " + String(describing: object))
    }
    
    switch target {
    case .ln(let line):
        log("✏️", line)
        
    case .url(let url):
        log("🌏", url)
        
    case .error(let error):
        log("❗️", error)
        
    case .any(let any):
        log("⚪️", any)
        
    case .obj(let obj):
        log("◽️", obj)
        
    case .date(let date):
        log("🕒", date)
    }
}

extension Array where Element: Hashable {
    /// Returns most popular member of the array
    ///
    /// - SeeAlso: https://en.wikipedia.org/wiki/Mode_(statistics)
    ///
    func mode() -> (item: Element?, count: Int) {
        let countedSet = NSCountedSet(array: self)
        let counts = countedSet.objectEnumerator()
            .map{ (item: $0 as? Element, count: countedSet.count(for: $0)) }
        return counts.reduce((item: nil, count: 0), {
            return ($0.count > $1.count) ? $0 : $1
        })
    }
    
}
