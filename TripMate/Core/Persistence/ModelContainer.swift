//
//  ModelContainer.swift
//  TripMate
//
//

import SwiftData

enum ModelContainerBuilder {
    static let models: [any PersistentModel.Type] = [
        Trip.self, Stop.self, ChecklistItem.self, TripDocument.self
    ]
}
