//
//  ContentView.swift
//  Matrix
//
//  Created by sungkug_apple_developer_ac on 8/15/24.
//
import SwiftUI

struct ContentView: View {
    @State private var planeAreaText: String = "Detecting plane area..."
    @State var isArea = false

    var body: some View {
        ZStack {
            ARViewContainer(planeAreaText: $planeAreaText, isArea: $isArea)
//            ARViewContainer()
                .ignoresSafeArea()

            if !isArea {
                Text("더 넓은 곳으로 이동하세요")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.green)
                    .background(.black)
            }
        }
        .ignoresSafeArea()
        
    }
}

