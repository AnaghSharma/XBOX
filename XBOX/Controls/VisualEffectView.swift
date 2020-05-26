//
//  VisualEffectView.swift
//  XBOX
//
//  Created by Anagh Sharma on 27/05/20.
//  Copyright © 2020 Anagh Sharma. All rights reserved.
//

import SwiftUI
import UIKit

struct VisualEffectView: UIViewRepresentable {
    var material: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: material))
    }

    func updateUIView(_ visualEffectView: UIVisualEffectView, context: Context) {
        visualEffectView.effect = UIBlurEffect(style: material)
    }
}

