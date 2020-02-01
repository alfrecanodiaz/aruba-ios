//
//  ALoader.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/21/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import SVProgressHUD
import Lottie

class ALoader {
    
    static var loader: UIView = {
        let window = UIApplication.shared.keyWindow!
        let containerView = UIView(frame: window.bounds)
        containerView.addSubview(lottieLoader)
        lottieLoader.frame = containerView.bounds
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        return containerView
    }()
    
    static var lottieLoader: AnimationView = {
        let lottieView = AnimationView(name: "aruba_loading")
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 3
        return lottieView
    }()
    
    static var window: UIWindow = {
        UIApplication.shared.keyWindow!
    }()
    
    class func show() {
        if loader.superview == nil {
            window.addSubview(loader)
            lottieLoader.play()
        } else {
            print("Trying to show loader on top of loader")
        }
    }
    
    class func hide() {
        lottieLoader.stop()
        loader.removeFromSuperview()
    }
}
