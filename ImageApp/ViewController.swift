/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	var picker:UIImagePickerController?
	
	@IBAction func cameraButton()
	{
		if picker == nil //don't want to have multiple simultaneous pickers
		{
			picker = UIImagePickerController()
			picker!.delegate = self
			if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
			{
				//open a dialogue to finish this
				let actionSheet = UIAlertController(title: "Where from?", message: "Should your use the camera, or the photo library?", preferredStyle: UIAlertControllerStyle.ActionSheet)
				
				let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
					{ (action) in
						self.finishPicker(UIImagePickerControllerSourceType.Camera)
				}
				actionSheet.addAction(cameraAction)
				
				let libraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default)
					{ (action) in
						self.finishPicker(UIImagePickerControllerSourceType.PhotoLibrary)
				}
				actionSheet.addAction(libraryAction)
				
				let cancelAction = UIAlertAction(title: "Nevermind", style: UIAlertActionStyle.Cancel)
					{ (action) in
						
				}
				actionSheet.addAction(cancelAction)
				
				presentViewController(actionSheet, animated: true, completion: nil)
			}
			else
			{
				//just use the library
				finishPicker(UIImagePickerControllerSourceType.PhotoLibrary)
			}
		}
	}
	
	@IBAction func filterButton()
	{
		//don't even open the action sheet up if there's no image to filter
		if let image = imageView.image
		{
			let actionSheet = UIAlertController(title: "Which filter?", message: "Which filter do you want to use today?", preferredStyle: UIAlertControllerStyle.ActionSheet)
			
			actionSheet.addAction(makeFilterAction(image, title: "Black and White Filter", message: "Artified the image!", filter: FilterService.blackAndWhiteFilter))
			actionSheet.addAction(makeFilterAction(image, title: "Halo Filter", message: "Halo'd the image!", filter: FilterService.haloFilter))
			actionSheet.addAction(makeFilterAction(image, title: "The Saturator", message: "It got saturated!", filter: FilterService.superSaturFilter))
			
			//kaleidoscope was introduced in iOS 9, so it should be conditional
			//yes, I know this throws a warning since I sent the development target to iOS 9
			//it's more here for if I decide to set it back
			if #available(iOS 9, *)
			{
				actionSheet.addAction(makeFilterAction(image, title: "Kaleidoscope Filter", message: "Kaleidoscoped the image!", filter: FilterService.kaleidoFilter))
			}
			
			actionSheet.addAction(makeFilterAction(image, title: "Blur Filter", message: "Blurred the image!", filter: FilterService.blurFilter))
			
			let cancelAction = UIAlertAction(title: "Nevermind", style: UIAlertActionStyle.Cancel)
				{ (action) in
					
			}
			actionSheet.addAction(cancelAction)
			
			presentViewController(actionSheet, animated: true, completion: nil)
		}
	}
	
	private func makeFilterAction(image:UIImage, title:String, message:String, filter:(UIImage, (String?, UIImage?)->())->()) -> UIAlertAction
	{
		let action = UIAlertAction(title: title, style: UIAlertActionStyle.Default)
			{ (action) in
				
				//resize the image to make the filter faster
				//specifically, rescale so that the smaller side is 600
				let finalImage:UIImage
				let minScale = min(image.size.width, image.size.height)
				if minScale > 600
				{
					finalImage = image.resize(CGSize(width: image.size.width * 600 / minScale, height: image.size.height * 600 / minScale))
				}
				else
				{
					finalImage = image
				}
				
				//apply the filter
				filter(finalImage)
					{ (error, image) in
						if let error = error
						{
							print(error)
						}
						else if let image = image
						{
							self.imageView.image = image
							print(message)
							self.uploadCurrentImage()
						}
				}
		}
		return action;
	}
	
	private func finishPicker(sourceType: UIImagePickerControllerSourceType)
	{
		picker!.sourceType = sourceType
		presentViewController(picker!, animated: true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
		{
			imageView.image = image
		}
		
		//upload current image
		uploadCurrentImage()
		
		picker.dismissViewControllerAnimated(true)
			{
				self.picker = nil
		}
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		picker.dismissViewControllerAnimated(true)
			{
				self.picker = nil
		}
	}
	
	@IBOutlet weak var imageView: UIImageView!
	
	private func uploadArbitraryImageData(imageData:NSData) -> Bool
	{
		//get the file size of the image data, in MB
		let fileSize = imageData.length / 1024 / 1024
		
		if fileSize >= 10
		{
			print("ERROR: file size of \(fileSize) MB is too big to upload")
			return false
		}
		else
		{
			print("File size of \(fileSize) MB should be okay to upload")
			let file = PFFile(data: imageData)
			let imageObject = PFObject(className: "Image")
			imageObject["data"] = file
			imageObject.saveInBackgroundWithBlock()
				{ (success, error) in
					if let error = error
					{
						print(error)
					}
					else if success
					{
						print("Successfully uploaded")
					}
			}
			return true
		}
	}
	
	private func uploadCurrentImage()
	{
		if let image = imageView.image
		{
			//resize the image to 600, if it's bigger
			let resizedImage = image.resize(CGSize(width: min(image.size.width, 600), height: min(image.size.height, 600)))
			
			if let imageData = UIImagePNGRepresentation(resizedImage)
			{
				uploadArbitraryImageData(imageData)
			}
			
			//my old code for changing image quality is no longer necessary, probably
//			print("Attempting to upload as PNG")
//			if let imageData = UIImagePNGRepresentation(resizedImage)
//			{
//				if uploadArbitraryImageData(imageData)
//				{
//					return
//				}
//			}
//			
//			print("Attempting to upload as high-quality JPEG")
//			if let imageData = UIImageJPEGRepresentation(resizedImage, 1)
//			{
//				if uploadArbitraryImageData(imageData)
//				{
//					return
//				}
//			}
//			
//			print("Attempting to upload as medium-quality JPEG")
//			if let imageData = UIImageJPEGRepresentation(resizedImage, 0.5)
//			{
//				if uploadArbitraryImageData(imageData)
//				{
//					return
//				}
//			}
//			
//			print("Attempting to upload as low-quality JPEG")
//			if let imageData = UIImageJPEGRepresentation(resizedImage, 0)
//			{
//				if uploadArbitraryImageData(imageData)
//				{
//					return
//				}
//			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
