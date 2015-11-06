//
//  PainfulRainbowFunction.swift
//  ImageApp
//
//  Created by Theodore Abshire on 11/6/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

extension UIView
{
	public func painfulRainbowStart()
	{
		rainbowPart(0)(success: true)
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
				self.layer.backgroundColor = UIColor(hue: newHue, saturation: 0.75, brightness: 0.75, alpha: 1).CGColor
			}, completion: rainbowPart(newHue))
	}
}