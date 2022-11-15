//
//  InAppPurchasesView.swift
//  EngageTimer2
//
//  Created by Adam Reed on 1/7/22.
//

import SwiftUI


struct InAppStorePurchasesView: View {
    
    // Store Manager object for making in app purchases
    @StateObject var storeManager: StoreManager
    @EnvironmentObject var vm: HomeViewModel

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text("In-App Purchases")
                    .font(.title)
                    .foregroundColor(Color.theme.secondaryText)
                storeProductsList
                    .padding(.top)
            }
            .padding(.horizontal)
            
            VStack {
                Text("App Add On's")
                Text("Purchase additional in-game currency.")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
                consumableProductsList
            }
            .padding(.top)
            
            menuButtons
            
        }
        .navigationBarHidden(true)
        .padding()
    }
}


// MARK: PREVIEWS
// --------------------
struct InAppStorePurchasesView_Previews: PreviewProvider {
    static var previews: some View {
        InAppStorePurchasesView(storeManager: StoreManager())
    }
}

// MARK: EXTENSIONS
// --------------------
extension InAppStorePurchasesView {
    var menuButtons: some View {
        HStack(spacing: 3) {
            Link("Privacy Policy", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                .padding(.vertical)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            Button(action: {
                // Restore already purchased products
                storeManager.restoreProducts()
            }) {
                Text("Restore Purchases").foregroundColor(.primary)
            }
        }
    }
    
    var storeProductsList: some View {
        // List of Products in store

        ForEach(self.storeManager.myProducts, id: \.price) { product in

            VStack(alignment: .center) {
                Text("\(product.localizedTitle)")
                Text("\(product.localizedDescription)").fixedSize(horizontal: false, vertical: true)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
                
                Button( action: {
                    storeManager.purchaseProduct(product: product)
                }) {
                    VStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.theme.background)
                                .cornerRadius(15.0)
                                .frame(height: 66)
                            HStack {
                                Text((storeManager.purchasedRemoveAds == true) ? "Purchased" : "Purchase")
                                    .bold()
                                    .padding()
                                    .foregroundColor(Color.theme.secondaryText)
                                Spacer()
                                Text("$\(product.price)").font(.caption)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .opacity(storeManager.purchasedRemoveAds == true ? 1.0 : 0.8)
                .disabled(storeManager.purchasedRemoveAds == true)
            }.onAppear(perform: {
                storeManager.myConsumableProducts.sort(by: { $0.price.intValue < $1.price.intValue })
            })
        }
            
            
        
        
        
    }
    
    var consumableProductsList: some View {
        List {
            ForEach(self.storeManager.myConsumableProducts, id: \.self) { product in
                VStack(alignment: .leading) {
                    Button( action: {
                        // Purchase Product
                        storeManager.purchaseProduct(product: product)
       
                    }) {
                        VStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color.theme.background)
                                    .cornerRadius(15.0)
                                    .frame(height: 66)
                                HStack {
                                    Text("\(product.localizedTitle)")
                                        .bold()
                                        .foregroundColor(Color.theme.secondaryText)
                                    
                                    Spacer()
                                    Text("$\(product.price)").font(.caption)
                                }
                                .padding(.horizontal)
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    var explanationBlurb: some View {
        // Explanation at bottom
        VStack(alignment: .leading) {
            Text("Why In App Purchases?").font(.headline).bold().padding(.top)
            Text("I am an independent designer and devleoper, working on apps that help people solve problems, have fun or automate work is my goal. Purchasing an in-app purchase helps me continue to work on projects and apps.").font(.footnote)

            
        }
    }
    
    
}
