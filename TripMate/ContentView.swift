//
//  ContentView.swift
//  TripMate
//
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            TripsListView()
                .toolbarBackground(.hidden, for: .navigationBar)

            if showSplash {
                SplashView {
                    showSplash = false
                }
                .transition(.opacity)
            }
        }
    }
}
