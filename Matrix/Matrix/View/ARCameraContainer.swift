//
//  ARCameraContainer.swift
//  Matrix
//
//  Created by sungkug_apple_developer_ac on 9/25/24.
//
import SwiftUI
import ARKit
import SceneKit

// ARKit을 SwiftUI에 통합하는 래퍼
//struct ARViewContainer: UIViewControllerRepresentable {
//    
//    func makeUIViewController(context: Context) -> ARCarmeraViewController {
//        return ARCarmeraViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: ARCarmeraViewController, context: Context) {
//        // 업데이트 시 동작을 정의할 수 있음
//    }
//}

class ARCarmeraViewController: UIViewController, ARSCNViewDelegate {
    
    var sceneView = ARSCNView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        sceneView.frame = self.view.bounds
        self.view.addSubview(sceneView)
        
        // 얼굴 트래킹이 지원되는지 확인
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("이 기기에서는 얼굴 트래킹을 지원하지 않습니다.")
        }
        
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func simd_midpoint(_ a: simd_float4, _ b: simd_float4) -> simd_float4 {
        return (a + b) / 2
    }
    
    // 얼굴 노드를 생성하는 델리게이트 메서드
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        guard let faceAnchor = anchor as? ARFaceAnchor else { return nil }
        guard let device = sceneView.device,
              let faceAnchor = anchor as? ARFaceAnchor else {
            return nil
        }
//        let faceNode = SCNNode()
        
        // 얼굴을 시각화하기 위한 SCNGeometry 생성
        let faceGeometry = ARSCNFaceGeometry(device: device)!
        
        // faceNode에 faceGeometry를 할당하여 얼굴을 시각화
        let faceNode = SCNNode(geometry: faceGeometry)
        faceNode.geometry?.firstMaterial?.fillMode = .lines
        
        // 안경 오브젝트 추가
        let glassesNode = createGlassesNode()
        print("안경의 위치: \(glassesNode.position)")
//
//        // 눈의 위치 가져오기
        let leftEyeTransform = faceAnchor.leftEyeTransform
        let rightEyeTransform = faceAnchor.rightEyeTransform
//        // 눈의 중간 위치로 안경을 이동 (leftEyeTransform과 rightEyeTransform을 평균하여 사용)
//        let eyeCenter = simd_midpoint(leftEyeTransform.columns.3, rightEyeTransform.columns.3)
//        glassesNode.position = SCNVector3(eyeCenter.x, eyeCenter.y, eyeCenter.z)
        glassesNode.position = SCNVector3(0, 0, -25)
        print("안경의 변경 위치: \(glassesNode.position)")
////        glassesNode.scale = SCNVector3(0.001, 0.001, 0.001)
//        faceNode.position = SCNVector3(eyeCenter.x, eyeCenter.y, eyeCenter.z)
        faceNode.addChildNode(glassesNode)
        return faceNode
    }
    
    // 안경 오브젝트 생성
    func createGlassesNode() -> SCNNode {
        // 여기에 실제 안경 3D 모델을 넣을 수 있습니다.
        guard let glassesScene = SCNScene(named: "glass3.usdc") else {
            fatalError("안경 모델을 찾을 수 없습니다.")
        }
        
        
        // 씬에서 노드를 가져옴 (루트 노드에서 검색)
        let glassesNode = glassesScene.rootNode
        glassesNode.name = "glasses"
//        guard let glassesNode = glassesScene.rootNode.childNode(withName: "Plane_005_body_texture_0", recursively: true) else {
//            fatalError("안경 노드를 찾을 수 없습니다.")
//        }

        // 위치 및 크기 조정
//        glassesNode.scale = SCNVector3(0.001, 0.001, 0.001) // 크기를 조정 (필요에 맞게 변경)
//        glassesNode.position = SCNVector3(0, 0.05, 0.1) // 얼굴에 맞게 위치 조정 (눈 부분)
//        let glassesNode = SCNNode()
//        let glassesGeometry = SCNBox(width: 0.1, height: 0.05, length: 0.02, chamferRadius: 0.01)
//        glassesNode.geometry = glassesGeometry
//        glassesNode.position = SCNVector3(0, 0.05, 0.1)
        
        return glassesNode
    }
    
    // 얼굴 정보가 업데이트될 때 호출
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
//        node.simdTransform = faceAnchor.transform
        print("node위치 : \(node.position)")
//        let faceGeometry = node.childNodes.first
//        faceGeometry?.simdTransform = faceAnchor.transform
        if let glassNode = node.childNode(withName: "glasses", recursively: true) {
            // "glass" 노드의 위치 출력
            print("glass 노드 위치: \(glassNode.position)")
        } else {
            print("glass 노드를 찾을 수 없습니다.")
        }
    }
}
