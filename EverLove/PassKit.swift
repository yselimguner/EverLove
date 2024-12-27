//
//  PassKit.swift
//  EverLove
//
//  Created by Yavuz Selim Güner on 22.12.2024.
//

import Foundation

import PassKit

class PaymentHandler: NSObject {
    static let shared = PaymentHandler()
    private var paymentController: PKPaymentAuthorizationController?
    private var completion: ((Bool) -> Void)?
    
    func startPayment(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = "your.merchant.identifier" // Merchant ID
        request.supportedNetworks = [.visa, .masterCard, .amex]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Premium Üyelik", amount: NSDecimalNumber(string: "4.99"))
        ]
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: request)
        paymentController?.delegate = self
        paymentController?.present { success in
            if !success {
                completion(false)
            }
        }
    }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            self.completion?(true) // İşlem tamamlandı
        }
    }
    
    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        // Ödeme başarıyla onaylandı
        let status = PKPaymentAuthorizationStatus.success
        completion(PKPaymentAuthorizationResult(status: status, errors: nil))
    }
}
