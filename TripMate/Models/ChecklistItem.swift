//
//  ChecklistItem.swift
//  TripMate
//
import Foundation
import SwiftData

@Model
final class ChecklistItem {
    @Attribute(.unique) var id: UUID
    var tripID: UUID
    var title: String
    var isDone: Bool

    init(id: UUID = UUID(), tripID: UUID, title: String, isDone: Bool = false) {
        self.id = id; self.tripID = tripID; self.title = title; self.isDone = isDone
    }
}

