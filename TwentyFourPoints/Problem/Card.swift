//
//  card.swift
//  24 Points
//
//  Created by LegitMichel777 on 2020/12/9.
//

import SwiftUI

func getStringNameOfNum(num: Int) -> String {
    if num>=2&&num<=10 {
        return String(num)
    } else if num<=0 {
        return ""
    } else {
        switch num {
        case 1:
            return "A"
        case 11:
            return "J"
        case 12:
            return "Q"
        case 13:
            return "K"
        default:
            return String(num)
        }
    }
}

func getImageNameOfIcon(icn:cardIcon) -> String {
    if icn == .club {
        return "suit.club.fill"
    } else if icn == .diamond {
        return "suit.diamond.fill"
    } else if icn == .heart {
        return "suit.heart.fill"
    }
    return "suit.spade.fill"
}
struct numView: View {
    var isStationary: Bool
    var CardIcon: cardIcon
    var numberString:String
    var foregroundColor:Color
    var ultraCompetitive: Bool
    var body: some View {
        let animation=ultraCompetitive ? nil : competitiveAnimation
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0, content: {
                HStack {
                    VStack {
                        Image(systemName:getImageNameOfIcon(icn: CardIcon)).font(.system(size: geometry.size.width*0.12))
                            .if (isStationary) { view in
                                view.animation(nil)
                            }
                            .animation(springAnimation)
                            .foregroundColor(Color.white)
                            .colorMultiply(foregroundColor)
                            .animation(animation)
                        Text(numberString).font(.system(size: geometry.size.width*0.12, weight: .medium, design: .rounded))
                            .if (isStationary) { view in
                                view.animation(nil)
                            }
                            .animation(springAnimation)
                            .foregroundColor(Color.white)
                            .colorMultiply(foregroundColor)
                            .animation(animation)
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        Text(numberString).font(.system(size: geometry.size.width*0.12, weight: .medium, design: .rounded))
                            .if (isStationary) { view in
                                view.animation(nil)
                            }
                            .rotationEffect(.init(degrees: 180))
                            .animation(springAnimation)
                            .foregroundColor(Color.white)
                            .colorMultiply(foregroundColor)
                            .animation(animation)
                        Image(systemName:getImageNameOfIcon(icn: CardIcon)).font(.system(size: geometry.size.width*0.12))
                            .if (isStationary) { view in
                                view.animation(nil)
                            }
                            .rotationEffect(.init(degrees: 180))
                            .animation(springAnimation)
                            .foregroundColor(Color.white)
                            .colorMultiply(foregroundColor)
                            .animation(animation)
                    }
                }
            }).frame(minWidth: 0,maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding(.vertical,geometry.size.width*0.07)
            .padding(.horizontal, geometry.size.width*0.06)
        }
    }
}

struct cardButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .saturation(configuration.isPressed ? 0.95 : 1)
            .brightness(configuration.isPressed ? 0.03 : 0) //0.05
    }
}

struct nilButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        }
        else {
            self
        }
    }
}

struct cardDummyView: View {
    var isVisible: Bool
    var body: some View {
        Rectangle()
            .fill(Color.white)
            .aspectRatio(128/177, contentMode: .fit)
            .opacity(isVisible ? 1 : 0.0001)
    }
}

struct cardView: View {
    var active: Bool
    var card: card
    var isStationary: Bool
    var ultraCompetitive: Bool
    var body: some View {
        let foregroundColor=Color.init("CardForeground" + (card.CardIcon == .diamond || card.CardIcon == .heart ? "Red" : "Black") + (active ? "Active" : "Inactive"))
        let animation=ultraCompetitive ? nil : competitiveAnimation
        Rectangle()
            .fill(Color.clear)
            .aspectRatio(128/177, contentMode: .fit)
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: geometry.size.width*0.1,style: .continuous)
                            .foregroundColor(Color.white)
                            .animation(springAnimation)
                            .colorMultiply(Color(active ? "Card-Active-Bg" : "Card-Inactive-Bg"))
                            .animation(animation)
                        RoundedRectangle(cornerRadius: geometry.size.width*0.07,style: .continuous)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: geometry.size.width*0.013, lineCap: .round, lineJoin: .round))
                            .animation(springAnimation)
                            .colorMultiply(foregroundColor)
                            .animation(animation)
                            .padding(geometry.size.width*0.025)
                        Text(String(card.numb)).font(.system(size:(geometry.size.width)*0.55, weight: .medium, design: .rounded))
                            .if (isStationary) { view in
                                view.animation(nil)
                            }
                            .foregroundColor(Color.white)
                            .animation(springAnimation)
                            .colorMultiply(foregroundColor)
                            .animation(animation)
                        numView(isStationary: isStationary, CardIcon: card.CardIcon, numberString: getStringNameOfNum(num: card.numb), foregroundColor: foregroundColor, ultraCompetitive: ultraCompetitive)
                    }
                }
            )
    }
}

struct card_Previews: PreviewProvider {
    static var previews: some View {
        cardView(active: true, card: card(CardIcon: .club, numb: 2), isStationary: false, ultraCompetitive: false)
    }
}
