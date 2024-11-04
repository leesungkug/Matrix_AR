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
    @State var isLoading = false
    @State private var currentImageIndex = 0 // 현재 보여줄 이미지의 인덱스
    let images = ["sunglass1", "sunglass2", "sunglass3"] // 이미지 에셋 이름 배열
    @State private var showText = false // 텍스트 표시 여부 상태 추가
    @State private var timer: Timer? // 타이머 상태 추가
    @State private var isInInfoView = false // InfoView에 있는지 추적

    var body: some View {
        NavigationView {
            ZStack {
                ARViewContainer(planeAreaText: $planeAreaText, isArea: $isArea, isLoading: $isLoading)
                    .ignoresSafeArea()
                
                if isLoading {
                    GIFImageView(name: "CodeGIF")
                        .ignoresSafeArea()
                }
                
                if !isArea {
                    if !showText {
                        NavigationLink(destination: InfoView(isInInfoView: $isInInfoView)) {
                            ZStack {
                                // 전체 사각형을 감쌈
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 271, height: 271)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.4), lineWidth: 2)
                                    )
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white.opacity(0.4))
                                            .blur(radius: 3)
                                    )

                                Image(systemName: "info.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                                    .offset(x: 105, y: -105)

                                VStack(spacing: 9) {
                                    Image(images[currentImageIndex])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 186, height: 81)
                                        .transition(.opacity)
                                        .onAppear {
                                            startImageTimer() // 타이머를 별도의 함수로 관리
                                        }

                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 24, height: 24)
                                        .padding(.top, 13)

                                    Text("Loading...")
                                        .font(.system(size: 18, weight: .regular))
                                        .foregroundColor(.white)
                                }
                                .padding(.top, 37)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onAppear {
                            startLoadingTimer()
                        }
                    } else {
                        Text("더 넓은 곳으로 이동해보세요")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                            .padding(.top, 20)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onChange(of: isLoading, {
            print("바뀜 \(isLoading)")
            if isLoading {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isLoading = false
                }
            }
        })
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startImageTimer() {
        // 타이머 중복 방지
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1.3, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                currentImageIndex = (currentImageIndex + 1) % images.count
            }
        }
    }

    private func startLoadingTimer() {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 16, repeats: false) { _ in
            withAnimation {
                showText = true
            }
        }
    }
}
