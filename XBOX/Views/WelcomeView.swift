//
//  ContentView.swift
//  XBOX
//
//  Created by Anagh Sharma on 06/05/20.
//  Copyright © 2020 Anagh Sharma. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    @State private var selection = 0
 
    var body: some View {
        ZStack {
            Color("backgroundColor").edgesIgnoringSafeArea(.all)
            Text("Hello")
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
