//
//  Model.swift
//  Matrix
//
//  Created by sungkug_apple_developer_ac on 9/5/24.
//

import Foundation
import SwiftUI
import RealityKit
import Combine

//Idemtificable 채택이유 foreach문에서 순회할 수 있게 하기 위함
class Model: Identifiable {
    
    var id = UUID()
    var modelName : String
    
    var modelEntity : ModelEntity?
    var cancellable : AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        cancellable = ModelEntity.loadModelAsync(named: modelName)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (error) in
                print("Error: fail load")
            }, receiveValue: { modelEntity in
                self.cancellable?.cancel()
                print("success to load")
                self.modelEntity = modelEntity
                self.modelEntity?.name = modelName
            })
    }
}

class ModelData {
    var models : [Model] = {
        let file = FileManager()
        guard let path = Bundle.main.resourcePath , let files = try? file.contentsOfDirectory(atPath: path) else { return [] }
        
        var modelData = [Model]()
        for item in files where item.hasSuffix("usdz") {
            let imageName = item.replacingOccurrences(of: ".usdz", with: "")
            print("img name: \(imageName)")
            let model = Model(modelName: imageName)
            modelData.append(model)
        }
        return modelData
    }()
    
    func getModel(named modelName: String) -> Model? {
        print("count Model: \(models.count)")
        return models.first(where: { $0.modelName == modelName })
    }
}
