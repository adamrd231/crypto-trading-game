//
//  LaunchView.swift
//  nftApp
//
//  Created by Adam Reed on 1/21/22.
//

import SwiftUI

struct LaunchView: View {
    
    @State var loadingText: [String] = "Loading your portfolio...".map { String($0)}
    @State var showLoadingText: Bool = false
    @State var counter: Int = 0
    @State var loops: Int = 1
    @Binding var showLaunchView: Bool
    
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            Image("logo")
                .resizable()
                .frame(width: 100, height: 100)
            ZStack {
                if showLoadingText {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                                .offset(y: counter == index ? -5 : 0)
                                
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
                
            }
            .offset(y: 70)
            
        }
        .onAppear(perform: {
            showLoadingText.toggle()
        })
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()) {
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    if loops == 1 {
                        showLaunchView = false
                    }
                    counter = 0
                    loops += 1
                } else {
                    counter += 1
                }
            }
        })
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
