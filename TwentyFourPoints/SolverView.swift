//
//  SolverView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/22.
//

import SwiftUI
import GameKit

struct myTextView: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var nextResponder: Bool?
        @Binding var isResponder: Bool?
        
        init(text: Binding<String>,nextResponder : Binding<Bool?> , isResponder : Binding<Bool?>) {
            _text = text
            _isResponder = isResponder
            _nextResponder = nextResponder
        }
        func textFieldDidChangeSelection(_ textField: UITextField) {
            print("Text select changed")
            text = textField.text ?? ""
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            print("Begins editing")
            DispatchQueue.main.async {
                self.isResponder = true
            }
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            print("Should return")
            DispatchQueue.main.async {
                self.isResponder = false
                if self.nextResponder != nil {
                    print("hi")
                    self.nextResponder = true
                }
            }
            return true
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            print("End editing")
            DispatchQueue.main.async {
                self.isResponder = false
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, nextResponder: $nextResponder, isResponder: $isResponder)
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        print("View update")
        uiView.text = text
        if isResponder ?? false {
            uiView.becomeFirstResponder()
        }
    }
    
    @Binding var text: String
    @Binding var nextResponder : Bool?
    @Binding var isResponder : Bool?
    
    func makeUIView(context: Context) -> UITextField {
        let rturn=UITextField()
        rturn.keyboardType = .numberPad
        rturn.text=text
        rturn.delegate=context.coordinator
        return rturn
    }
}

struct SolverView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selectedCardIndex = 0
    @State var eachCardState=[1,1,1,1]
    @ObservedObject var solengine: solverEngine
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var tfengine:TFEngine
    var body: some View {
        VStack(spacing: horizontalSizeClass == .regular ? 20 : 10) {
            HStack {
                Button(action: {
                    tfengine.hapticGate(hap: .medium)
                    presentationMode.wrappedValue.dismiss()
                    tfengine.setAccessPointVisible(visible: true)
                }, label: {
                    navBarButton(symbolName: "chevron.backward", active: true)
                }).buttonStyle(topBarButtonStyle())
                Spacer()
            }.padding(.top, horizontalSizeClass == .regular ? 15 : 0)
            
            Spacer()
            
            HStack {
                ForEach((0..<4), id:\.self) { index in
                    myTextView(text: Binding(get: {
                        String(solengine.cards[index])
                    }, set: { (val) in
                        solengine.setCards(ind: index, val: val)
                    }), nextResponder: Binding(get: {
                        solengine.responderHasFocus[(index+1)%4]
                    }, set: { (val) in
                        solengine.responderHasFocus[(index+1)%4]=val!
                        print("Set responder focus to \(val) for \(index+1)")
                    }), isResponder: Binding(get: {
                        solengine.responderHasFocus[index]
                    }, set: { (val) in
                        solengine.responderHasFocus[index]=val!
                    }))
                }
            }
            Text(NSLocalizedString("ProblemSolver", comment: "solver title"))
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
            
            HStack(spacing:12) {
                ForEach((0..<4), id:\.self) { index in
                    Button(action: {
                        if selectedCardIndex != index {
                            tfengine.hapticGate(hap: .medium)
                            selectedCardIndex=index
                        }
                    }, label: {
                        cardView(active: index != selectedCardIndex, card: card(CardIcon: cardIcon.allCases[index], numb: eachCardState[index]),isStationary: true, ultraCompetitive: false)
                    }).buttonStyle(cardButtonStyle())
                    .animation(.easeInOut(duration: competitiveButtonAnimationTime))
                    .padding(.horizontal, horizontalSizeClass == .regular ? 10 : 0)
                }
            }.padding(.horizontal,23)
            
            let solution=tfengine.solution(problemSet: eachCardState)
            Text(solution==nil ? NSLocalizedString("NoSolution", comment: "nosol") : NSLocalizedString("Solution", comment: "sol"))
                .font(.system(size: 32, weight: .semibold, design: .rounded))
            Text(solution == nil ? " " : solution!.replacingOccurrences(of: "/", with: "÷").replacingOccurrences(of: "*", with: "×"))
                .font(.system(size: 24, weight: .medium, design: .rounded))
            Spacer()
        }
        .background(Color.init("bgColor"))
        .navigationBarHidden(true)
        .onAppear {
            print("Nav back")
            canNavBack=true
            tfengine.setAccessPointVisible(visible: false)
        }.onDisappear {
            print("No nav back")
            canNavBack=false
            tfengine.setAccessPointVisible(visible: true)
        }
    }
}

struct SolverView_Previews: PreviewProvider {
    static var previews: some View {
        SolverView(solengine: solverEngine(), tfengine: TFEngine(isPreview: true))
    }
}
