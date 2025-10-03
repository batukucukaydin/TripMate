//
//  TripsListView.swift
//  TripMate
//
//
//
//
//  TripsListView.swift
//  TripMate
//

//
//  TripsListView.swift
//  TripMate
//

import SwiftUI
import SwiftData

struct TripsListView: View {
    @Environment(\.modelContext) private var ctx
    @Query(sort: \Trip.startDate, order: .reverse) private var trips: [Trip]
    @State private var showNew = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                GradientBackground()

                VStack(spacing: 8) {
                    
                    VStack(spacing: 6) {
                        Image(systemName: "airplane.departure")
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(colors: [
                                    Color.black.opacity(0.9),
                                    Color(hue: 0.75, saturation: 0.25, brightness: 0.25)
                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .shadow(color: .black.opacity(0.25), radius: 6, y: 2)

                        Text("TripMate")
                            .font(.system(size: 36, weight: .semibold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: [
                                    Color.black.opacity(0.9),
                                    Color(hue: 0.75, saturation: 0.25, brightness: 0.25)
                                ], startPoint: .leading, endPoint: .trailing)
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    .padding(.bottom, 2)

                    // Liste görünümü
                    List {
                        ForEach(Array(trips.enumerated()), id: \.1.id) { index, trip in
                            NavigationLink(value: trip) {
                                TripStackRow(trip: trip, paletteIndex: index)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    ctx.delete(trip)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                        .labelStyle(.iconOnly)
                                        .foregroundColor(.white)
                                }
                                .tint(.black)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }

                // Sağ altta "Add Trip" butonu
                FloatingAddButton(titleText: NSLocalizedString("add_trip", comment: ""),
                                  icon: "plus") { showNew = true }
                    .padding(.trailing, 16)
                    .padding(.bottom, 28)
            }
            .navigationDestination(for: Trip.self) { TripDetailView(trip: $0) }
            .sheet(isPresented: $showNew) { NewTripSheet() }
        }
    }
}

//  Kartlar
private struct TripStackRow: View {
    let trip: Trip
    let paletteIndex: Int

    private var palette: (Color, Color, Color) {
        let bank: [(Color, Color, Color)] = [
            (Color(hex: 0xFFD18A), Color(hex: 0xFFC170), Color(hex: 0xF9B15C)),
            (Color(hex: 0xF5C5DA), Color(hex: 0xF0A9C7), Color(hex: 0xEC95BC)),
            (Color(hex: 0xC8CAF7), Color(hex: 0xB7B9F3), Color(hex: 0xA8ABF0)),
            (Color(hex: 0xB4F1DF), Color(hex: 0x9FE9D3), Color(hex: 0x8DDCC6)),
            (Color(hex: 0xFFE3B3), Color(hex: 0xFFD692), Color(hex: 0xFFC86E))
        ]
        return bank[paletteIndex % bank.count]
    }

    private var dateRangeString: String {
        let f = DateFormatter()
        f.dateFormat = "d MMM"
        let start = f.string(from: trip.startDate)
        let end = f.string(from: trip.endDate)

        let calendar = Calendar.current
        let startYear = calendar.component(.year, from: trip.startDate)
        let endYear = calendar.component(.year, from: trip.endDate)

        if startYear != endYear {
            f.dateFormat = "d MMM yyyy"
            return "\(f.string(from: trip.startDate)) – \(f.string(from: trip.endDate))"
        } else {
            return "\(start) – \(end) \(startYear)"
        }
    }

    var body: some View {
        let (c1, c2, c3) = palette

        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(LinearGradient(colors: [c1, c2],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .overlay {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(c3.opacity(0.35), lineWidth: 1)
                        .blur(radius: 0.5)
                }
                .shadow(color: c2.opacity(0.35), radius: 12, y: 6)

            VStack(alignment: .leading, spacing: 8) {
                Text(dateRangeString.uppercased())
                    .font(.footnote.smallCaps())
                    .foregroundStyle(.black.opacity(0.55))

                Text(trip.title)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.85))

                HStack(spacing: 8) {
                    Image(systemName: "airplane.departure")
                    Image(systemName: "fork.knife")
                    Text("+3").font(.subheadline.weight(.semibold))
                }
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial, in: Capsule())
                .foregroundStyle(.black.opacity(0.65))
                .padding(.top, 2)
            }
            .padding(20)
        }
        .frame(height: 130)
        .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.vertical, 4)
    }
}

//  Hex Color helper
private extension Color {
    init(hex: UInt32) {
        let r = Double((hex & 0xFF0000) >> 16) / 255.0
        let g = Double((hex & 0x00FF00) >> 8) / 255.0
        let b = Double(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
