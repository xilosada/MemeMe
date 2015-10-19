//
//  Meme.swift
//  MemeMe
//
//  Created by X.I. Losada on 19/10/15.
//  Copyright © 2015 XiLosada. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var image: UIImage
    var memedImage: UIImage!
    
    static func generateMemedImageFromView( view:UIView) -> UIImage
    {
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
}