//
//  whatsnewview.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/5/4.
//

import SwiftUI

let newVersion="1.1"
let numFeats=4

struct whatsnewview: View {
    var tfengine: TFEngine
    @State var continueClicked=false
    @State var continueHover=false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack(spacing:0) {
            AppLogoTitleView()
                .padding(.top,130)
                .padding(.bottom,61)
            Text(NSLocalizedString("NewVersionPrefix", comment: "")+newVersion+NSLocalizedString("NewVersionPostfix", comment: ""))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .padding(.horizontal,68)
                .multilineTextAlignment(.center)
                .padding(.bottom,26)
            VStack(spacing:4) {
                ForEach((1...numFeats), id: \.self) { index in
                    HStack(spacing:0) {
                        Text("- "+NSLocalizedString("nfe"+String(index), comment: "New feature"))
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                        Spacer()
                    }
                }
            }.padding(.horizontal,33)
            Spacer()
            Button(action: {
                tfengine.hapticGate(hap: .medium)
                presentationMode.wrappedValue.dismiss()
                tfengine.refresh()
            }, label: {
                borederedButton(title: NSLocalizedString("WhatsNewContinue", comment: ""), clicked: continueClicked, width:190,isOnSheet: true)
            }).buttonStyle(nilButtonStyle())
            .modifier(TouchDownUpEventModifier(changeState: { (buttonState) in
                if buttonState == .pressed {
                    continueClicked=true
                } else {
                    continueClicked=false
                }
            })).onHover(perform: { hovering in
                continueHover=hovering
            }).brightness(continueHover ? hoverBrightness : 0)
            .padding(.bottom,60)
        }
    }
}

struct whatsnewview_Previews: PreviewProvider {
    static var previews: some View {
        whatsnewview(tfengine: TFEngine(isPreview: true))
    }
}
