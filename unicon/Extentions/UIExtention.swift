//
//  UIExtention.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/22.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    enum coolor {
        case red
        case blue
        case black
        case white
        case gray
    }
    
    func UCColor(color: coolor) -> UIColor {
        
        switch color {
        case .red:
            // #EF6461
            return UIColor(displayP3Red: 239.0, green: 100.0, blue: 97.0, alpha: 1)
        case .blue:
            // #348AA7
            return UIColor(displayP3Red: 52.0, green: 138.0, blue: 167.0, alpha: 1)
        case .black:
            // #1C2826
            return UIColor(displayP3Red: 28.0, green: 40.0, blue: 38.0, alpha: 1)
        case .white:
            // #FDFFFC
            return UIColor(displayP3Red: 253.0, green: 255.0, blue: 252.0, alpha: 1)
        case .gray:
            // #BAD1CD
            return UIColor(displayP3Red: 186.0, green: 209.0, blue: 205.0, alpha: 1)
        default:
            return UIColor(displayP3Red: 253.0, green: 255.0, blue: 252.0, alpha: 1)
        }
    }
    
}
