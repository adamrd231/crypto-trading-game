//
//  AdMobBanner.swift
//  adamsCalcUpdated
//
//  Created by Adam Reed on 12/22/21.
//

import SwiftUI
import GoogleMobileAds
import UIKit

final private class BannerVC: UIViewControllerRepresentable  {
    
    #if targetEnvironment(simulator)
        // Test Ad
        var GoogleBannerAdId = "ca-app-pub-3940256099942544/2934735716"
    #else
        // Real Ad
        var GoogleBannerAdId = "ca-app-pub-4186253562269967/9926608286"
    #endif
    
    

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)

        let viewController = UIViewController()
        view.adUnitID = GoogleBannerAdId
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        print("Updating UIViewController")
    }
}



struct AdMobBanner: View {
    var body: some View {
        HStack {
            BannerVC().frame(width: 320, height: 55, alignment: .center)
        }
    }
}

struct AdMobBanner_Previews: PreviewProvider {
    static var previews: some View {
        AdMobBanner().previewLayout(.sizeThatFits)
    }
}
