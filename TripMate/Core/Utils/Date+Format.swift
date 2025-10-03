//
//  Date+Format.swift
//  TripMate
//
import Foundation

extension Date {
    func mediumRange(to end: Date) -> String {
        let f = DateFormatter(); f.dateStyle = .medium
        return "\(f.string(from: self)) – \(f.string(from: end))"
    }
}
