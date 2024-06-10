//
//  ButtonView.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 5/29/24.
//

import SwiftUI

struct ButtonView: View {
    let buttonDetails: ButtonDetails
    var onSelectURL: (URL) -> Void
    @State private var isHovered = false

    var body: some View {
        Button (action: {onSelectURL(buttonDetails.url)})
        {
        Image(buttonDetails.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .animation(.easeInOut(duration: 0.3))
            .padding()
            .background(Color.clear)
            .cornerRadius(2)
        }
        .buttonBorderShape(.roundedRectangle(radius: 5))
        .buttonStyle(.plain)

    }
}

