//
//  CardInputTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class CardIO.CardIOUtilities.CardIOUtilities
import class TapApplication.TapApplicationPlistInfo
import struct TapCardValidator.DefinedCardBrand
import class UIKit.UIImage.UIImage

internal class CardInputTableViewCellModel: PaymentOptionCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var cell: CardInputTableViewCell?
    
    internal var paymentOptions: [PaymentOption] = [] {
        
        didSet {
            
            self.updatePaymentOptions()
        }
    }
    
    internal let scanButtonVisible = CardIOUtilities.canReadCardWithCamera() && TapApplicationPlistInfo.shared.hasUsageDescription(for: .camera)
    
    internal var scanButtonImage: UIImage {
        
        return Theme.current.settings.cardInputFieldsSettings.scanIcon
    }
    
    internal var displaysAddressFields: Bool {
        
        return self.binData?.isAddressRequired ?? false
    }
    
    internal var tableViewCellModels: [ImageTableViewCellModel]
    internal var displayedTableViewCellModels: [ImageTableViewCellModel] {
        
        didSet {
            
            guard self.displayedTableViewCellModels != oldValue else {
                
                return
            }
            
            self.updateCell(animated: true)
        }
    }
    
    internal lazy var tableViewHandler: CardInputTableViewCellModelTableViewHandler = CardInputTableViewCellModelTableViewHandler(model: self)
    
    internal lazy var cardDataValidators: [CardValidator] = []
    
    internal var definedCardBrand: DefinedCardBrand?
    
    internal lazy var inputData: [ValidationType: Any?] = [:]
    
    internal override var isReadyForPayment: Bool {
        
        return (self.cardDataValidators.filter { !$0.isDataValid }).count == 0
    }
    
    internal var binData: BINResponse?
    
    // MARK: Methods
    
    internal required init(indexPath: IndexPath, paymentOptions: [PaymentOption]) {
        
        let iconURLs = paymentOptions.map { $0.imageURL }
        
        self.tableViewCellModels = type(of: self).generateTableViewCellModels(with: iconURLs)
        self.displayedTableViewCellModels = self.tableViewCellModels
        super.init(indexPath: indexPath)
        
        self.paymentOptions = paymentOptions
        
        if self.scanButtonVisible {
            
            CardIOUtilities.preload()
        }
    }
    
    internal func connectionFinished() {
        
        self.cell?.bindContent()
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func updatePaymentOptions() {
        
        let iconURLs = self.paymentOptions.map { $0.imageURL }
        self.tableViewCellModels = type(of: self).generateTableViewCellModels(with: iconURLs)
        self.updateDisplayedCollectionViewCellModels()
    }
}

// MARK: - SingleCellModel
extension CardInputTableViewCellModel: SingleCellModel {}
