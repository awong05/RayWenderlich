//
//  FlickrPhotosViewController.swift
//  FlickrSearch
//
//  Created by Andy Wong on 9/2/16.
//  Copyright © 2016 Andy Wong. All rights reserved.
//

import UIKit

class FlickrPhotosViewController: UICollectionViewController
{
  private let reuseIdentifier = "FlickrCell"
  private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

  private var searches = [FlickrSearchResults]()
  private let flickr = Flickr()

  func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto
  {
    return searches[indexPath.section].searchResults[indexPath.row]
  }
}

extension FlickrPhotosViewController: UITextFieldDelegate
{
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    textField.addSubview(activityIndicator)
    activityIndicator.frame = textField.bounds
    activityIndicator.startAnimating()

    flickr.searchFlickrForTerm(textField.text!) { results, error in
      activityIndicator.removeFromSuperview()

      if error != nil {
        print("Error searching: \(error)")
      }

      if results != nil {
        print("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
        self.searches.insert(results!, atIndex: 0)
        self.collectionView?.reloadData()
      }
    }

    textField.text = nil
    textField.resignFirstResponder()
    return true
  }
}

extension FlickrPhotosViewController
{
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return searches.count
  }

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searches[section].searchResults.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FlickrPhotoCell
    let flickrPhoto = photoForIndexPath(indexPath)

    cell.backgroundColor = UIColor.blackColor()
    cell.imageView.image = flickrPhoto.thumbnail

    return cell
  }
}

extension FlickrPhotosViewController: UICollectionViewDelegateFlowLayout
{
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let flickrPhoto = photoForIndexPath(indexPath)

    if var size = flickrPhoto.thumbnail?.size {
      size.width += 10
      size.height += 10
      return size
    }
    return CGSize(width: 100, height: 100)
  }

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
}
