//
//  ContentView.swift
//  XBOX
//
//  Created by Anagh Sharma on 06/05/20.
//  Copyright © 2020 Anagh Sharma. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    @State private var showOnboarding = true
    @State private var offsetController = CGSize.zero
    @State private var offsetPerson = CGSize.zero
    @State private var offsetBag = CGSize.zero
 
    var body: some View {
        ZStack {
            Color("backgroundColor").edgesIgnoringSafeArea(.all)
            Image("xboxLogo")
                .fixedSize()
                .scaleEffect(showOnboarding ? 0.0 : 1)
//                .scaleEffect(0)
                .animation(.easeOut(duration: 0.3))
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                HStack {
                    Text("WELCOME \nTO THE \nALL NEW \nXBOX \nEXPERIENCE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .fixedSize()
                    Spacer()
                }
                .padding(.bottom, 56)
                
                Divider()
                    .frame(width: 256)
                    .padding(.bottom, 56)
                
                HStack(alignment: .center, spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 64, height: 64)
                        Image(systemName: "gamecontroller")
                            .font(.system(size: 24, weight: .bold))
                            .frame(width: 64, height: 64)
                            .background(VisualEffectView(material: .systemUltraThinMaterial))
                            .clipShape(Circle())
                            .offset(y: offsetController.height)
                            .animation(.easeOut(duration: 0.3))
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.height > 0 && gesture.translation.height <= 100 {
                                            self.offsetController = gesture.translation
                                        }
                                }
                                .onEnded { _ in
                                    self.offsetController = CGSize.zero
                                }
                        )
                    }
                        
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 64, height: 64)
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 24, weight: .bold))
                            .frame(width: 64, height: 64)
                            .background(VisualEffectView(material: .systemUltraThinMaterial))
                            .clipShape(Circle())
                            .offset(y: offsetPerson.height)
                            .animation(.easeOut(duration: 0.3))
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.height > 0 && gesture.translation.height <= 100 {
                                            self.offsetPerson = gesture.translation
                                        }
                                }
                                .onEnded { _ in
                                    self.offsetPerson = CGSize.zero
                                }
                        )
                    }
                    
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 64, height: 64)
                        Image(systemName: "bag")
                            .font(.system(size: 24, weight: .bold))
                            .frame(width: 64, height: 64)
                            .padding(.bottom, 4)
                            .background(VisualEffectView(material: .systemUltraThinMaterial))
                            .clipShape(Circle())
                            .offset(y: offsetBag.height)
                                .animation(.easeOut(duration: 0.3))
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            if gesture.translation.height > 0 && gesture.translation.height <= 100 {
                                                self.offsetBag = gesture.translation
                                            }
                                    }
                                    .onEnded { _ in
                                        self.offsetBag = CGSize.zero
                                    }
                        )
                    }
                }
                .padding(.bottom, 128)
                
                Button(action: {
                
                })
                {
                    HStack {
                        Image("microsoftLogo")
                            .fixedSize()
                        Text("Sign In with Microsoft")
                            .fontWeight(.bold)
                    }
                }
                .buttonStyle(FullWidthButtonStyle())
            }
            .padding([.horizontal, .bottom], 16)
            .opacity(showOnboarding ? 1 : 0)
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showOnboarding = true
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
