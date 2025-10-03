//
//  TripDocument.swift
//  TripMate
//
import Foundation
import SwiftData

@Model
final class TripDocument {
    @Attribute(.unique) var id: UUID
    var tripID: UUID
    var title: String
    var fileName: String
    var fileData: Data
    var thumbnailData: Data?

    init(id: UUID = UUID(), tripID: UUID, title: String, fileName: String, fileData: Data) {
        self.id = id; self.tripID = tripID; self.title = title; self.fileName = fileName; self.fileData = fileData
    }
}

