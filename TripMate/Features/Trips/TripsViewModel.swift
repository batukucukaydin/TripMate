//
//  TripsViewModel.swift
//  TripMate
//
//
import Foundation
import SwiftUI       
import SwiftData

@MainActor
final class TripsViewModel: ObservableObject {
    func seedIfNeeded(_ trips: [Trip], ctx: ModelContext) {
        guard trips.isEmpty else { return }
        let start = Calendar.current.date(byAdding: .day, value: 10, to: Date())!
        let end = Calendar.current.date(byAdding: .day, value: 14, to: Date())!
        let demo = Trip(title: NSLocalizedString("rome_title", comment: "Rome"), startDate: start, endDate: end)
        ctx.insert(demo)
        let s1 = Stop(tripID: demo.id, title: "Colosseum", date: start, order: 1)
        s1.time = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: start)
        s1.address = "Piazza del Colosseo, 1, Rome"
        demo.stops.append(s1)
        demo.checklist.append(ChecklistItem(tripID: demo.id, title: NSLocalizedString("checklist_esim", comment: "")))
    }
}
