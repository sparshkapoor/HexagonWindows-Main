//
//  StreetVisionApp.swift
//  StreetVision
//
//  Created by Kuixi Song on 4/27/24.
//

import SwiftUI


struct StreetVisionApp: View {

    @State private var showImmersiveSpace = false
    @State private var tilesLoadingStatus: TilesLoadingStatus = .none
    @State private var currentZoomLevel: ZoomLevel = .two
    @State private var cacheSizeString: String = FileUtils.cacheSizeString()
    @ObservedObject private var textureResourceStore = TextureResourceStore.shared
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
            NavigationSplitView {
                SearchView(currentZoomLevel: $currentZoomLevel, tilesLoadingStatus: $tilesLoadingStatus)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Menu {
                                Section {
                                    ForEach(ZoomLevel.allCases) { zoomLevel in
                                        Button {
                                            currentZoomLevel = zoomLevel
                                        } label: {
                                            HStack {
                                                Text(zoomLevel.displayName)
                                                Spacer()
                                                if zoomLevel == currentZoomLevel {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } header: {
                                    Text("Zoom Level")
                                }
                                Section {
                                    Button {
                                        Task {
                                            FileUtils.clearCache()
                                        }
                                    } label: {
                                        Text("Clear cache (\(cacheSizeString))")
                                    }
                                } header: {
                                    Text("Others")
                                }
                            } label: {
                                Image(systemName: "gear")
                            }
                            .onTapGesture {
                                cacheSizeString = FileUtils.cacheSizeString()
                            }
                        }
                    }
            } detail: {
                MapView(showingImmersiveSpace: $showImmersiveSpace, tilesLoadingStatus: $tilesLoadingStatus)
            }
            .onAppear {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                    return
                }
                let geometryRequest = UIWindowScene.GeometryPreferences.Vision(resizingRestrictions: .uniform)
                windowScene.requestGeometryUpdate(geometryRequest)
            }
            .onChange(of: textureResourceStore.textureResource, initial: true) { oldValue, newValue in
                showImmersiveSpace = newValue != nil
            }
            .onChange(of: showImmersiveSpace, initial: true) { oldValue, newValue in
                Task {
                    if newValue {
                        if !oldValue {
                            await openImmersiveSpace(id: "StreetView")
                        }
                    } else {
                        if oldValue {
                            await dismissImmersiveSpace()
                        }
                    }
                }
            }
            .onDisappear {
                showImmersiveSpace = false
            }
        
        
    }

}
