//
//  SwiftUIView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/1.
//

import SwiftUI

struct TutorialTextView: View {
    var tutString: String
    var skippable: Bool
    var skipVisible: Bool
    var tuengine:tutorialEngine
    @Binding var finishTutorial: Int?
    var body: some View {
        VStack {
            Spacer()
            Text(tutString)
                .padding(.horizontal,30)
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .regular, design: .rounded))
                .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                .animation(springAnimation)
            Spacer()
            HStack {
                if skippable {
                    VStack(spacing:0) {
                        Button(action: {
                            tuengine.updtState()
                            generateHaptic(hap: .medium)
                        }, label: {
                            navBarButton(symbolName: "chevron.forward", active: true)
                                .padding(.top,5)
                                .animation(springAnimation)
                        }).buttonStyle(topBarButtonStyle())
                        .padding(.bottom,8)
                        .keyboardShortcut(KeyEquivalent.return, modifiers: .init([]))
                        Text(NSLocalizedString("Next", comment: "Tutorial tip screen next button"))
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                    }.padding(.bottom,10)
                    .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                    .animation(springAnimation)
                }
                if skipVisible {
                    VStack(spacing:0) {
                        Button(action: {
                            finishTutorial=1
                            generateHaptic(hap: .medium)
                        }, label: {
                            navBarButton(symbolName: "chevron.forward.2", active: true)
                                .padding(.top,5)
                                .animation(springAnimation)
                        }).buttonStyle(topBarButtonStyle())
                        .padding(.bottom,8)
                        .keyboardShortcut(KeyEquivalent.return, modifiers: (skippable ? .init([.command]) : .init([])))
                        Text(NSLocalizedString("Skip", comment: "Tutorial tip screen skip button"))
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                    }.padding(.bottom,10)
                    .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                    .animation(springAnimation)
                }
            }
        }
    }
}

struct TutorialTextView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialTextView(tutString: "Each puzzle consists of 4 integers between 1 and 13 and is guaranteed to have an answer.\nYour goal is to find a way to use addition, subtraction, and multiplication to get 24.", skippable: true, skipVisible: true, tuengine: tutorialEngine(), finishTutorial: Binding.constant(nil))
    }
}
