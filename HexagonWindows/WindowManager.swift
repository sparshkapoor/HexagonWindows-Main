//
//  WindowManager.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 6/10/24.
//

import SwiftUI


class WindowManager: ObservableObject {
    @Published var windows: [UUID: Bool] = [:] // Dictionary to track window states

    func closeAllWindows() {
        for key in windows.keys {
            windows[key] = false
        }
    }
}
