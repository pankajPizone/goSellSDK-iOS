//
//  LayoutDirectionObserver.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import class	UIKit.UIView.UIView

internal protocol LayoutDirectionObserver: ClassProtocol {
	
	var viewToUpdateLayoutDirection: UIView { get }
	func layoutDirectionChanged()
}

internal extension LayoutDirectionObserver {
	
	internal func startMonitoringLayoutDirectionChanges() -> NSObjectProtocol {
		
		return NotificationCenter.default.addObserver(forName: .tap_sdkLayoutDirectionChanged, object: nil, queue: .main) { [weak self] _ in
			
			self?.viewToUpdateLayoutDirection.tap_updateLayoutDirectionIfRequired()
			self?.layoutDirectionChanged()
		}
	}
	
	internal func stopMonitoringLayoutDirectionChanges(_ observation: Any?) {
		
		if let nonnullObservation = observation {
		
			NotificationCenter.default.removeObserver(nonnullObservation, name: .tap_sdkLayoutDirectionChanged, object: nil)
		}
	}
	
	internal func layoutDirectionChanged() {}
}