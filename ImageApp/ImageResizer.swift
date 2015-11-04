//
//  ImageResizer.swift
//  ImageApp
//
//  Created by Theodore Abshire on 11/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

extension UIImage
{
	func resize(size:CGSize) -> UIImage
	{
		//don't resize if you're already that size
		if size == self.size
		{
			return self
		}
		
		UIGraphicsBeginImageContext(size)
		drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
}