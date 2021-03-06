//
//  CardBrandChangeReporting.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol CardBrandChangeReporting: ClassProtocol {
    
    func cardNumberValidator(_ validator: CardNumberValidator, cardNumberInputChanged cardNumber: String)
    func recognizedCardBrandChanged(_ definedCardBrand: BrandWithScheme)
}
