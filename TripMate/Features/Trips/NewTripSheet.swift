//
//  NewTripSheet.swift
//  TripMate
//
//

import SwiftUI
import SwiftData

@inline(__always) private func tr(_ key: String) -> String { NSLocalizedString(key, comment: "") }

struct NewTripSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var ctx

    @State private var title: String = ""
    @State private var start: Date = Date()
    @State private var end: Date = Calendar.current.date(byAdding: .day, value: 3, to: Date())!

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    VStack(spacing: 16) {
                        TWCard {
                            TWHeader(tr("new_trip"))
                            TextField(tr("trip_name_placeholder"), text: $title)
                                .textFieldStyle(.roundedBorder)
                        }

                        TWCard {
                            TWHeader(tr("when"))
                            DatePicker(tr("start"), selection: $start, displayedComponents: .date)
                            DatePicker(tr("end"),
                                       selection: $end,
                                       in: start...,
                                       displayedComponents: .date)
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(tr("cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(tr("create")) { createTrip() }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func createTrip() {
        let t = Trip(
            title: title.isEmpty ? tr("untitled") : title,
            startDate: start,
            endDate: end
        )
        ctx.insert(t)
        dismiss()
    }
}

