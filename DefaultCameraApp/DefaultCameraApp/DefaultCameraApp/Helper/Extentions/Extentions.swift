//
//  Extentions.swift
//  DefaultCameraApp
//
//  Created by Nazmul on 02/02/2023.
//


import Foundation
import UIKit

extension UIViewController {
    static func topMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.currentUIWindow()//.filter {$0.isKeyWindow}.first
        return keyWindow?.rootViewController?.topMostViewController()
    }
    
    private func topMostViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.topMostViewController()
        }
        else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController.topMostViewController()
            }
            return tabBarController.topMostViewController()
        }
            
        else if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        
        else {
            return self
        }
    }
}

public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
        
    }
}
