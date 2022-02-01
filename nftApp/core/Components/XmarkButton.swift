//
//  XmarkButton.swift
//  nftApp
//
//  Created by Adam Reed on 1/18/22.
//

import SwiftUI

struct XmarkButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            print("dismissing view")
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark").font(.headline)
        })
    }
}

struct XmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XmarkButton()
    }
}
