//
//  Models.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 5/31/24.
//

import Foundation

enum VoiceType: String, Codable, Hashable, Sendable, CaseIterable {
    case alloy
    case echo
    case fable
    case onyx
    case nova
    case shimmer
}

enum VoiceChatState {
    case idle
    case recordingSpeech
    case processingSpeech
    case playingSpeech
    case error(Error)
}
