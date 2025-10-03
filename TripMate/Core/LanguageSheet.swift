//
//  LanguageSheet.swift
//  TripMate
//

//


import SwiftUI

struct LanguageSheet: View {
    @Binding var lang: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Choose Language / Dil Seç") {
                    Button(action: { set("en") }) { HStack { Text("English"); if lang == "en" { Spacer(); Image(systemName: "checkmark") } } }
                    Button(action: { set("tr") }) { HStack { Text("Türkçe"); if lang == "tr" { Spacer(); Image(systemName: "checkmark") } } }
                }
            }
            .navigationTitle("Language")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } }
            }
        }
    }

    private func set(_ code: String) {
        lang = code
        Bundle.setLanguage(code)   // Bundle+Language.swift
        dismiss()
    }
}
