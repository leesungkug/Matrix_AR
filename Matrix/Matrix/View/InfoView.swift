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
    @State private var selectedColor = "BLACK"
    @State private var selectedSize = "ONE SIZE"
    @State private var quantity = 1

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("NEO-INSPIRED MODERN LEGENDARY SUNGLASSES")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2) // Set line limit to 2
                        .frame(maxWidth: .infinity, alignment: .leading) // Ensure it takes available width
                    
                    Spacer()
                    
                    Text("€1,630.00")
                        .font(.headline)
                }
                .padding(.top, 20) // Top padding for title

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

                Text("The overall look is edgy, dark, and iconic, evoking a sense of mystery and danger. Set against a clean, urban backdrop with a hint of neon lighting, reflecting a cyberpunk aesthetic.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
            .padding(.horizontal)

            Spacer()

            // 제품 선택 옵션
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Color")
                    Spacer()
                    Text(selectedColor)
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(Color(hex: "ACFF2C"))

                HStack {
                    Text("Size")
                    Spacer()
                    Text(selectedSize)
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(Color(hex: "ACFF2C"))

                HStack {
                    Text("Quantity")
                    Spacer()
                    HStack {
                        ForEach(1..<6) { i in
                            Button(action: {
                                quantity = i
                            }) {
                                Text("\(i)")
                                    .font(.headline)
                                    .frame(width: 30, height: 30)
                                    .background(quantity == i ? Color.black : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(Color(hex: "ACFF2C"))

                HStack {
                    Text("Size Guide")
                        .foregroundColor(.blue)
                        .underline()
                    Spacer()
                    Text("Add to wishlist")
                        .font(.headline)
                        .underline()
                        .foregroundColor(.gray)
                    Image(systemName: "heart.fill")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
            }
            .padding(.top, 15)

            Spacer()

            // 장바구니 담기 버튼
            Button(action: {
                // 장바구니에 담기 액션
            }) {
                Text("Add to Bag")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("Product Details")
    }
}

// HEX 색상 변환 익스텐션
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 * 4), (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8 & 0xFF), int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
