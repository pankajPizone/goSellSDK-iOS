//
//  URL+Additions.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension URL {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal subscript(queryParameter: String) -> String? {
        
        guard let queryParameters = URLComponents(string: self.absoluteString), let queryItems = queryParameters.queryItems else { return nil }
        guard let queryItem = queryItems.first(where: { $0.name == queryParameter }) else { return nil }
        
        return queryItem.value
    }
}