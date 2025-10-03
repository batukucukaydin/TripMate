//
//  AddStopSheet.swift
//  TripMate
//

import SwiftUI
import SwiftData
import MapKit
import PhotosUI

@inline(__always) private func tr(_ key: String) -> String { NSLocalizedString(key, comment: "") }

struct AddStopSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var ctx
    @Bindable var trip: Trip

    // Form alanları
    @State private var query = ""
    @State private var title = ""
    @State private var link = ""
    @State private var date = Date()
    @State private var setTime = true
    @State private var time = Date()
    @State private var address: String?
    @State private var coord: CLLocationCoordinate2D?

    // Arama
    @State private var completer = MKLocalSearchCompleter()
    @State private var completerDelegate: CompleterProxy?   // << delegate’ı tut
    @State private var suggestions: [MKLocalSearchCompletion] = []
    @State private var searching = false

    // Foto
    @State private var photoItem: PhotosPickerItem?
    @State private var imageData: Data?

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    VStack(spacing: 16) {

                        // PLACE SEARCH
                        TWCard {
                            VStack(alignment: .leading, spacing: 12) {
                                TWHeader(tr("place_search"))

                                // Sorgu
                                TextField("",
                                          text: $query,
                                          prompt: Text(LocalizedStringKey("search_places_placeholder")))
                                    .textFieldStyle(.roundedBorder)
                                    .onChange(of: query) { _, new in startCompleter(with: new) }

                                // ÖNERİLER
                                if searching { ProgressView().tint(.secondary) }

                                if !suggestions.isEmpty {
                                    VStack(spacing: 0) {
                                        ForEach(suggestions, id: \.self) { s in
                                            Button {
                                                select(completion: s)
                                            } label: {
                                                HStack(alignment: .firstTextBaseline, spacing: 10) {
                                                    Image(systemName: "mappin.and.ellipse")
                                                        .foregroundStyle(.secondary)
                                                    VStack(alignment: .leading) {
                                                        Text(s.title).font(.body)
                                                        if !s.subtitle.isEmpty {
                                                            Text(s.subtitle)
                                                                .font(.footnote)
                                                                .foregroundStyle(.secondary)
                                                        }
                                                    }
                                                    Spacer()
                                                }
                                                .padding(.vertical, 8)
                                            }
                                            .buttonStyle(.plain)
                                            .overlay(Divider(), alignment: .bottom)
                                        }
                                    }
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color.white.opacity(0.55))
                                    )
                                }

                                TextField(tr("title"), text: $title)
                                    .textFieldStyle(.roundedBorder)

                                TextField(tr("link_optional"), text: $link)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.URL)
                                    .textFieldStyle(.roundedBorder)

                                if let address {
                                    Label(address, systemImage: "mappin.circle")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        // WHEN
                        TWCard {
                            VStack(alignment: .leading, spacing: 12) {
                                TWHeader(tr("when"))
                                DatePicker(tr("date"),
                                           selection: $date,
                                           in: trip.startDate...trip.endDate,
                                           displayedComponents: .date)
                                Toggle(tr("set_time"), isOn: $setTime)
                                if setTime {
                                    DatePicker(tr("time"),
                                               selection: $time,
                                               displayedComponents: .hourAndMinute)
                                }
                            }
                        }

                        // PHOTO
                        TWCard {
                            VStack(alignment: .leading, spacing: 12) {
                                TWHeader(tr("photo"))
                                PhotosPicker(selection: $photoItem, matching: .images) {
                                    Label(tr("pick_photo"), systemImage: "photo.on.rectangle").font(.headline)
                                }
                                .onChange(of: photoItem) { _, item in
                                    Task {
                                        guard let data = try? await item?.loadTransferable(type: Data.self) else { return }
                                        imageData = data
                                    }
                                }

                                if let data = imageData, let ui = UIImage(data: data) {
                                    Image(uiImage: ui)
                                        .resizable().scaledToFill()
                                        .frame(height: 140)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle(Text(LocalizedStringKey("add_stop")))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(tr("cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(tr("save")) { save() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                // Completer ayarı + delegate’ı TUT
                completer.resultTypes = [.address, .pointOfInterest]
                completer.region = regionForTrip(trip)
                let proxy = CompleterProxy { items in
                    self.suggestions = items
                    self.searching = false
                }
                completer.delegate = proxy
                completerDelegate = proxy
            }
        }
    }

    // Actions

    private func startCompleter(with text: String) {
        suggestions.removeAll()
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { searching = false; return }
        searching = true
        completer.queryFragment = trimmed
    }

    private func select(completion: MKLocalSearchCompletion) {
        query = completion.title
        title = completion.title
        searching = true

        let req = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: req)
        Task {
            if let resp = try? await search.start(),
               let item = resp.mapItems.first {
                address = item.placemark.formattedAddress
                coord = item.placemark.coordinate
                if title.isEmpty { title = item.name ?? completion.title }
            }
            searching = false
            suggestions = []
        }
    }

    private func save() {
        let s = Stop(tripID: trip.id,
                     title: title.isEmpty ? tr("untitled") : title,
                     date: date,
                     order: (trip.stops.count + 1))
        if setTime { s.time = time }
        s.urlString = link.isEmpty ? nil : link
        s.address = address
        if let c = coord { s.latitude = c.latitude; s.longitude = c.longitude }
        s.imageData = imageData
        trip.stops.append(s)
        dismiss()
    }
}

//  Completer delegate köprüsü

final class CompleterProxy: NSObject, MKLocalSearchCompleterDelegate {
    let onUpdate: ([MKLocalSearchCompletion]) -> Void
    init(onUpdate: @escaping ([MKLocalSearchCompletion]) -> Void) { self.onUpdate = onUpdate }
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) { onUpdate(completer.results) }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) { onUpdate([]) }
}

//  Yardımcılar

private func regionForTrip(_ trip: Trip) -> MKCoordinateRegion {
    let coords = trip.stops.compactMap { s -> CLLocationCoordinate2D? in
        guard let lat = s.latitude, let lon = s.longitude else { return nil }
        return .init(latitude: lat, longitude: lon)
    }
    if let first = coords.first {
        return .init(center: first, span: .init(latitudeDelta: 0.5, longitudeDelta: 0.5))
    } else {
        // Türkiye civarı varsayılan
        return .init(center: .init(latitude: 39.0, longitude: 35.0),
                     span: .init(latitudeDelta: 6.0, longitudeDelta: 6.0))
    }
}

private extension MKPlacemark {
    var formattedAddress: String {
        [thoroughfare, subThoroughfare, locality, administrativeArea, country]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
