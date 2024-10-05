//
//  VisualEffect.swift
//  MacStat
//
//  Created on 10/5/24.
//

import Foundation
import SwiftUI
import AppKit

struct VisualEffect: NSViewRepresentable {
    func makeNSView(context: Self.Context) -> NSView {
        let effectView = NSVisualEffectView()
        effectView.state = NSVisualEffectView.State.active
        return effectView
    }
    func updateNSView(_ nsView: NSView, context: Context) { }
}
