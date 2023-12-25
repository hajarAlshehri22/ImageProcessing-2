//
//  SplashScreen.swift
//  ImageProcessing
//
//  Created by Eman Almalki  on 11/06/1445 AH.
//

import SwiftUI

struct Splachscreen: View {
    
    @State private var animateSplash = true
    @State private var showOnboarding = false
    
    var body: some View {
        ZStack {
            Image("Splash")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .opacity(animateSplash ? 1 : 0)
            
            Image("LogoSplash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding([.leading, .bottom], 70.0)
                .frame(width: 450.0, height: 450.0)
                .imageScale(.small)           .opacity(animateSplash ? 1 : 0)
            
        }
        .onAppear {
            withAnimation(Animation.easeIn(duration: 2.0)) {
                animateSplash = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    showOnboarding = true
                }
               
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            // Your onboarding content goes here
            ContentView()
          // Text("Onboarding Screen")
        }
        .ignoresSafeArea()
    }
}

struct Splachscreen_Previews: PreviewProvider {
    static var previews: some View {
        Splachscreen()
    }
}
