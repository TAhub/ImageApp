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
				if #available(iOS 8.0, *)
				{
				    let actionSheet = UIAlertController(title: "Where from?", message: "Should your use the camera, or the photo library?", preferredStyle: UIAlertControllerStyle.ActionSheet)
					
					let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
						{ (action) -> Void in
							self.finishPicker(UIImagePickerControllerSourceType.Camera)
					}
					actionSheet.addAction(cameraAction)
					
					let libraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default)
						{ (action) -> Void in
							self.finishPicker(UIImagePickerControllerSourceType.PhotoLibrary)
					}
					actionSheet.addAction(libraryAction)
					
					let cancelAction = UIAlertAction(title: "Nevermind", style: UIAlertActionStyle.Cancel)
						{ (action) -> Void in
							
					}
					actionSheet.addAction(cancelAction)
					
					presentViewController(actionSheet, animated: true, completion: nil)
				}
				else
				{
					//just load the camera for now I guess
					finishPicker(UIImagePickerControllerSourceType.Camera)
				}
			}
			else
			{
				//just use the library
				finishPicker(UIImagePickerControllerSourceType.PhotoLibrary)
			}
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
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		
//		let status = PFObject(className: "Status")
//		status["text"] = "Status text"
//		status["location"] = "Seattle"
//		status["array_example"] = ["haha", "this is an array", "it has stuff in it"]
//		status.saveInBackgroundWithBlock()
//			{ (success, error) -> Void in
//				if success
//				{
//					print("Successfully saved to parse. Check parse console.")
//				}
//		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
