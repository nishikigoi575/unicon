//
//  Storyboard+Utility.siwft.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/17.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    enum UCType: String {
        case main
        case login
        case matching
        case topic
        case profile
        case welcome
        case onboard
        case notification
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(type: UCType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: UCType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        
        return initialViewController
    }
    
    static func moveToAnotherStoryboard(for type: UCType, currentView: UIViewController) -> Void {
        let initialViewController = self.initialViewController(for: type)
        currentView.view.window?.rootViewController = initialViewController
        currentView.view.window?.makeKeyAndVisible()
    }
}
