//
//  ImmersiveView.swift
//  realityKitTest
//
//  Created by Sparsh Kapoor on 6/4/24.
//

import SwiftUI
import RealityKit
import RealityKitContent


struct ImmersiveView: View {
    var body: some View {
        ZStack {
            RealityView { content in
                // Add the initial RealityKit content
                if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                    content.add(immersiveContentEntity)
                    
                    guard let entity = try? await Entity(named: "AudioController", in: realityKitContentBundle) else { fatalError("Unable to load immersive model") }
                    let ambientAudioEntityController = entity.findEntity(named: "AmbientAudio")
                    
                    let audioFileName = "/Root/WiiSound"
                    
                    guard let resource = try? await AudioFileResource(named: audioFileName, from: "AudioController.usda", in: realityKitContentBundle) else {
                        fatalError("Unable to load audio resource")
                    }
                    
                    let audioController = ambientAudioEntityController?.prepareAudio(resource)
                    audioController?.play()
                    
                    content.add(entity)
                    
                }
                let skybox = createSkybox()
                content.add(skybox!)
            }
        }
        
    }
    
    private func createSkybox() -> Entity? {
        let largeSphere = MeshResource.generateSphere(radius: 2)
        var skyboxMaterial = UnlitMaterial()
        
        do {
            let texture = try TextureResource.load(named: "test")
            skyboxMaterial.color = .init(texture: .init(texture))
        } catch {
            print("Failed to create skybox material: \(error)")
            return nil
        }
        
        let skyboxEntity = Entity()
        skyboxEntity.components.set(ModelComponent(mesh: largeSphere, materials: [skyboxMaterial]))
        
        skyboxEntity.scale = .init(x: -1, y: 1, z: 1)
        return skyboxEntity
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
