//
//  ARViewContainer.swift
//  Matrix
//
//  Created by sungkug_apple_developer_ac on 9/3/24.
//

import ARKit
import Combine
import RealityKit
import SwiftUI

struct ARViewContainer: UIViewControllerRepresentable {
    @Binding var planeAreaText: String
    @Binding var isArea: Bool
    
    func makeUIViewController(context: Context) -> ARViewController {
        let controller = ARViewController()
        controller.planeAreaText = $planeAreaText
        controller.isArea = $isArea
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {}
}

class ARViewController: UIViewController, ARSessionDelegate {
//    var modelData = ModelData()
    var arView: ARView!
    var modelPlaced = false
    var planeAreaText: Binding<String>?
    var isArea: Binding<Bool>?
    var removeMapEntity: ModelEntity?
    var anchorEntity : AnchorEntity?
    var cancellables = Set<AnyCancellable>()
    let minArea: Float = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setupARView()
            self.arView.addCoaching()
            self.setupARSession()
            self.setupHandleTap()
        }
    }
    
    private func setupARView() {
        arView = ARView(frame: .zero)
        self.view.addSubview(arView)
        arView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: self.view.topAnchor),
            arView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            arView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        arView.session.delegate = self
    }
    
    private func setupARSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
    }
    
    private func setupHandleTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("AR session failed with error: \(error.localizedDescription)")
    }

    func sessionWasInterrupted(_ session: ARSession) {
        print("AR session was interrupted")
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        print("AR session interruption ended")
    }

    // 평면 감지 시 호출되는 함수
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard !modelPlaced else { return }
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // 평면의 넓이를 계산
                let area = calculatePlaneArea(geometry: planeAnchor.geometry)
                
                // 평면 넓이를 문자열로 변환하여 UI에 표시
                let areaText = String(format: "면적: %.2f 제곱미터", area)
                DispatchQueue.main.async {
                    self.planeAreaText?.wrappedValue = areaText
                }
                
                if area >= minArea {
                    DispatchQueue.main.async {
                        self.isArea?.wrappedValue = true
                    }
                    placeModel(on: planeAnchor)
                    modelPlaced = true
                    break
                }
            }
        }
    }
    
    // 평면 넓이 계산
    func calculatePlaneArea(geometry: ARPlaneGeometry) -> Float {
        var area: Float = 0.0
        
        let vertices = geometry.vertices
        let triangleIndices = geometry.triangleIndices
        
        // 삼각형 단위로 면적을 계산
        for i in stride(from: 0, to: triangleIndices.count, by: 3) {
            let vertexA = vertices[Int(triangleIndices[i])]
            let vertexB = vertices[Int(triangleIndices[i+1])]
            let vertexC = vertices[Int(triangleIndices[i+2])]
            
            // 벡터를 이용해 삼각형의 면적 계산
            let edgeAB = vertexB - vertexA
            let edgeAC = vertexC - vertexA
            let crossProduct = simd_cross(edgeAB, edgeAC)
            let triangleArea = length(crossProduct) / 2.0
            
            area += triangleArea
        }
        
        return area
    }
    
    // 3D 모델 배치 함수
    func placeModel(on planeAnchor: ARPlaneAnchor) {
        // USDC 파일을 로드하여 removeMap 모델 추가
        if let removeMapEntity = try? ModelEntity.loadModel(named: "keyboardnone") {
//        if let mapModel = modelData.getModel(named: "MainRoom"), let removeMapEntity = mapModel.modelEntity {
            self.removeMapEntity = removeMapEntity  // 모델을 저장
            
            // AnchorEntity 생성
            anchorEntity = AnchorEntity(anchor: planeAnchor)
            
            // removeMap 모델을 AnchorEntity에 추가
            anchorEntity!.addChild(removeMapEntity)
            
            // removeMap 모델 위치를 평면의 중심으로 설정
            print("원래 \(removeMapEntity.position), 바닥\(planeAnchor.center)")
            removeMapEntity.position.y = planeAnchor.center.y
            // CollisionComponent 추가
            
            // keyboard 모델 추가
            if let keyboardEntity = try? ModelEntity.loadModel(named: "keyboard") {
//            if let triggerModel = modelData.getModel(named: "keyboard"), let keyboardEntity = triggerModel.modelEntity {
                keyboardEntity.position.y = planeAnchor.center.y
                keyboardEntity.name = "trigger"
                // CollisionComponent 추가
                keyboardEntity.generateCollisionShapes(recursive: true)
                
                anchorEntity!.addChild(keyboardEntity)
            }
            
//            if let glassEntity = try? ModelEntity.loadModel(named: "Glass") {
//                glassEntity.position.y = planeAnchor.center.y
//                glassEntity.name = "glass"
//                glassEntity.generateCollisionShapes(recursive: true)
//                
//                anchorEntity.addChild(glassEntity)
//            } else {
//                print("failed")
//            }
            
            // ARView에 AnchorEntity 추가
            arView.scene.addAnchor(anchorEntity!)
        } else {
            print("Error: load Failed")
        }
    }
    
    // 탭 제스처 핸들러
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: arView)

        // 터치된 위치에서 엔티티 검색
        if let tappedEntity = arView.entity(at: location) {
            if tappedEntity.name == "trigger" {
                // keyboardEntity가 직접 터치된 경우
                print("Keyboard entity tapped")
                replaceModel()
            } else if tappedEntity.name == "glass"{
                
            } else {
                print("Tapped entity is not 'keyboard'")
            }
        } else {
            print("No entity found at tapped location")
        }
    }
    
    // 모델 교체 함수
    func replaceModel() {
        guard let removeMapEntity = removeMapEntity else { return }
        // 새 모델 로드
        if let newModelEntity = try? ModelEntity.loadModel(named: "whiteroom") {
//        if let newModelEntity = try? Entity.loadModel(named: "upgradeAnimation") {
            // 기존 removeMap 모델을 교체
            removeMapEntity.model = newModelEntity.model
            if let entityToRemove = anchorEntity!.findEntity(named: "trigger") {
                entityToRemove.removeFromParent()
            }
        }
    }
}
