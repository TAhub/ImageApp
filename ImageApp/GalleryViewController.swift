//
//  GalleryViewController.swift
//  ImageApp
//
//  Created by Theodore Abshire on 11/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

//tab bar icon courtsey of
//Freepik			http://www.flaticon.com/authors/freepik

import UIKit
import Parse

class GalleryViewController: UIViewController, UICollectionViewDataSource {
	private var images = [(UIImage, String)]()
	{
		didSet
		{
			galleryView.reloadData()
		}
	}
	
	//MARK: dataSource
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return images.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
	{
		let cell = galleryView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! GalleryCollectionViewCell
		
		cell.imageView.image = images[indexPath.row].0
		cell.label.text = images[indexPath.row].1
		
		return cell
	}
	
	//MARK: misc
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//add the pinch gesture recognizer
		let recognizer = UIPinchGestureRecognizer()
		recognizer.addTarget(self, action: "pinchRecognize:")
		view.addGestureRecognizer(recognizer)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		getImages()
	}
	
	func pinchRecognize(sender: UIPinchGestureRecognizer)
	{
		if let layout = galleryView.collectionViewLayout as? UICollectionViewFlowLayout
		{
			let itemSize = layout.itemSize
			let size:CGFloat = max(min(sender.scale * itemSize.width, 300.0), 75.0)
			layout.itemSize = CGSize(width: size, height: size)
		}
		sender.scale = 1
	}
	
	private func getImages()
	{
		let query = PFQuery(className: "Image")
		query.findObjectsInBackgroundWithBlock()
		{ (objects, error) in
			if let error = error
			{
				print(error)
			}
			else if let objects = objects
			{
				//clear the image array
				self.images = [(UIImage, String)]()
				
				//do this on a dispatch thread because apparently getData is an intensive operation
				//and if I do it on the main queue, Parse complains about it
				//probably for the best
				dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0))
				{
					for object in objects
					{
						if let imageFile = object["data"] as? PFFile, name = object["name"] as? String
						{
							do
							{
								let image = UIImage(data: try imageFile.getData())!
								dispatch_async(dispatch_get_main_queue())
								{
									self.images.append(image, name)
								}
							}
							catch _
							{
								print("ERROR: Failed to convert data to image!")
							}
						}
					}
				}
			}
		}
	}
	
	@IBOutlet weak var galleryView: UICollectionView!
		{
		didSet
		{
			galleryView.dataSource = self
			galleryView.collectionViewLayout = GalleryLayout()
			galleryView.backgroundColor = UIColor.whiteColor()
			
			//load the cells from nib
			galleryView.registerNib(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
		}
	}
}
