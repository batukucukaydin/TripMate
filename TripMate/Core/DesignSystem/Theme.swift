//
//  Theme.swift
//  TripMate
//
import SwiftUI



struct GradientBackground: View {
    var body: some View {
        LinearGradient(colors: [.twBgTop, .twBgBottom],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}

struct FloatingAddButton: View {
    let titleText: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Kartlardaki sol ikon “kutu” görünümü
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.95))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color.black.opacity(0.85))
                    )

                Text(titleText)
                    .font(.system(size: 17, weight: .semibold))  // Trip kartlarıyla aynı ağırlık
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                // Yarı saydam cam görünüm + ince kenarlık (kartlarla uyum)
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.12), radius: 16, y: 8)
        }
        .buttonStyle(PressedShrinkStyle())
        .contentShape(Rectangle())
    }
}

// Basınca minik küçülme animasyonu
struct PressedShrinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
    }
}
