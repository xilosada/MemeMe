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
    var cropped: Bool!
    var fontName: String!
    
    /**
        Takes an UIView and return the content converted into an image
        @param view the UIView we want to transform
        @return An image obtained from the UIView
    */
    static func makeAnImageFromView(view:UIView) -> UIImage
    {
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }
}