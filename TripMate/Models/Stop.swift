//
//  Stop.swift
//  TripMate
//
import Foundation
import SwiftData


@Model
final class Stop {
    @Attribute(.unique) var id: UUID
    var tripID: UUID
    var title: String
    var note: String?
    var date: Date
    var time: Date?
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var urlString: String?
    var imageData: Data?
    var order: Int

    init(id: UUID = UUID(), tripID: UUID, title: String, date: Date, order: Int) {
        self.id = id; self.tripID = tripID; self.title = title; self.date = date; self.order = order
    }
}
