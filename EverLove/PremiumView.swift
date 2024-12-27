//
//  PremiumView.swift
//  EverLove
//
//  Created by Yavuz Selim Güner on 21.12.2024.
//

import SwiftUI

struct PremiumView: View {
    @State private var showAlert: Bool = false
    @State private var paymentSuccessful: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Ekran 3")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Button(action: {
                showAlert = true
            }) {
                Text("Premium'a Geç")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Reklamları istemiyorsanız..."),
                    message: Text("Premium'a geçerek reklamları kaldırabilirsiniz."),
                    primaryButton: .default(Text("Devam Et"), action: {
                        PaymentHandler.shared.startPayment { success in
                            paymentSuccessful = success
                        }
                    }),
                    secondaryButton: .cancel(Text("İptal"))
                )
            }
            
            if paymentSuccessful {
                Text("Ödeme başarılı! Premium özelliklerin keyfini çıkarın.")
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}

struct PremiumView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumView()
    }
}

