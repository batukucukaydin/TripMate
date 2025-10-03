//
//  TripMapView.swift
//  TripMate
//

//


import SwiftUI
import MapKit

struct TripMapView: View {
    @Bindable var trip: Trip
    @State private var position: MapCameraPosition = .automatic

    // CLLocationCoordinate2D Hashable olmadığı için manuel Equatable/Hashable
    struct Pin: Identifiable, Hashable, Equatable {
        let id = UUID()
        let title: String
        let coord: CLLocationCoordinate2D

        static func == (lhs: Pin, rhs: Pin) -> Bool { lhs.id == rhs.id }
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
    }

    // Pin listesi (sıralı)
    var pins: [Pin] {
        let sorted = trip.stops.sorted {
            if let a = $0.time, let b = $1.time { return a < b }
            if $0.time != nil { return true }
            if $1.time != nil { return false }
            return $0.order < $1.order
        }
        return sorted.compactMap { s in
            guard let lat = s.latitude, let lon = s.longitude else { return nil }
            return Pin(title: s.title, coord: .init(latitude: lat, longitude: lon))
        }
    }

    // Rota çizgisi
    var polyline: MKPolyline? {
        let coords = pins.map { $0.coord }
        guard coords.count >= 2 else { return nil }
        return MKPolyline(coordinates: coords, count: coords.count)
    }

    var body: some View {
        Map(position: $position) {
            // rota
            if let line = polyline {
                MapPolyline(line)
                    .stroke(.blue.opacity(0.7), lineWidth: 4)
            }
            // pinler
            ForEach(Array(pins.enumerated()), id: \.1.id) { (idx, p) in
                Annotation("\(idx+1). \(p.title)", coordinate: p.coord) {
                    ZStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundStyle(.red)
                        Text("\(idx+1)")
                            .font(.caption2).bold()
                            .foregroundStyle(.white)
                            .offset(y: 10)
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
        .onAppear { fitToPins(animated: false) }
        .onChange(of: trip.stops) { _ in fitToPins(animated: true) }
    }

    // Bütün pinleri kadraja al
    private func fitToPins(animated: Bool) {
        let coords = pins.map { $0.coord }
        guard !coords.isEmpty else { return }
        let region = regionThatFits(coords: coords, padding: 0.25)
        position = .region(region)
    }

    // Koordinat dizisini saran bölge
    private func regionThatFits(coords: [CLLocationCoordinate2D], padding: CLLocationDegrees) -> MKCoordinateRegion {
        guard let first = coords.first else {
            return .init(center: .init(latitude: 39, longitude: 35),
                         span: .init(latitudeDelta: 4, longitudeDelta: 4))
        }
        var minLat = first.latitude, maxLat = first.latitude
        var minLon = first.longitude, maxLon = first.longitude
        for c in coords {
            minLat = min(minLat, c.latitude);  maxLat = max(maxLat, c.latitude)
            minLon = min(minLon, c.longitude); maxLon = max(maxLon, c.longitude)
        }
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                                            longitude: (minLon + maxLon)/2)
        var span = MKCoordinateSpan(latitudeDelta: max(0.01, (maxLat - minLat)),
                                    longitudeDelta: max(0.01, (maxLon - minLon)))
        span = MKCoordinateSpan(latitudeDelta: span.latitudeDelta * (1 + padding),
                                longitudeDelta: span.longitudeDelta * (1 + padding))
        return MKCoordinateRegion(center: center, span: span)
    }
}
