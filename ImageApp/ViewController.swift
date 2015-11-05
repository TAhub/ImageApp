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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FilterViewDelegate {

	var picker:UIImagePickerController?
	
	@IBAction func uploadButton()
	{
		if imageView.image != nil
		{
			uploadCurrentImage()
		}
	}
	
	
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
		if imageView.image != nil
		{
			performSegueWithIdentifier("filterSegue", sender: self)
		}
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
			let resizedImage = resizeDown(image)
			
			if let imageData = UIImagePNGRepresentation(resizedImage)
			{
				uploadArbitraryImageData(imageData)
			}
		}
	}
	
	private func resizeDown(image:UIImage) -> UIImage
	{
		//resize the image to make the filter faster
		//specifically, rescale so that the smaller side is 600
		let minScale = min(image.size.width, image.size.height)
		if minScale > 600
		{
			imageView.image = image.resize(CGSize(width: image.size.width * 600 / minScale, height: image.size.height * 600 / minScale))
		}
		return image
	}
	
	//MARK: segue stuff
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if let destination = segue.destinationViewController as? FilterViewController
		{
			destination.baseImage = imageView.image
			destination.delegate = self
		}
	}
	
	func applyFilterToImage(filter: filterFunction)
	{
		
	}
	
	@IBAction func unwind(segue:UIStoryboardSegue)
	{
		//TODO: do nothing I guess
	}
}
