//
//  Trip.swift
//  TripMate
//
import Foundation
import SwiftData


@Model
final class Trip {
    @Attribute(.unique) var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var coverImageData: Data?
    @Relationship(deleteRule: .cascade) var stops: [Stop]
    @Relationship(deleteRule: .cascade) var checklist: [ChecklistItem]
    @Relationship(deleteRule: .cascade) var documents: [TripDocument]

    init(id: UUID = UUID(), title: String, startDate: Date, endDate: Date) {
        self.id = id; self.title = title; self.startDate = startDate; self.endDate = endDate
        self.stops = []; self.checklist = []; self.documents = []
    }
}
