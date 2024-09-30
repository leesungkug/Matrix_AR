//
//  ARView.swift
//  Matrix
//
//  Created by sungkug_apple_developer_ac on 9/10/24.
//

import Foundation
import RealityKit
import ARKit

extension ARView : ARCoachingOverlayViewDelegate {
    
    func addCoaching(){
        let coachingOverLay = ARCoachingOverlayView()
        coachingOverLay.delegate = self
        coachingOverLay.session = self.session
        coachingOverLay.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        coachingOverLay.goal = .anyPlane
        self.addSubview(coachingOverLay)
    }
    
    func setupTouch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        self.addGestureRecognizer(tap)
        let longTouch = UILongPressGestureRecognizer(target: self, action: #selector(self.longTouchAction(_:)))
        self.addGestureRecognizer(longTouch)
    }
    
    @objc
    func longTouchAction(_ sender :UILongPressGestureRecognizer? = nil){
        guard let touchInView = sender?.location(in: self) , let rayResult = self.ray(through: touchInView) else { return }
        let results = self.scene.raycast(origin: rayResult.origin, direction: rayResult.direction)
        if let firstResult = results.first {
            let model = firstResult.entity
            
            model.removeFromParent()
            
        }
    }
    
    @objc
    func tapAction(_ sender : UITapGestureRecognizer? = nil){
        guard let touchInView = sender?.location(in: self) , let rayResult = self.ray(through: touchInView) else { return }
        let results = self.scene.raycast(origin: rayResult.origin, direction: rayResult.direction)
        if let firstResult = results.first {
            let model = firstResult.entity
            
            var trans = Transform()
            
            trans.rotation = simd_quatf(angle: Float.pi, axis: SIMD3(x: 0, y: 1, z: 0))
            model.move(to: trans, relativeTo: model, duration: 2)
            
        }
    }
}
