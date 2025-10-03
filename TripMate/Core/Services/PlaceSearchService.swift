//
//  PlaceSearchService.swift
//  TripMate
//
import MapKit

final class PlaceSearchService {
    func search(_ query: String) async -> [MKMapItem] {
        guard !query.isEmpty else { return [] }
        let req = MKLocalSearch.Request(); req.naturalLanguageQuery = query
        let search = MKLocalSearch(request: req)
        return (try? await search.start().mapItems) ?? []
    }
}

