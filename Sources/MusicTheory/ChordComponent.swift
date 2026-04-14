//
//  ChordComponent.swift
//  MusicTheory
//
//  Created by Cem Olcay on 2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - ChordComponent

/// A single component of a chord, expressed as a specific interval quality from the root.
///
/// This flat enum replaces the old `ChordPart` protocol hierarchy
/// (ChordThirdType, ChordFifthType, ChordSixthType, ChordSeventhType,
/// ChordSuspendedType, ChordExtensionType).
///
/// Each case corresponds to exactly one `Interval`, eliminating ambiguity.
/// Note the fix: `.flatEleventh` maps to `d11` (16 semitones), not `P11` (17 semitones).
public enum ChordComponent: Int, Hashable, Comparable, Codable,
    CaseIterable, CustomStringConvertible, Sendable {

    // Seconds (suspension tones)
    case minorSecond    = 1   // m2
    case majorSecond    = 2   // M2  (sus2)

    // Thirds
    case minorThird     = 3   // m3
    case majorThird     = 4   // M3

    // Fourth (suspension tone)
    case perfectFourth  = 5   // P4  (sus4)

    // Fifths
    case diminishedFifth  = 6  // d5
    case perfectFifth     = 7  // P5
    case augmentedFifth   = 8  // A5

    // Sixth
    case majorSixth     = 9   // M6

    // Sevenths (degree 7)
    case diminishedSeventh = 10  // d7  (bb7, 9 semitones)
    case minorSeventh      = 11  // m7
    case majorSeventh      = 12  // M7

    // Extensions (degree 9)
    case flatNinth    = 13  // m9
    case ninth        = 14  // M9
    case sharpNinth   = 15  // A9

    // Extensions (degree 11)
    case flatEleventh  = 16  // d11 — 16 semitones (FIXED: was incorrectly P11 = 17)
    case eleventh      = 17  // P11
    case sharpEleventh = 18  // A11

    // Extensions (degree 13)
    case flatThirteenth  = 19  // m13
    case thirteenth      = 20  // M13
    case sharpThirteenth = 21  // A13

    // MARK: Interval

    /// The interval this component represents from the chord root.
    public var interval: Interval {
        switch self {
        case .minorSecond:       return .m2
        case .majorSecond:       return .M2
        case .minorThird:        return .m3
        case .majorThird:        return .M3
        case .perfectFourth:     return .P4
        case .diminishedFifth:   return .d5
        case .perfectFifth:      return .P5
        case .augmentedFifth:    return .A5
        case .majorSixth:        return .M6
        case .diminishedSeventh: return .d7   // 9 semitones (bb7)
        case .minorSeventh:      return .m7
        case .majorSeventh:      return .M7
        case .flatNinth:         return .m9
        case .ninth:             return .M9
        case .sharpNinth:        return .A9
        case .flatEleventh:      return .d11  // 16 semitones — FIXED
        case .eleventh:          return .P11
        case .sharpEleventh:     return .A11
        case .flatThirteenth:    return .m13
        case .thirteenth:        return .M13
        case .sharpThirteenth:   return .A13
        }
    }

    // MARK: Init from Interval

    /// Creates a `ChordComponent` from an interval, matching by both semitones and degree.
    /// Returns `nil` if the interval doesn't correspond to a known chord component.
    public init?(interval: Interval) {
        // Match structurally first (same quality + degree)
        for component in ChordComponent.allCases {
            if component.interval == interval {
                self = component
                return
            }
        }
        return nil
    }

    // MARK: Comparable

    public static func < (lhs: ChordComponent, rhs: ChordComponent) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    // MARK: CustomStringConvertible

    /// Short symbol notation (e.g. "m3", "P5", "#11").
    public var symbol: String {
        switch self {
        case .minorSecond:       return "b2"
        case .majorSecond:       return "2"
        case .minorThird:        return "b3"
        case .majorThird:        return "3"
        case .perfectFourth:     return "4"
        case .diminishedFifth:   return "b5"
        case .perfectFifth:      return "5"
        case .augmentedFifth:    return "#5"
        case .majorSixth:        return "6"
        case .diminishedSeventh: return "bb7"
        case .minorSeventh:      return "b7"
        case .majorSeventh:      return "7"
        case .flatNinth:         return "b9"
        case .ninth:             return "9"
        case .sharpNinth:        return "#9"
        case .flatEleventh:      return "b11"
        case .eleventh:          return "11"
        case .sharpEleventh:     return "#11"
        case .flatThirteenth:    return "b13"
        case .thirteenth:        return "13"
        case .sharpThirteenth:   return "#13"
        }
    }

    public var description: String { symbol }
}
