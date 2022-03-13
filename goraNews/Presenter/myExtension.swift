//
//  myExtensions.swift
//  goraNews
//
//  Created by Yegor Geronin on 12.03.2022.
//

import Foundation
import UIKit

extension UIView {
    public var width: CGFloat{      return self.frame.width }
    public var height: CGFloat{     return self.frame.height }
    public var top: CGFloat{        return self.frame.origin.y }
    public var bottom: CGFloat {    return self.frame.origin.y + self.frame.height }
    public var centerX: CGFloat {   return self.frame.origin.x + self.frame.width / 2 }
    public var centerY: CGFloat {   return self.frame.origin.y + self.frame.height / 2 }
}

extension CGFloat {
    static let heightHeader:CGFloat     = 60
    static let heightScroll:CGFloat     = 275
    static let widthArticle:CGFloat     = 180
    static let heightArticle:CGFloat    = .heightScroll * 0.8
    static let spacingStack:CGFloat     = 10
}

extension CGColor {
    static let gradientColorStart: CGColor = {
        return CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }()
    static let gradientColorEnd: CGColor = {
        return CGColor(red: 0, green: 0, blue: 0, alpha: 0.0)
    }()
}

extension String {
    static let cacheImage:String = "cacheImage"
}
