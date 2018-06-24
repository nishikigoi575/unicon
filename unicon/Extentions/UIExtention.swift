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
        case pink
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
        case .pink:
            return UIColor(displayP3Red: 211.0, green: 96.0, blue: 21.0, alpha: 1)
        default:
            return UIColor(displayP3Red: 253.0, green: 255.0, blue: 252.0, alpha: 1)
        }
    }
    
    static func hex(hex: String, alpha: CGFloat?) -> UIColor {
        let alpha = alpha ?? 1.0
        if hex.count == 6 {
            let rawValue: Int = Int(hex, radix: 16) ?? 0
            let B255: Int = rawValue % 256
            let G255: Int = ((rawValue - B255) / 256) % 256
            let R255: Int = ((rawValue - B255) / 256 - G255) / 256
            
            let color = UIColor(red: CGFloat(R255) / 255,
                                green: CGFloat(G255) / 255,
                                blue: CGFloat(B255) / 255,
                                alpha: alpha)
            return color
        } else {
            let color = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
            return color
        }
    }
    
}
