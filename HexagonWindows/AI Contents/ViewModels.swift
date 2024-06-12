 //
//  ViewModels.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 5/31/24.
//


//
//  ViewModels.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 5/31/24.
//

import AVFoundation
import Foundation
import Observation
import ChatGPTSwift
import cmdCenterAI

@Observable
class ViewModels: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    // ChatGPT API client for interacting with the ChatGPT service
    let client = ChatGPTAPI(apiKey: "API-KEY")
    
    // Audio player and recorder instances
    var audioPlayer: AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    
    #if !os(macOS)
    // Audio session for managing audio recording and playback
    var recordingSession = AVAudioSession.sharedInstance()
    #endif
    
    // Timers for managing animations and recording duration
    var animationTimer: Timer?
    var recordingTimer: Timer?
    
    // Audio power level for visual feedback
    var audioPower = 0.0
    var prevAudioPower: Double?
    
    // Task for processing speech in the background
    var processingSpeechTask: Task<Void, Never>?
    
    // URL to save the captured audio file
    var captureURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first!.appendingPathComponent("recording.m4a")
    }
    
    // State management for voice chat
    var state = VoiceChatState.idle {
        didSet { print(state) }
    }
    
    // Check if the state is idle
    var isIdle: Bool {
        if case .idle = state {
            return true
        }
        return false
    }
    
    // Opacity for Siri waveform animation based on state
    var siriWaveFormOpacity: CGFloat {
        switch state {
        case .recordingSpeech, .playingSpeech: return 1
        default: return 0
        }
    }
    
    override init() {
        super.init()
        
        // Configure audio session for recording and playback
        #if !os(macOS)
        do {
            #if os(iOS)
            try recordingSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            #else
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            #endif
            try recordingSession.setActive(true)
            
            // Request permission to record audio
            AVAudioSession.sharedInstance().requestRecordPermission { [unowned self] allowed in
                if !allowed {
                    self.state = .error("Recording not allowed by the user" as Error)
                }
            }
        } catch {
            state = .error(error)
        }
        #endif
    }
    
    // Start capturing audio
    func startCaptureAudio() {
        resetValues()
        state = .recordingSpeech
        do {
            // Configure audio recorder
            audioRecorder = try AVAudioRecorder(url: captureURL,
                                                settings: [
                                                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                                    AVSampleRateKey: 12000,
                                                    AVNumberOfChannelsKey: 1,
                                                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                                                ])
            audioRecorder.isMeteringEnabled = true
            audioRecorder.delegate = self
            audioRecorder.record()
            
            // Timer to update audio power for animation
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { [unowned self]_ in
                guard self.audioRecorder != nil else { return }
                self.audioRecorder.updateMeters()
                let power = min(1, max(0, 1 - abs(Double(self.audioRecorder.averagePower(forChannel: 0)) / 50) ))
                self.audioPower = power
            })
            
            // Timer to monitor recording duration and stop if silence is detected
            recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.6, repeats: true, block: { [unowned self]_ in
                guard self.audioRecorder != nil else { return }
                self.audioRecorder.updateMeters()
                let power = min(1, max(0, 1 - abs(Double(self.audioRecorder.averagePower(forChannel: 0)) / 50) ))
                if self.prevAudioPower == nil {
                    self.prevAudioPower = power
                    return
                }
                if let prevAudioPower = self.prevAudioPower, prevAudioPower < 0.25 && power < 0.175 {
                    self.finishCaptureAudio()
                    return
                }
                self.prevAudioPower = power
            })
            
        } catch {
            resetValues()
            state = .error(error)
        }
    }
    
    // Stop capturing audio
    func stopCaptureAudio() {
        // Stop the audio recorder
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
        }
        
        // Invalidate all timers
        animationTimer?.invalidate()
        recordingTimer?.invalidate()
        
        // Reset values and proceed to process the captured audio
        resetValues()
        do {
            let data = try Data(contentsOf: captureURL)
            processingSpeechTask = processSpeechTask(audioData: data)
        } catch {
            state = .error(error)
            resetValues()
        }
    }
    
    // Finish capturing audio and process the recorded data
    func finishCaptureAudio() {
        resetValues()
        do {
            let data = try Data(contentsOf: captureURL)
            processingSpeechTask = processSpeechTask(audioData: data)
        } catch {
            state = .error(error)
            resetValues()
        }
    }

    func processSpeechTask(audioData: Data) -> Task<Void, Never> {
            Task { @MainActor [unowned self] in
                do {
                    self.state = .processingSpeech
                    // Generate audio transcription
                    let prompt = try await client.generateAudioTransciptions(audioData: audioData)
                    
                    // Send transcription to ChatGPT and get response
                    try Task.checkCancellation()
                    let responseText = try await client.sendMessage(text:prompt)
                              
                    // Generate speech from the response text
                    try Task.checkCancellation()
                    let data = try await client.generateSpeechFrom(input: responseText, voice:
                            .alloy)
                    
                    // Play the generated speech
                    try Task.checkCancellation()
                    try self.playAudio(data: data)
                } catch {
                    if Task.isCancelled { return }
                    state = .error(error)
                    resetValues()
                }
            }
        }
    
    // Play audio data
    func playAudio(data: Data) throws {
        self.state = .playingSpeech
        audioPlayer = try AVAudioPlayer(data: data)
        audioPlayer.isMeteringEnabled = true
        audioPlayer.delegate = self
        audioPlayer.play()
        
        // Timer to update audio power for animation during playback
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { [unowned self]_ in
            guard self.audioPlayer != nil else { return }
            self.audioPlayer.updateMeters()
            let power = min(1, max(0, 1 - abs(Double(self.audioPlayer.averagePower(forChannel: 0)) / 160) ))
            self.audioPower = power
        })
    }
    
    // Cancel recording and reset state
    func cancelRecording() {
        resetValues()
        state = .idle
    }
    
    // Cancel the speech processing task
    func cancelProcessingTask() {
        processingSpeechTask?.cancel()
        processingSpeechTask = nil
        resetValues()
        state = .idle
    }
    
    // Delegate method called when audio recording finishes
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            resetValues()
            state = .idle
        }
    }
    
    // Delegate method called when audio playback finishes
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        resetValues()
        state = .idle
    }
    
    // Reset all relevant values and states
    func resetValues() {
        audioPower = 0
        prevAudioPower = nil
        audioRecorder?.stop()
        audioRecorder = nil
        audioPlayer?.stop()
        audioPlayer = nil
        recordingTimer?.invalidate()
        recordingTimer = nil
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

