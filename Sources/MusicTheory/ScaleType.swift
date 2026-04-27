//
//  ScaleType.swift
//  MusicTheory
//
//  Created by Cem Olcay on 1/16/22.
//  Copyright © 2022 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - ScaleType

/// A lightweight named interval preset for building scales.
///
/// `ScaleType` is intentionally small: it stores a display name and the
/// intervals used to build a scale. Equality compares intervals only, so
/// different names for the same interval pattern are treated as equal.
public struct ScaleType: Codable, Hashable, CustomStringConvertible, Sendable {

    /// Intervals from the root, in ascending order.
    public let intervals: [Interval]

    /// Display name of the scale type.
    public let description: String

    public init(intervals: [Interval], description: String) {
        self.intervals = intervals
        self.description = description
    }

    public static func == (lhs: ScaleType, rhs: ScaleType) -> Bool {
        return lhs.intervals == rhs.intervals
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(intervals)
    }
}

// MARK: - Built-In Scale Types

extension ScaleType {
    /// Major / Ionian scale.
    public static let major = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .M6, .M7], description: "Major")
    /// Dorian mode.
    public static let dorian = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .M6, .m7], description: "Dorian")
    /// Phrygian mode.
    public static let phrygian = ScaleType(intervals: [.P1, .m2, .m3, .P4, .P5, .m6, .m7], description: "Phrygian")
    /// Lydian mode.
    public static let lydian = ScaleType(intervals: [.P1, .M2, .M3, .A4, .P5, .M6, .M7], description: "Lydian")
    /// Mixolydian mode.
    public static let mixolydian = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .M6, .m7], description: "Mixolydian")
    /// Natural minor / Aeolian mode.
    public static let minor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .m6, .m7], description: "Minor")
    /// Locrian mode.
    public static let locrian = ScaleType(intervals: [.P1, .m2, .m3, .P4, .d5, .m6, .m7], description: "Locrian")

    /// Harmonic minor scale.
    public static let harmonicMinor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .m6, .M7], description: "Harmonic Minor")
    /// Melodic minor scale.
    public static let melodicMinor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .M6, .M7], description: "Melodic Minor")
    /// Harmonic major scale.
    public static let harmonicMajor = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .m6, .M7], description: "Harmonic Major")

    /// Lydian dominant / Lydian b7.
    public static let lydianDominant = ScaleType(intervals: [.P1, .M2, .M3, .A4, .P5, .M6, .m7], description: "Lydian Dominant")
    /// Altered / Super Locrian scale.
    public static let altered = ScaleType(intervals: [.P1, .m2, .m3, .d4, .d5, .m6, .m7], description: "Altered")
    /// Phrygian dominant / Phrygian major scale.
    public static let phrygianDominant = ScaleType(intervals: [.P1, .m2, .M3, .P4, .P5, .m6, .m7], description: "Phrygian Dominant")

    /// Major pentatonic scale.
    public static let pentatonicMajor = ScaleType(intervals: [.P1, .M2, .M3, .P5, .M6], description: "Pentatonic Major")
    /// Minor pentatonic scale.
    public static let pentatonicMinor = ScaleType(intervals: [.P1, .m3, .P4, .P5, .m7], description: "Pentatonic Minor")
    /// Blues pentatonic scale.
    public static let pentatonicBlues = ScaleType(intervals: [.P1, .m3, .P4, .A4, .P5, .m7], description: "Pentatonic Blues")

    /// Whole-tone scale.
    public static let wholeTone = ScaleType(intervals: [.P1, .M2, .M3, .A4, .m6, .m7], description: "Whole Tone")
    /// Whole-half diminished scale.
    public static let diminished = ScaleType(intervals: [.P1, .M2, .m3, .P4, .d5, .m6, .M6, .M7], description: "Diminished")
    /// Chromatic scale.
    public static let chromatic = ScaleType(intervals: [.P1, .m2, .M2, .m3, .M3, .P4, .d5, .P5, .m6, .M6, .m7, .M7], description: "Chromatic")

    /// Convenience aliases.
    public static var ionian: ScaleType { .major }
    public static var aeolian: ScaleType { .minor }
    public static var naturalMinor: ScaleType { .minor }
    public static var lydianFlat7: ScaleType { .lydianDominant }
    public static var phrygianMajor: ScaleType { .phrygianDominant }
    public static var whole: ScaleType { .wholeTone }
    public static var wholeDiminished: ScaleType { .diminished }
    
    public static var allScales: [ScaleType] {
        [major, minor, dorian, phrygian, lydian, mixolydian, locrian,
         harmonicMinor, melodicMinor, harmonicMajor, lydianDominant, altered, phrygianDominant,
         pentatonicMajor, pentatonicMinor, pentatonicBlues, wholeTone, diminished, chromatic]
    }
}
