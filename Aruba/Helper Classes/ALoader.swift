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
        lottieLoader.frame = CGRect(x: 0, y: 0, width: 175, height: 175)
        lottieLoader.center = containerView.center
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.23)
        return containerView
    }()
    
    static var calendarLoaderContainer: UIView = {
        let window = UIApplication.shared.keyWindow!
        let containerView = UIView(frame: window.bounds)
        containerView.addSubview(calendarLoader)
        calendarLoader.frame = containerView.bounds
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.23)
        return containerView
    }()
    
    static var lottieLoader: AnimationView = {
        let lottieView = AnimationView(name: "aruba_loading")
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        lottieView.animationSpeed = 3
        return lottieView
    }()
    
    static var window: UIWindow = {
        UIApplication.shared.keyWindow!
    }()
    
    class func show() {
        if loader.superview == nil {
            window.addSubview(loader)
            loader.alpha = 0
            loader.fadeIn { _ in }
            lottieLoader.play()
        } else {
            print("Trying to show loader on top of loader")
        }
    }
    
    static var calendarLoader: AnimationView = {
        let lottieView = AnimationView(name: "calendar_loading")
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        lottieView.animationSpeed = 1.5
        return lottieView
    }()
    
    class func showCalendarLoader() {
        if calendarLoaderContainer.superview == nil {
            window.addSubview(calendarLoaderContainer)
            calendarLoaderContainer.alpha = 0
            calendarLoaderContainer.fadeIn { _ in }
            calendarLoader.play()
        } else {
            print("Trying to show calemdar loader on top of loader")
        }
    }
    
    class func hideCalendarLoader() {
        calendarLoaderContainer.fadeOut { _ in
            calendarLoader.stop()
            calendarLoaderContainer.removeFromSuperview()
        }
    }
    
    class func hide() {
        loader.fadeOut { _ in
            lottieLoader.stop()
            loader.removeFromSuperview()
        }
    }
}

extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.35, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.35, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = 0
        }, completion: completion)
    }
}
