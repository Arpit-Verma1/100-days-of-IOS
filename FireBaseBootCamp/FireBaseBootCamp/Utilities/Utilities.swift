//
//  Utilities.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 26/01/25.
//

import Foundation
import UIKit


final class Utilities {
    static let shared  = Utilities();
    private init() {}
    
    class func topViewController(controller: UIViewController? = nil) -> UIViewController? {
            
            let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
            
            if let navigationController = controller as? UINavigationController {
                return topViewController(controller: navigationController.visibleViewController)
            }
            if let tabController = controller as? UITabBarController {
                if let selected = tabController.selectedViewController {
                    return topViewController(controller: selected)
                }
            }
            if let presented = controller?.presentedViewController {
                return topViewController(controller: presented)
            }
            return controller
        }

    
}
