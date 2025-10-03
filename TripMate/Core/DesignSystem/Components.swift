//
//  Components.swift
//  TripMate
//


import SwiftUI

// Kart arkaplanı – ekranlardaki yarı saydam beyaz panellerle aynı
public struct TWCard<Content: View>: View {
    private let content: Content
    public init(@ViewBuilder content: () -> Content) { self.content = content() }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.55))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.28), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.07), radius: 10, y: 6)
        )
    }
}

// Bölüm başlığı – küçük, sekonder renkli
public struct TWHeader: View {
    private let text: String
    public init(_ text: String) { self.text = text }

    public var body: some View {
        Text(text.uppercased())
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .padding(.bottom, 2)
    }
}
