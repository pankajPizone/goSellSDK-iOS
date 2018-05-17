//
//  PaymentContentViewController.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class TapVisualEffectView.TapVisualEffectView
import class UIKit.UIStoryboardSegue.UIStoryboardSegue
import class UIKit.UIViewController.UIViewController

/// Payment Content View Controller.
internal class PaymentContentViewController: BaseViewController {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        self.subscribeOnNotifications()
    }
    
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let merchantHeaderController = segue.destination as? MerchantInformationHeaderViewController {
            
            merchantHeaderController.delegate = self
        }
        else if let cardScannerController = segue.destination as? CardScannerViewController {
            
            PaymentDataManager.shared.prepareCardScannerController(cardScannerController)
        }
    }
    
    deinit {
        
        self.unsubscribeFromNotifications()
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    @IBOutlet private weak var payButtonUI: PayButtonUI? {
        
        didSet {
            
            if let nonnullPayButton = self.payButtonUI {
                
                PaymentDataManager.shared.linkWith(nonnullPayButton)
            }
        }
    }
    
    // MARK: Methods
    
    private func subscribeOnNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(cardScannerButtonClicked(_:)), name: .cardScannerButtonClicked, object: nil)
    }
    
    private func unsubscribeFromNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .cardScannerButtonClicked, object: nil)
    }
    
    @objc private func cardScannerButtonClicked(_ notification: Notification) {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "\(CardScannerViewController.className)Segue", sender: self)
        }
    }
}

// MARK: - MerchantInformationHeaderViewControllerDelegate
extension PaymentContentViewController: MerchantInformationHeaderViewControllerDelegate {
    
    internal func merchantInformationHeaderViewControllerCloseButtonClicked(_ controller: MerchantInformationHeaderViewController) {
        
        DispatchQueue.main.async {
            
            let dismissalClosure = {
                
                let presentingController = self.presentingViewController
                self.dismiss(animated: true) {
                    
                    presentingController?.dismiss(animated: false) {
                        
                        PaymentDataManager.userDidClosePayment()
                    }
                }
            }
            
            if let firstResponder = self.view.firstResponder {
                
                firstResponder.resignFirstResponder(dismissalClosure)
            }
            else {
                
                dismissalClosure()
            }
        }
    }
}
