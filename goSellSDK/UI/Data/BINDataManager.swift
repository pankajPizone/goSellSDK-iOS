//
//  BINDataManager.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import func TapSwiftFixes.performOnMainThread

/// BIN Data manager.
internal final class BINDataManager {
    
    // MARK: - Internal -
    
    internal typealias BINResult = (BINResponse) -> Void
    
    // MARK: Methods
    
    internal func retrieveBINData(for binNumber: String, success: @escaping BINResult) {
        
        if let cachedResponse = self.cachedBINData[binNumber] {
            
            self.callCompletion(success, with: cachedResponse)
            return
        }
        
        guard !self.pendingBINs.contains(binNumber) else { return }
        self.pendingBINs.append(binNumber)
        
        APIClient.shared.getBINDetails(for: binNumber) { [weak self] (response, error) in
            
            if let index = self?.pendingBINs.index(of: binNumber) {
                
                self?.pendingBINs.remove(at: index)
            }
            
            if let nonnullResponse = response {
                
                self?.cachedBINData[binNumber] = nonnullResponse
                self?.callCompletion(success, with: nonnullResponse)
            }
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private lazy var cachedBINData: [String: BINResponse] = [:]
    private lazy var pendingBINs: [String] = []
    
    private static var storage: BINDataManager?
    
    // MARK: Methods
    
    private init() {
        
        KnownSingletonTypes.add(BINDataManager.self)
    }
    
    private func callCompletion(_ closure: @escaping BINResult, with result: BINResponse) {
        
        performOnMainThread {
            
            closure(result)
        }
    }
}

// MARK: - Singleton
extension BINDataManager: Singleton {
    
    internal static var shared: BINDataManager {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = BINDataManager()
        self.storage = instance
        
        return instance
    }
    
    internal static func destroyInstance() {
        
        self.storage = nil
    }
}
