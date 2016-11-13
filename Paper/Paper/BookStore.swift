//
//  BookStore.swift
//  Paper
//
//  Created by Andy Wong on 11/13/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import UIKit

class BookStore {
    class var sharedInstance: BookStore {
        struct Static {
            static var onceToken = 0
            static var instance: BookStore? = nil
        }

        let _ = {
            Static.instance = BookStore()
        }()

        return Static.instance!
    }

    func loadBooks(_ plist: String) -> [Book] {
        var books = [Book]()

        if let path = Bundle.main.path(forResource: plist, ofType: "plist") {
            if let array = NSArray(contentsOfFile: path) {
                for dict in array as! [NSDictionary] {
                    let book = Book(dict: dict)
                    books += [book]
                }
            }
        }

        return books
    }
}
