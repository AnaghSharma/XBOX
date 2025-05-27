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
    @State private var welcomeText = "WELCOME \nTO THE \nALL NEW \nXBOX \nEXPERIENCE"
    @State private var nextWelcomeText = "CONTROL \nYOUR \nXBOX \nWITH THE \nAPP"
    @State private var textOpacity: Double = 1
    @State private var showChevron = true
    @State private var isDragging = false
    @State private var animating = false
    @State private var dragProgress: CGFloat = 0.0
    
    private let maxDrag: CGFloat = 100.0 // max drag distance
    private let lineHeight: CGFloat = 44.0
    
    private var welcomeLines: [String] {
        welcomeText.components(separatedBy: "\n")
    }
    
    private var nextWelcomeLines: [String] {
        nextWelcomeText.components(separatedBy: "\n")
    }
    
    private var maxLines: Int {
        max(welcomeLines.count, nextWelcomeLines.count)
    }
    
    var body: some View {
        ZStack {
            Color("backgroundColor").edgesIgnoringSafeArea(.all)
            Image("xboxLogo")
                .fixedSize()
                .scaleEffect(showOnboarding ? 0.0 : 1)
                .animation(.easeOut(duration: 0.3))
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(0..<maxLines, id: \.self) { i in
                            let lineProgress = min(max((dragProgress * CGFloat(maxLines)) - CGFloat(i), 0), 1)
                            ZStack(alignment: .leading) {
                                // Old line animating out
                                if i < welcomeLines.count {
                                    Text(welcomeLines[i])
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .fixedSize()
                                        .offset(y: lineProgress * lineHeight)
                                        .opacity(Double(1 - lineProgress))
                                        .animation(.none, value: dragProgress)
                                }
                                // New line animating in
                                if i < nextWelcomeLines.count {
                                    Text(nextWelcomeLines[i])
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .fixedSize()
                                        .offset(y: (1 - lineProgress) * -lineHeight)
                                        .opacity(Double(lineProgress))
                                        .animation(.none, value: dragProgress)
                                }
                            }
                            .frame(height: lineHeight, alignment: .top)
                            .clipped()
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 56)
                
                Divider()
                    .frame(width: 256)
                    .padding(.bottom, 56)
                
                HStack(alignment: .top, spacing: 16) {
                    VStack(spacing: 16) {
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
                                            let progress = min(max(gesture.translation.height / maxDrag, 0), 1)
                                            self.offsetController = gesture.translation
                                            self.showChevron = false
                                            self.dragProgress = progress
                                        }
                                        .onEnded { _ in
                                            self.offsetController = CGSize.zero
                                            self.showChevron = true
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                self.dragProgress = 0
                                            }
                                        }
                                )
                        }
                        ChevronAnimator()
                            .opacity(showChevron ? 1 : 0)
                            .animation(.easeInOut(duration: 0.3), value: showChevron)
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

// MARK: - Preview

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
