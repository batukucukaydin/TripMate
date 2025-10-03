//
//  Brand.swift
//  TripMate
//
import SwiftUI


struct TripMateHeader: View {
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.25))
                Image(systemName: "airplane.departure")
                    .font(.system(size: 20, weight: .bold))
            }
            .frame(width: 36, height: 36)

            Text("TripMate")
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)
                )
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 4)
    }
}
