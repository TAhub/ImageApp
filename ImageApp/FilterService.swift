//
//  FilterService.swift
//  ImageApp
//
//  Created by Theodore Abshire on 11/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

class FilterService
{
	private class func filter(filterName:String, filterParameters:[String:AnyObject]) -> UIImage?
	{
		//make the filter
		let filter:CIFilter = CIFilter(name: filterName, withInputParameters: filterParameters)!
		
		//set the parameters of the filter
		
		print(filter.debugDescription)
		print("desires")
		for inputKey in filter.inputKeys
		{
			let attribute = filter.attributes[inputKey] as! [String : AnyObject]
			let inputKeyClassName = attribute[kCIAttributeClass] as! String
			print("\(inputKey) needs a \(inputKeyClassName)")
		}
		
		//get the context
		let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
		let options = [kCIContextWorkingColorSpace : NSNull()]
		let context = CIContext(EAGLContext: eaglContext, options: options)
		
		//make the cgImage
		let outputImage = filter.outputImage
		if let outputImage = outputImage
		{
			let cgImage = context.createCGImage(outputImage, fromRect: outputImage.extent)
			
			//turn it into a uiimage and return it
			return UIImage(CGImage: cgImage)
		}
		return nil
	}
	
	class func blackAndWhiteFilter(image:UIImage, completion: (String?, UIImage?)->())
	{
		//dispatch
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0))
		{
			let image = FilterService.filter("CIPhotoEffectMono", filterParameters: [kCIInputImageKey:CIImage(image: image)!])
			dispatch_async(dispatch_get_main_queue())
				{
					if let image = image
					{
						completion(nil, image)
					}
					else
					{
						completion("ERROR: unable to process image", nil)
					}
			}
		}
	}
	
	class func kaleidoFilter(image:UIImage, completion: (String?, UIImage?)->())
	{
		//dispatch
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0))
		{
			let parameters = [kCIInputImageKey:CIImage(image: image)!, kCIInputCenterKey:CIVector(x: image.size.width / 2, y: image.size.height / 2), "inputCount":NSNumber(double:12)]
			let image = FilterService.filter("CIKaleidoscope", filterParameters: parameters)
			dispatch_async(dispatch_get_main_queue())
				{
					if let image = image
					{
						completion(nil, image)
					}
					else
					{
						completion("ERROR: unable to process image", nil)
					}
			}
		}
	}
	
	class func superSaturFilter(image:UIImage, completion: (String?, UIImage?)->())
	{
		//dispatch
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0))
		{
			let parameters = [kCIInputImageKey:CIImage(image: image)!, kCIInputSaturationKey:NSNumber(double: 1.15), kCIInputBrightnessKey:NSNumber(double: 0.75), kCIInputContrastKey:NSNumber(double: 1.0)]
			let image = FilterService.filter("CIColorControls", filterParameters: parameters)
			dispatch_async(dispatch_get_main_queue())
				{
					if let image = image
					{
						completion(nil, image)
					}
					else
					{
						completion("ERROR: unable to process image", nil)
					}
			}
		}
	}
	
	class func blurFilter(image:UIImage, completion: (String?, UIImage?)->())
	{
		//dispatch
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0))
		{
			let image = FilterService.filter("CIBoxBlur", filterParameters: [kCIInputImageKey:CIImage(image: image)!, kCIInputRadiusKey:NSNumber(double: 35)])
			dispatch_async(dispatch_get_main_queue())
				{
					if let image = image
					{
						completion(nil, image)
					}
					else
					{
						completion("ERROR: unable to process image", nil)
					}
			}
		}
	}
	
	class func haloFilter(image:UIImage, completion: (String?, UIImage?)->())
	{
		//dispatch
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0))
		{
			//make the halo
			let center = CIVector(x: image.size.width / 2, y: image.size.height / 2)
			let color = CIColor(red: 1, green: 1, blue: 1)
			let smallerSize = Double(min(image.size.width, image.size.height))
			let radius = NSNumber(double: smallerSize * 0.6)
			let width = NSNumber(double: smallerSize * 0.2)
			let overlap = NSNumber(double: 0.5)
			let inputTime = NSNumber(double: 0.15)
			let parameters = ["inputCenter":center, "inputColor":color, "inputHaloRadius":radius, "inputHaloWidth":width, "inputHaloOverlap":overlap, "inputTime":inputTime]
			let haloImage = FilterService.filter("CILenticularHaloGenerator", filterParameters: parameters)
			
			if let haloImage = haloImage
			{
				//resize the halo
				let resizedHalo = haloImage.resize(image.size)
				
				//composite the halo on the image
				let compositeImage = FilterService.filter("CIAdditionCompositing", filterParameters: [kCIInputImageKey:CIImage(image: resizedHalo)!, kCIInputBackgroundImageKey:CIImage(image: image)!])
				if let compositeImage = compositeImage
				{
					dispatch_async(dispatch_get_main_queue())
						{
							completion(nil, compositeImage)
					}
					return
				}
			}
			dispatch_async(dispatch_get_main_queue())
				{
					completion("ERROR: unable to process image", nil)
			}
		}
	}
}