//
//  BookViewController.swift
//  Paper
//
//  Created by Andy Wong on 11/13/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import UIKit

class BookViewController: UICollectionViewController {
    var book: Book? {
        didSet {
            collectionView?.reloadData()
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let book = book {
            return book.numberOfPages() + 1
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookPageCell", for: indexPath) as! BookPageCell

        if indexPath.row == 0 {
            cell.textLabel.text = nil
            cell.image = book?.coverImage()
        } else {
            cell.textLabel.text = "\(indexPath.row)"
            cell.image = book?.pageImage(indexPath.row - 1)
        }

        return cell
    }
}
