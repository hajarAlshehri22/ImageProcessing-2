//
//  ImageProcessingApp.swift
//  ImageProcessing
//
//  Created by Hajar Alshehri on 01/06/1445 AH.
//

import SwiftUI

@main
struct ImageProcessingApp: App {
    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.bool(forKey: "OnboardingShown") {
                ContentView()
                      } else {
                          Splachscreen()
                      }
        }
    }
}

