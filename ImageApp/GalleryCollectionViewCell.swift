//
//  GalleryCollectionViewCell.swift
//  ImageApp
//
//  Created by Theodore Abshire on 11/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var imageFrame: UIView!
	{
		didSet
		{
			//make the frame beautiful
			rainbowPart(0)(success: true)
		}
	}
	
	private func rainbowPart(hue:CGFloat)(success:Bool)
	{
		var newHue = hue + 0.05
		if newHue > 1
		{
			newHue -= 1
		}
		
		UIView.animateWithDuration(0.1, animations:
		{
			self.imageFrame.layer.backgroundColor = UIColor(hue: newHue, saturation: 0.75, brightness: 0.75, alpha: 1).CGColor
		}, completion: rainbowPart(newHue))
	}
	
	
}
