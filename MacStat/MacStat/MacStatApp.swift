//
//  MacStatApp.swift
//  MacStat
//
//  Created by alex haidar on 8/9/24.
//

import SwiftUI
import Dispatch

@main
struct MacStatApp: App {
    
    let windowWidth: CGFloat = 388
    let windowheight: CGFloat = 430
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: windowWidth, height: windowheight)
                .background(VisualEffect().ignoresSafeArea())
                .onAppear {
                    NSApp.appearance = NSAppearance(named: .vibrantDark)
                }
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .windowSize) {}
        }
    }
}
