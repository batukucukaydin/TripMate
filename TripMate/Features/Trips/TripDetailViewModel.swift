//
//  TripDetailViewModel.swift
//  TripMate
//

import SwiftUI
import SwiftData

@MainActor
final class TripDetailViewModel: ObservableObject {}

struct TripDetailView: View {
    @Environment(\.modelContext) private var ctx
    @StateObject private var vm = TripDetailViewModel()
    @Bindable var trip: Trip
    @State private var tab: Tab = .itinerary

    enum Tab: String, CaseIterable { case itinerary, map, packing, documents }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GradientBackground()

            VStack(spacing: 12) {
                Picker("", selection: $tab) {
                    Text(LocalizedStringKey("itinerary")).tag(Tab.itinerary)
                    Text(LocalizedStringKey("map")).tag(Tab.map)
                    Text(LocalizedStringKey("packing")).tag(Tab.packing)
                    Text(LocalizedStringKey("documents")).tag(Tab.documents)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                switch tab {
                case .itinerary: ItineraryList(trip: trip)
                case .map:       TripMapView(trip: trip)
                case .packing:   PackingListView(trip: trip)
                case .documents: DocumentsView(trip: trip)
                }
            }
        }
        .navigationTitle(trip.title)
        .navigationBarTitleDisplayMode(.inline)
    
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

// MARK: - Itinerary
struct ItineraryList: View {
    @Environment(\.modelContext) private var ctx
    @Bindable var trip: Trip
    @State private var showAdd = false

    var grouped: [(day: Date, items: [Stop])] {
        let cal = Calendar.current
        let dict = Dictionary(grouping: trip.stops) { cal.startOfDay(for: $0.date) }
        return dict.keys.sorted().map { day in
            let items = (dict[day] ?? []).sorted { a, b in
                switch (a.time, b.time) {
                case let (ta?, tb?): return ta < tb
                case (_?, nil):      return true
                case (nil, _?):      return false
                default:             return a.order < b.order
                }
            }
            return (day, items)
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                ForEach(grouped, id: \.day) { group in
                    Section {
                        ForEach(group.items, id: \.id) { stop in
                            ItineraryStopRow(stop: stop)
                                .listRowBackground(Color.twCard)
                                .swipeActions {
                                    Button(role: .destructive) { ctx.delete(stop) } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    } header: { Text(group.day, style: .date) }
                }
            }
            .scrollContentBackground(.hidden)

            FloatingAddButton(
                titleText: NSLocalizedString("add_stop", comment: "Add Stop"),
                icon: "plus"
            ) { showAdd = true }
            .padding(16)
        }
        .sheet(isPresented: $showAdd) { AddStopSheet(trip: trip) }
    }
}

private struct ItineraryStopRow: View {
    @Bindable var stop: Stop

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle().fill(.thinMaterial).frame(width: 38, height: 38)
                Image(systemName: "mappin")
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(stop.title).font(.headline)
                    if let t = stop.time {
                        Text(t.formatted(date: .omitted, time: .shortened))
                            .font(.subheadline).foregroundStyle(.secondary)
                    }
                }
                if let addr = stop.address, !addr.isEmpty {
                    Text(addr).font(.footnote).foregroundStyle(.secondary)
                }
                if let urlStr = stop.urlString, let url = URL(string: urlStr) {
                    Link(LocalizedStringKey("open_link"), destination: url).font(.footnote)
                }
                if let data = stop.imageData, let ui = UIImage(data: data) {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.twCard))
    }
}
