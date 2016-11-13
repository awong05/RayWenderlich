//
//  Book.swift
//  Paper
//
//  Created by Andy Wong on 11/13/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import UIKit

class Book {
    convenience init(dict: NSDictionary) {
        self.init()
        self.dict = dict
    }

    var dict: NSDictionary?

    func coverImage() -> UIImage? {
        if let cover = dict?["cover"] as? String {
            return UIImage(named: cover)
        }
        return nil
    }

    func pageImage(_ index: Int) -> UIImage? {
        if let pages = dict?["pages"] as? NSArray {
            if let page = pages[index] as? String {
                return UIImage(named: page)
            }
        }
        return nil
    }

    func numberOfPages() -> Int {
        if let pages = dict?["pages"] as? NSArray {
            return pages.count
        }
        return 0
    }
}
