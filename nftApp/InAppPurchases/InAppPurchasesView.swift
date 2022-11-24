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
            menuButtons
            ScrollView {
                
                VStack(alignment: .leading) {
                    Text("App Add On's")
                        .font(.title)
                        .fontWeight(.heavy)
                    Text("Remove advertising or purchase in-game currency.")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
  
                    Divider()
                    storeProductsList
                    consumableProductsList
                        .onAppear(perform: {
                            storeManager.myConsumableProducts.sort(by: { $0.price.intValue < $1.price.intValue })
                        })
                }
            }
            .padding(.horizontal)
            .navigationBarHidden(true)
        }
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
        .padding(.horizontal)
    }
    
    var storeProductsList: some View {
        // List of Products in store

        ForEach(self.storeManager.myProducts, id: \.price) { product in

            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "nosign")
                    .frame(width: 50, height: 50, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text("\(product.localizedTitle)")
                    Text("\(product.localizedDescription)")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                }
               Spacer()
                Button( action: {
                    storeManager.purchaseProduct(product: product)
                }) {
                    Text((storeManager.purchasedRemoveAds == true) ? "" : product.price.description)
                        .font(.callout)
                        .bold()
                        .padding()
                        .foregroundColor(Color.theme.blue)
                }
               
                .opacity(storeManager.purchasedRemoveAds == true ? 1.0 : 0.8)
                .disabled(storeManager.purchasedRemoveAds == true)
            }
        }
    }
    
    var consumableProductsList: some View {
        ForEach(self.storeManager.myConsumableProducts, id: \.self) { product in
            HStack {
                Image("coins")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                VStack(alignment: .leading) {
                    Text("\(product.localizedTitle)")
                    Text("\(product.localizedDescription)")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                }
                Spacer()
                
                Button( action: {
                    storeManager.purchaseProduct(product: product)
                }) {
                    Text("$\(product.price.description)")
                        .font(.callout)
                        .bold()
                        .padding()
                        .foregroundColor(Color.theme.blue)
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
