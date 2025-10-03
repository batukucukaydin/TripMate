//
//  TripMateApp.swift
//  TripMate
//
//

import SwiftUI
import SwiftData

@main
struct TripMateApp: App {

    init() {
        let nav = UINavigationBarAppearance()
        nav.configureWithTransparentBackground()
        nav.backgroundColor = .clear
        nav.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance   = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
        UINavigationBar.appearance().compactAppearance    = nav
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(.black)
        }
        .modelContainer(for: [Trip.self, Stop.self, ChecklistItem.self, TripDocument.self])
    }
}
