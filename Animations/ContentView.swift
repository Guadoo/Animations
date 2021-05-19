//
//  ContentView.swift
//  Animations
//
//  Created by Guadoo on 2021/5/18.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animationAmount = 0.0
    
    private let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    @State private var isShowingRed = false
    
    var body: some View {
        
        VStack{
            Button("Tap Me") {
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)){
                    self.animationAmount += 360
                }
            }
            .padding(50)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .rotation3DEffect(
                .degrees(animationAmount),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            
            Spacer()
            
            
            HStack(spacing: 0){
                ForEach( 0 ..< letters.count) { num in
                    Text(String(self.letters[num]))
                        .padding(5)
                        .font(.title)
                        .background(self.enabled ? Color.blue : Color.red)
                        .offset(self.dragAmount)
                        .animation(Animation.default.delay(Double(num) / 20))
                }
            }
            .gesture(
                DragGesture()
                    .onChanged{self.dragAmount = $0.translation}
                    .onEnded{_ in
                        self.dragAmount = .zero
                        self.enabled.toggle()
                        
                    }
            )
        
            Spacer()
            
            VStack {
                Button("Tap Me") {
                    withAnimation {
                        isShowingRed.toggle()
                    }
                }
                
                if isShowingRed {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 200, height: 200, alignment: .center)
                        .transition(.pivot)
                }
            }
            Spacer()
        }
    }
}


struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(amount: -90, anchor: .topLeading),
                  identity: CornerRotateModifier(amount: 0, anchor: .topLeading))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
