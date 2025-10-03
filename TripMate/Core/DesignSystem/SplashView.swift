//
//  SplashView.swift
//  TripMate
//
//

//
//  SplashView.swift
//  TripMate
//


import SwiftUI

struct SplashView: View {
    var onFinish: () -> Void

    // Animasyon durumları
    @State private var planeOffset: CGSize = CGSize(width: -160, height: 0) // soldan başlar
    @State private var planeRotation: Double = -10
    @State private var titleOpacity: Double = 0
    @State private var titleScale: CGFloat = 0.9
    @State private var fadeOut: Bool = false

    private let planeDuration: Double = 1.0
    private let titleDelay: Double = 0.6
    private let holdDuration: Double = 0.8
    private let exitDuration: Double = 0.4

    var body: some View {
        ZStack {
            GradientBackground()
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ZStack {
                    // Uçak animasyonu
                    Image(systemName: "airplane.departure")
                        .font(.system(size: 50, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(colors: [
                                .black.opacity(0.95),
                                .gray.opacity(0.6)
                            ], startPoint: .leading, endPoint: .trailing)
                        )
                        .offset(planeOffset)
                        .rotationEffect(.degrees(planeRotation))
                        .shadow(color: .black.opacity(0.3), radius: 6, y: 3)
                }
                .frame(height: 60)

                // TripMate yazısı
                Text("TripMate")
                    .font(.system(size: 42, weight: .semibold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [
                            .black.opacity(0.95),
                            .gray.opacity(0.7)
                        ], startPoint: .leading, endPoint: .trailing)
                    )
                    .opacity(titleOpacity)
                    .scaleEffect(titleScale)
            }
            .opacity(fadeOut ? 0 : 1)
        }
        .onAppear {
            // Uçak hareketi (soldan merkeze)
            withAnimation(.easeOut(duration: planeDuration)) {
                planeOffset = CGSize(width: 0, height: 0)
                planeRotation = 0
            }

            // Yazı fade-in
            withAnimation(.easeOut(duration: 0.6).delay(titleDelay)) {
                titleOpacity = 1
                titleScale = 1.0
            }

            // Kısa bekleme ardından fade-out
            DispatchQueue.main.asyncAfter(deadline: .now() + planeDuration + holdDuration) {
                withAnimation(.easeInOut(duration: exitDuration)) {
                    fadeOut = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + exitDuration) {
                    onFinish()
                }
            }
        }
    }
}
