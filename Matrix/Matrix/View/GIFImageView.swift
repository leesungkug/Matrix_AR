//
//  GIFImageView.swift
//  Matrix
//
//  Created by sungkug_apple_developer_ac on 11/4/24.
//

import SwiftUI

struct GIFImageView: UIViewRepresentable {
    let name: String
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.loadGIF(name: name)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        // 필요에 따라 업데이트 로직 추가
    }
}
