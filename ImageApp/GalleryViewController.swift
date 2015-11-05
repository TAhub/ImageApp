//
//  GalleryViewController.swift
//  ImageApp
//
//  Created by Theodore Abshire on 11/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class GalleryViewController: UIViewController, UICollectionViewDataSource {

	@IBOutlet weak var galleryView: UICollectionView!
	{
		didSet
		{
			galleryView.dataSource = self
			galleryView.collectionViewLayout = GalleryLayout()
			
			//load the cells from nib
			galleryView.registerNib(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
		}
	}
	
	private var images = [UIImage]()
	{
		didSet
		{
			galleryView.reloadData()
		}
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return images.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
	{
		let cell = galleryView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! GalleryCollectionViewCell
		
		cell.imageView.image = images[indexPath.row]
		
		return cell
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		getImages()
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
				self.images = [UIImage]()
				
				//do this on a dispatch thread because apparently getData is an intensive operation
				//and if I do it on the main queue, Parse complains about it
				//probably for the best
				dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0))
				{
					for object in objects
					{
						if let imageFile = object["data"] as? PFFile
						{
							do
							{
								let image = UIImage(data: try imageFile.getData())!
								dispatch_async(dispatch_get_main_queue())
								{
									self.images.append(image)
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
}
