//
//  FilterViewController.swift
//  ImageApp
//
//  Created by Theodore Abshire on 11/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

typealias filterFunction = (UIImage, (String?, UIImage?) -> ())->()

protocol FilterViewDelegate
{
	func applyFilterToImage(filter:filterFunction)
}

class FilterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

	@IBOutlet weak var collectionView: UICollectionView!
	{
		didSet
		{
			collectionView.delegate = self
			collectionView.dataSource = self
			collectionView.collectionViewLayout = GalleryLayout()
			
			//load the cells from nib
			collectionView.registerNib(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "filterCell")
		}
	}
	var baseImage:UIImage!
	{
		didSet
		{
			thumbnailBaseImage = baseImage.resize(CGSize(width: 80.0, height: 80.0))
		}
	}
	private var thumbnailBaseImage:UIImage!
	
	var delegate:FilterViewDelegate!
	
	private var filters = [(UIImage, String, filterFunction)]()
	{
		didSet
		{
			collectionView.reloadData()
		}
	}
	
    override func viewDidLoad()
	{
        super.viewDidLoad()

		//generate the filters
		//...on the filter train! choo choo!
		self.filterTrain(FilterService.blackAndWhiteFilter, title: "Black and White")
		{
			self.filterTrain(FilterService.blurFilter, title: "Blur")
			{
				self.filterTrain(FilterService.haloFilter, title: "Halo")
				{
					self.filterTrain(FilterService.kaleidoFilter, title: "Kaleidoscope")
					{
						self.filterTrain(FilterService.superSaturFilter, title: "The Saturator") {}
					}
				}
			}
		}
    }
	
	private func filterTrain(filterFunc:filterFunction, title:String, nextFilterTrain:()->())
	{
		filterFunc(thumbnailBaseImage)
		{ (error, image) in
			if let error = error
			{
				print(error)
			}
			else if let image = image
			{
				self.filters.append(image, title, filterFunc)
			}
			nextFilterTrain()
		}
	}
	
	//MARK: datasource
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return filters.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filterCell", forIndexPath: indexPath) as! GalleryCollectionViewCell
		
		cell.imageView.image = filters[indexPath.row].0
		cell.label.text = filters[indexPath.row].1
		print(cell.label.text)
		
		return cell
	}
	
	//MARK: delegate
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
	{
		performSegueWithIdentifier("applyFilterSegue", sender: self)
		//delegate.applyFilterToImage(filters[indexPath].2)
	}
}
