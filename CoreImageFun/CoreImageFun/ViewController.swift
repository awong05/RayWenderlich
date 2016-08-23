//
//  ViewController.swift
//  CoreImageFun
//
//  Created by Andy Wong on 8/21/16.
//  Copyright © 2016 Andy Wong. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var amountSlider: UISlider!

    private var context: CIContext!
    private var filter: CIFilter!
    private var beginImage: CIImage!

    private var orientation: UIImageOrientation = .Up

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let fileURL = NSBundle.mainBundle().URLForResource("image",
                                                           withExtension: "png")!
        beginImage = CIImage(contentsOfURL: fileURL)!

        filter = CIFilter(name: "CISepiaTone")!
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        filter.setValue(0.5, forKey: kCIInputIntensityKey)

        let outputImage = filter.outputImage!

        context = CIContext(options: nil)
        let cgImage = context.createCGImage(outputImage,
                                            fromRect: outputImage.extent)

        let newImage = UIImage(CGImage: cgImage)
        imageView.image = newImage
        
        logAllFilters()
    }

    func logAllFilters()
    {
        let properties = CIFilter.filterNamesInCategory(kCICategoryBuiltIn)
        print(properties)

        for filterName: AnyObject in properties {
            let fltr = CIFilter(name: filterName as! String)!
            print(fltr.attributes)
        }
    }

    func oldPhoto(image: CIImage, withAmount intensity: Float) -> CIImage
    {
        let sepia = CIFilter(name: "CISepiaTone")!
        sepia.setValue(image, forKey: kCIInputImageKey)
        sepia.setValue(intensity, forKey: kCIInputIntensityKey)

        let random = CIFilter(name: "CIRandomGenerator")!

        let lighten = CIFilter(name: "CIColorControls")!
        lighten.setValue(random.outputImage, forKey: kCIInputImageKey)
        lighten.setValue(1 - intensity, forKey: kCIInputBrightnessKey)
        lighten.setValue(0, forKey: kCIInputSaturationKey)

        let croppedImage = lighten.outputImage!.imageByCroppingToRect(beginImage.extent)

        let composite = CIFilter(name: "CIHardLightBlendMode")!
        composite.setValue(sepia.outputImage, forKey: kCIInputImageKey)
        composite.setValue(croppedImage, forKey: kCIInputBackgroundImageKey)

        let vignette = CIFilter(name: "CIVignette")!
        vignette.setValue(composite.outputImage, forKey: kCIInputImageKey)
        vignette.setValue(intensity * 2, forKey: kCIInputIntensityKey)
        vignette.setValue(intensity * 30, forKey: kCIInputRadiusKey)

        return vignette.outputImage!
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        dismissViewControllerAnimated(true, completion: nil)

        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        orientation = gotImage.imageOrientation
        beginImage = CIImage(image: gotImage)
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        amountSliderValueChanged(amountSlider)
    }

    @IBAction func amountSliderValueChanged(sender: UISlider)
    {
        let sliderValue = sender.value

        let outputImage = oldPhoto(beginImage, withAmount: sliderValue)

        let cgImage = context.createCGImage(outputImage,
                                            fromRect: outputImage.extent)

        let newImage = UIImage(CGImage: cgImage, scale: 1, orientation: orientation)
        imageView.image = newImage
    }

    @IBAction func loadPhoto(sender: UIButton)
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        presentViewController(pickerController, animated: true, completion: nil)
    }

    @IBAction func savePhoto(sender: UIButton)
    {
        let imageToSave = filter.outputImage!
        let softwareContext = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        let cgImage = softwareContext.createCGImage(imageToSave,
                                                    fromRect: imageToSave.extent)

        let library = PHPhotoLibrary.sharedPhotoLibrary()
        library.performChanges({ PHAssetChangeRequest.creationRequestForAssetFromImage(UIImage(CGImage: cgImage, scale: 1, orientation: self.orientation)) },
                               completionHandler: nil)
    }
}
