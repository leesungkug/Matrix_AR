//
//  InfoView.swift
//  Matrix
//
//  Created by h on 10/1/24.
//
import SwiftUI
import RealityKit

struct InfoView: View {
    @Binding var isInInfoView: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                // ZStack을 사용하여 배경 이미지와 텍스트를 겹치게 배치
                ZStack {
                    Image("matrixpattern")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 164)
                        .clipped()
                    
                    Text("NEO-INSPIRED MODERN LEGENDARY SUNGLASSES")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                
                Image("sunglass1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top, 10)
                
                Text("A modern, legendary pair of sunglasses with a sleek, futuristic design, inspired by Neo from The Matrix. The sunglasses are minimalistic, with a shiny black finish, thin frames, and sharp, angular lenses.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                
                Image("sunglassman")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 286)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top, 10)
                
                Text("The overall look is edgy, dark, and iconic, evoking a sense of mystery and danger. Set against a clean, urban backdrop with a hint of neon lighting, reflecting a cyberpunk aesthetic.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("Product Details")
    }
}
