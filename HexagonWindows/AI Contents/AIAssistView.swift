//
//  AIAssistView.swift
//  HexagonWindows
//
//  Created by workmerkdev on 5/31/24.
//

import SwiftUI
import SiriWaveView

struct AIAssistView: View {
    @State var vm = ViewModels()
    @State var isSymbolAnimating = false

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            SiriWaveView()
                .power(power: vm.audioPower)
                .opacity(vm.siriWaveFormOpacity)
                .frame(height: 256)
                .overlay { overlayView }
            Spacer()
            
            switch vm.state {
            case .recordingSpeech:
                HStack{
                    cancelRecordingButton; stopCaptureButton
                }

            case .processingSpeech, .playingSpeech:
                cancelButton
                
            default: EmptyView()
            }
            
            if case let .error(error) = vm.state {
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .lineLimit(2)
            }
        }
        .padding()
    }

    @ViewBuilder
    var overlayView: some View {
        switch vm.state {
        case .idle, .error:
            startCaptureButton
        case .processingSpeech:
            Image(systemName: "brain")
                .symbolEffect(.bounce.up.byLayer, options: .repeating, value: isSymbolAnimating)
                .font(.system(size: 128))
                .onAppear { isSymbolAnimating = true }
                .onDisappear { isSymbolAnimating = false }
        default: EmptyView()
        }
    }

    var startCaptureButton: some View {
        Button {
            vm.startCaptureAudio()
        } label: {
            Image(systemName: "mic.circle")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 128))
        }.buttonStyle(.borderless)
    }

    var stopCaptureButton: some View {
        Button {
            vm.stopCaptureAudio()
        } label: {
            Image("Microphone_crossed")
                .resizable()
                .frame(width: 52, height: 52)
                .opacity(1)
                .symbolRenderingMode(.multicolor)
                .font(.system(size:128))
        } .buttonStyle(.borderless)
            .padding()
    }

    var cancelRecordingButton: some View {
        Button(role: .destructive) {
            vm.cancelRecording()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 44))
        }.buttonStyle(.borderless)
    }

    var cancelButton: some View {
        Button(role: .destructive) {
            vm.cancelProcessingTask()
        } label: {
            Image(systemName: "stop.circle.fill")
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(.red)
                .font(.system(size: 44))
        }.buttonStyle(.borderless)
    }
}


