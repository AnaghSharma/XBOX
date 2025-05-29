//
//  ContentView.swift
//  XBOX
//
//  Created by Anagh Sharma on 06/05/20.
//  Copyright © 2020 Anagh Sharma. All rights reserved.
//

import SwiftUI

// MARK: - Reusable Components (Existing or previously suggested)

// Assume VisualEffectView and FullWidthButtonStyle are defined elsewhere if not in this file.
// If they are in this file, they should be kept.

// struct IconButton: View { ... }
// struct HeaderText: View { ... }
// struct CustomDivider: View { ... }
// struct MicrosoftSignInButton: View { ... }

// MARK: - Chevron Animator Component


// MARK: - Main View

struct DraggableIconData: Identifiable {
    let id = UUID()
    let systemName: String
    let altLines: [String]
    var offset: CGSize = .zero
}

struct DraggableIconView: View {
    let systemName: String
    let altLines: [String]
    @Binding var offset: CGSize
    let onDragChanged: (CGFloat) -> Void
    let onDragEnded: () -> Void
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black)
                .frame(width: 64, height: 64)
            Image(systemName: systemName)
                .font(.system(size: 24, weight: .bold))
                .frame(width: 64, height: 64)
                .background(VisualEffectView(material: .systemUltraThinMaterial))
                .clipShape(Circle())
                .offset(y: offset.height)
                .animation(.easeOut(duration: 0.3), value: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let vertical = max(gesture.translation.height, 0)
                            offset = CGSize(width: 0, height: vertical)
                            let progress = min(vertical / 100, 1)
                            onDragChanged(progress)
                        }
                        .onEnded { _ in
                            offset = .zero
                            onDragEnded()
                        }
                )
        }
    }
}

// Robust SwiftUI-compatible version using @ViewBuilder and HStack
@ViewBuilder
func highlightedText(line: String, keyword: String) -> some View {
    if let range = line.range(of: keyword, options: .caseInsensitive) {
        let before = String(line[..<range.lowerBound])
        let match = String(line[range])
        let after = String(line[range.upperBound...])
        HStack(spacing: 0) {
            Text(before).fontWeight(.bold).opacity(0.6)
            Text(match).fontWeight(.bold).opacity(1.0)
            Text(after).fontWeight(.bold).opacity(0.6)
        }
    } else {
        Text(line).fontWeight(.bold).opacity(0.6)
    }
}

struct WelcomeView: View {
    @State private var showOnboarding = true
    @State private var welcomeText = "WELCOME \nTO THE \nALL NEW \nXBOX \nEXPERIENCE"
    @State private var textOpacity: Double = 1
    @State private var showChevron = true
    @State private var dragProgress: CGFloat = 0.0
    @State private var currentAltLines: [String] = []
    @State private var draggingIndex: Int? = nil
    @State private var icons: [DraggableIconData] = [
        DraggableIconData(systemName: "gamecontroller", altLines: ["CONTROL", "YOUR", "CONSOLE", "WITH", "THE APP"]),
        DraggableIconData(systemName: "person.crop.circle", altLines: ["CONNECT", "WITH", "YOUR", "FRIENDS", "INSTANTLY"]),
        DraggableIconData(systemName: "bag", altLines: ["BUY", "GAMES", "RIGHT", "FROM", "THE APP"])
    ]
    
    private let maxDrag: CGFloat = 100.0 // max drag distance
    private let lineHeight: CGFloat = 44.0
    
    private var welcomeLines: [String] {
        welcomeText.components(separatedBy: "\n")
    }
    private var maxLines: Int {
        max(welcomeLines.count, currentAltLines.count)
    }
    
    // Helper to get the keyword for the current context
    private var currentKeyword: String {
        if let idx = draggingIndex {
            switch idx {
            case 0: return "CONTROL"
            case 1: return "CONNECT"
            case 2: return "BUY"
            default: return "XBOX"
            }
        } else {
            return "XBOX"
        }
    }
    
    var body: some View {
        ZStack {
            Color("backgroundColor").edgesIgnoringSafeArea(.all)
            Image("xboxLogo")
                .fixedSize()
                .scaleEffect(showOnboarding ? 0.0 : 1)
                .animation(.easeOut(duration: 0.3))
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(0..<maxLines, id: \.self) { i in
                                ZStack(alignment: .leading) {
                                    if i < welcomeLines.count {
                                        highlightedText(line: welcomeLines[i], keyword: "XBOX")
                                            .font(.largeTitle)
                                            .fixedSize()
                                            .offset(y: dragProgress * lineHeight)
                                            .animation(.easeInOut(duration: 0.3), value: dragProgress)
                                    }
                                    if i < currentAltLines.count {
                                        highlightedText(line: currentAltLines[i], keyword: currentKeyword)
                                            .font(.largeTitle)
                                            .fixedSize()
                                            .offset(y: (1 - dragProgress) * -lineHeight)
                                            .animation(.easeInOut(duration: 0.3), value: dragProgress)
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
                        ForEach(icons.indices, id: \.self) { i in
                            if i == 0 {
                                VStack(spacing: 16) {
                                    DraggableIconView(
                                        systemName: icons[i].systemName,
                                        altLines: icons[i].altLines,
                                        offset: Binding(
                                            get: { icons[i].offset },
                                            set: { icons[i].offset = $0 }
                                        ),
                                        onDragChanged: { progress in
                                            if progress > 0 { self.showChevron = false }
                                            self.currentAltLines = icons[i].altLines
                                            self.dragProgress = progress
                                            self.draggingIndex = i
                                        },
                                        onDragEnded: {
                                            self.showChevron = true
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                self.dragProgress = 0
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                self.currentAltLines = []
                                                self.draggingIndex = nil
                                            }
                                        }
                                    )
                                    ChevronAnimator()
                                        .opacity(showChevron ? 1 : 0)
                                        .animation(.easeInOut(duration: 0.3), value: showChevron)
                                }
                            } else {
                                DraggableIconView(
                                    systemName: icons[i].systemName,
                                    altLines: icons[i].altLines,
                                    offset: Binding(
                                        get: { icons[i].offset },
                                        set: { icons[i].offset = $0 }
                                    ),
                                    onDragChanged: { progress in
                                        if progress > 0 { self.showChevron = false }
                                        self.currentAltLines = icons[i].altLines
                                        self.dragProgress = progress
                                        self.draggingIndex = i
                                    },
                                    onDragEnded: {
                                        self.showChevron = true
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            self.dragProgress = 0
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            self.currentAltLines = []
                                            self.draggingIndex = nil
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.bottom, 128)
                }
                .padding([.bottom], 16)
                .opacity(showOnboarding ? 1 : 0)
                Spacer()
                Button(action: {
                    // Sign in action
                }) {
                    HStack {
                        Image("microsoftLogo")
                            .fixedSize()
                        Text("Sign In with Microsoft")
                            .fontWeight(.bold)
                    }
                }
                .buttonStyle(FullWidthButtonStyle())
                .padding(.bottom, 4)
            }
            .padding(.horizontal, 16)
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
