//
//  MainScreen.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 5/29/24.
//

import SwiftUI

struct MainScreen: View {
    let buttons: [ButtonDetails]
    var onSelectURL: (URL) -> Void
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 0.2) { // Reduce spacing to bring buttons closer
                    Spacer()
                    VStack(spacing: 0.2) { // Reduce spacing to bring buttons closer
                        ButtonView(buttonDetails: buttons[0], onSelectURL: onSelectURL)
                            .frame(width: geometry.size.width * 0.28, height: geometry.size.width * 0.28)
                            .contentShape(.hoverEffect, .rect(cornerRadius: 8))
                        
                        ButtonView(buttonDetails: buttons[2], onSelectURL: onSelectURL)
                            .frame(width: geometry.size.width * 0.28, height: geometry.size.width * 0.28)
                            .contentShape(.hoverEffect, .rect(cornerRadius: 8))
                    }
                    Spacer()
                    VStack(spacing: 0.2) { // Reduce spacing to bring buttons closer
                        ButtonView(buttonDetails: buttons[1], onSelectURL: onSelectURL)
                            .frame(width: geometry.size.width * 0.28, height: geometry.size.width * 0.28)
                            .contentShape(.hoverEffect, .rect(cornerRadius: 8))
                        
                        ButtonView(buttonDetails: buttons[3], onSelectURL: onSelectURL)
                            .frame(width: geometry.size.width * 0.28, height: geometry.size.width * 0.28)
                            .contentShape(.hoverEffect, .rect(cornerRadius: 8))
                    }
                    Spacer()
                }
                
            }

            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.clear)
        }
    }
}












