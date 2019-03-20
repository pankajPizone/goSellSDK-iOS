//
//  BaseViewController.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import ObjectiveC

import struct   Foundation.NSNotification.Notification
import class    Foundation.NSNotification.NotificationCenter
import class    Foundation.NSValue.NSNumber
import class    Foundation.NSValue.NSValue
import func     TapSwiftFixes.performOnMainThread
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UIView.UIView
import class    UIKit.UIViewController.UIViewController

internal class BaseViewController: UIViewController {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal var ignoresKeyboardEventsWhenWindowIsNotKey = false
	
	// MARK: Methods
	
    internal override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.topKeyboardOffsetConstraint != nil || self.bottomKeyboardOffsetConstraint != nil {
            
            self.addKeyboardObserver()
        }
    }
    
    internal override func viewDidDisappear(_ animated: Bool) {
        
        if self.topKeyboardOffsetConstraint != nil || self.bottomKeyboardOffsetConstraint != nil {
            
            self.removeKeyboardObserver()
        }
        super.viewDidDisappear(animated)
    }
    
    internal func performAdditionalAnimationsAfterKeyboardLayoutFinished() { }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var topKeyboardOffsetConstraint: NSLayoutConstraint?
    @IBOutlet private weak var bottomKeyboardOffsetConstraint: NSLayoutConstraint?
    
    // MARK: Methods
    
    private func addKeyboardObserver() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    private func removeKeyboardObserver() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
		
		if let controllerWindow = self.view.window, self.ignoresKeyboardEventsWhenWindowIsNotKey && !controllerWindow.isKeyWindow { return }
		
        performOnMainThread { [weak self] in
            
            guard let strongSelf = self else { return }
            guard let userInfo = notification.userInfo else { return }
            
            guard let window = strongSelf.view.window else { return }
            guard var endKeyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
            endKeyboardFrame = window.convert(endKeyboardFrame, to: strongSelf.view)
            
            let screenSize = strongSelf.view.bounds.size
			
			let offset = max(screenSize.height - endKeyboardFrame.origin.y, 0.0)
			let keyboardIsShown = offset > 0.0
			
            let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
            var animationCurve: UIView.AnimationOptions
            if let animationCurveRawValue = ((userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]) as? NSNumber)?.intValue {
                
                let allPossibleCurves: [UIView.AnimationCurve] = [.easeInOut, .easeIn, .easeOut, .linear]
                let allPossibleRawValues = allPossibleCurves.map { $0.rawValue }
				
                if allPossibleRawValues.contains(animationCurveRawValue), let curve = UIView.AnimationCurve(rawValue: animationCurveRawValue) {
                    
					animationCurve = UIView.AnimationOptions(tap_curve: curve)
                }
                else {
                    
                    animationCurve = keyboardIsShown ? .curveEaseOut : .curveEaseIn
                }
            }
            else {
                
                animationCurve = keyboardIsShown ? .curveEaseOut : .curveEaseIn
            }
            
            let animationOptions: UIView.AnimationOptions = [
                
                .beginFromCurrentState,
                animationCurve
            ]
            
            let animations = { [weak strongSelf] in
                
                guard let strongerSelf = strongSelf else { return }
                
                strongerSelf.topKeyboardOffsetConstraint?.constant = -offset
                strongerSelf.bottomKeyboardOffsetConstraint?.constant = offset
                
                strongerSelf.view.tap_layout()
                
                strongerSelf.performAdditionalAnimationsAfterKeyboardLayoutFinished()
            }
            
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: animations, completion: nil)
        }
    }
}
