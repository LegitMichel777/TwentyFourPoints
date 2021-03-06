//
//  InGameRankUpView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/3.
//

import SwiftUI

struct InGameRankUpView: View {
    var tfengine: TFEngine
    var newRank: Int
    var body: some View {
        VStack(spacing:0) {
            Spacer()
            Text("New Rank")
                .font(.system(size: 32, weight: .semibold, design: .rounded))
                .padding(.bottom,10)
            HStack {
                AchievementPropic(imageName: achievement[newRank].name, active: true)
                    .frame(width:72,height:72)
                    .padding(.trailing,10)
                VStack(alignment:.leading) {
                    Text(achievement[newRank].name)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    Text("Level \(String(achievement[newRank].lvlReq))")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
            }.padding(.bottom,20)
            Text(achievement[newRank].description)
                .padding(.horizontal,40)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
                .lineSpacing(1.2)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Button(action: {
                tfengine.hapticGate(hap: .medium)
                tfengine.dismissRank()
            }, label: {
                navBarButton(symbolName: "chevron.forward", active: true)
                    .animation(springAnimation)
            }).buttonStyle(topBarButtonStyle())
        }
    }
}

struct InGameRankUpView_Previews: PreviewProvider {
    static var previews: some View {
        InGameRankUpView(tfengine: TFEngine(isPreview: true), newRank: 5)
    }
}
