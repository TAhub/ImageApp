//
//  GalleryLayout.swift
//  ImageApp
//
//  Created by Theodore Abshire on 11/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class GalleryLayout: UICollectionViewFlowLayout
{
	override init()
	{
		super.init()
		
//		minimumLineSpacing = 15.0
//		minimumInteritemSpacing = 15.0
		itemSize = CGSize(width: 300, height: 300)
//		sectionInset = UIEdgeInsets(top: 2.0, left: 5.0, bottom: 5.0, right: 5.0)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}
