//
//  noobLayout.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/1.
//

import SwiftUI
import GameController

struct noobLayout: View {
    @ObservedObject var tuengine: tutorialEngine
    @State var finishTutorial: Int?
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    let tfengine: TFEngine
    
    var body: some View {
        let buttonsPadding=horizontalSizeClass == .regular ? 30.0 : 15.0
        let curState=tuengine.tutState[tuengine.curState]
        let showTooltip=GCKeyboard.coalesced != nil
        VStack {
            Text(NSLocalizedString("24 Points", comment: "The title of the app"))
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text(NSLocalizedString("Tutorial", comment: ""))
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.primary)
            NavigationLink(
                destination: mainView(rotationObserver: UIRotationObserver(), tfengine: tfengine, solengine: tfengine.solengine, showWhatsNew: false),
                tag: 1,
                selection: $finishTutorial,
                label: {
                    EmptyView()
                }
            )
            TutorialTextView(tutString: curState.stateText,
                             skippable: curState.tutProperty.skippable && tuengine.curState != tuengine.tutState.count-1,
                             skipVisible: tuengine.curState==0 || tuengine.curState == tuengine.tutState.count-1,
                             tuengine: tuengine,
                             finishTutorial: $finishTutorial
            )
            
            VStack {
                let doSplit: Bool=CGFloat(2*buttonsPadding+4*maxButtonSize+3*midSpace)<UIScreen.main.bounds.width
                TopButtonsRow(tfengine: tuengine,
                              storeActionEnabled: curState.tutProperty.storeClickable,
                              storeIconColorEnabled: curState.tutProperty.storeHighlighted,
                              storeTextColorEnabled: curState.tutProperty.storeHighlighted,
                              storeRectColorEnabled: curState.tutProperty.storeHighlighted,
                              expr: tuengine.expr,
                              autocompleteHintExpression: nil,
                              answerShowOpacity: 0,
                              answerText: "",
                              incorShowOpacity: 0,
                              incorText: "",
                              resetActionEnabled: false,
                              resetColorEnabled: true,
                              storedExpr: tuengine.stored,
                              doSplit: doSplit,
                              showTooltip: showTooltip
                )
                MiddleButtonRow(colorActive: tuengine.numbButtonsHighlighted,
                                actionActive: tuengine.getNumbButtonsClickable(),
                                cards: tuengine.cards,
                                tfengine: tuengine,
                                doSplit: doSplit
                )
                BottomButtonRow(tfengine: tuengine,
                                oprActionActive: tuengine.getOprButtonsClickable(),
                                oprColorActive: tuengine.oprButtonsHighlighted,
                                doSplit: doSplit
                )
            }.padding(.horizontal,15)
            .padding(.bottom,50)
            .padding(.top,23)
        }.padding(.top,25)
        .navigationBarHidden(true)
        .onAppear {
            canNavBack=false
        }
    }
}

struct noobLayout_Previews: PreviewProvider {
    static var previews: some View {
        noobLayout(tuengine: tutorialEngine(), tfengine: TFEngine(isPreview: true))
    }
}
