//
//  PackingListView.swift
//  TripMate
//

//


import SwiftUI

struct PackingListView: View {
    @Environment(\.modelContext) private var ctx
    @Bindable var trip: Trip
    @State private var newItem = ""

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TextField(LocalizedStringKey("add_item"), text: $newItem)
                    .textFieldStyle(.roundedBorder)
                Button {
                    trip.checklist.append(.init(tripID: trip.id, title: newItem))
                    newItem = ""
                } label: { Image(systemName: "plus.circle.fill") }
                .disabled(newItem.trimmingCharacters(in: .whitespaces).isEmpty)
            }.padding(.horizontal)

            List {
                ForEach(trip.checklist) { item in
                    HStack {
                        Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                            .onTapGesture { item.isDone.toggle() }
                        Text(item.title).strikethrough(item.isDone)
                    }
                    .listRowBackground(Color.twCard)
                }
                .onDelete { idx in
                    idx.map { trip.checklist[$0] }.forEach { ctx.delete($0) }
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}
