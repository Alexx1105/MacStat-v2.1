//
//  MacStatApp.swift
//  MacStat
//
//  Created by alex haidar on 8/9/24.
//

import SwiftUI
import Dispatch

func closeWindow() {
         if let window = NSApplication.shared.keyWindow {
          window.close()
    }
}



@main
struct MacStatApp: App {
    
    
    let windowWidth: CGFloat = 500
    let windowheight: CGFloat = 430
    
    var body: some Scene {
        WindowGroup {
         
            ContentView()
                .frame(width: windowWidth, height: windowheight)
                .background(VisualEffect().ignoresSafeArea())
                .onAppear {
                    NSApp.appearance = NSAppearance(named: .vibrantDark)
                    if let removeButtons = NSApplication.shared.windows.first {
                        removeButtons.standardWindowButton(.closeButton)?.isHidden = true
                        removeButtons.standardWindowButton(.miniaturizeButton)?.isHidden = true
                        removeButtons.standardWindowButton(.zoomButton)?.isHidden = true
                    }
                }
            
                .onAppear {
                    let stationaryWindow = NSApplication.shared.windows.first
                    stationaryWindow?.center()
                    stationaryWindow?.isMovable = true
                    stationaryWindow?.level = .floating
                }
               
                
            
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .commands {
        
            CommandGroup(replacing: .windowSize) {}
            CommandGroup(replacing: .appTermination) {
                Button("command + q to quit") {
                    NSApp.terminate(nil)
                }
                .keyboardShortcut("q", modifiers: [.command])
            }
        }
    }
}
