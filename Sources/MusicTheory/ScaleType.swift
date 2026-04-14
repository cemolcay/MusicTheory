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

/// Describes a scale by its interval pattern from the root.
///
/// **Equality compares intervals only** (not name or aliases), so
/// `ScaleType.major == ScaleType.ionian` is `true`.
public struct ScaleType: Codable, Hashable, CustomStringConvertible, Sendable {

    // MARK: Category

    /// Broad classification of scale families.
    public enum Category: String, Codable, CaseIterable, CustomStringConvertible, Sendable {
        case diatonic
        case melodicMinorMode
        case harmonicMinorMode
        case harmonicMajorMode
        case pentatonic
        case hexatonic
        case octatonic
        case chromatic
        case symmetric
        case blues
        case bebop
        case world
        case exotic
        case custom

        public var description: String { rawValue }
    }

    // MARK: Stored properties

    /// Intervals from root. Always starts with `.P1` and is sorted ascending.
    public let intervals: [Interval]

    /// Primary name of the scale.
    public let name: String

    /// Alternative names (e.g., "Ionian" is an alias of "Major").
    public let aliases: [String]

    /// Broad category for grouping and filtering.
    public let category: Category

    // MARK: Computed

    /// Number of distinct pitch classes in the scale (cardinality).
    public var cardinality: Int { intervals.count }

    // MARK: Initializers

    /// Creates a scale type with validated intervals.
    /// Returns `nil` if intervals are empty, don't start with `.P1`, or contain duplicate degrees.
    public init?(intervals: [Interval], name: String, aliases: [String] = [], category: Category = .custom) {
        guard !intervals.isEmpty,
              intervals.first == .P1 else { return nil }
        self.intervals = intervals
        self.name = name
        self.aliases = aliases
        self.category = category
    }

    /// Internal unchecked initializer for predefined scales.
    internal init(unchecked intervals: [Interval], name: String, aliases: [String] = [], category: Category = .custom) {
        self.intervals = intervals
        self.name = name
        self.aliases = aliases
        self.category = category
    }

    // MARK: Equatable — by intervals only

    public static func == (lhs: ScaleType, rhs: ScaleType) -> Bool {
        return lhs.intervals == rhs.intervals
    }

    // MARK: Hashable — by intervals only

    public func hash(into hasher: inout Hasher) {
        hasher.combine(intervals)
    }

    // MARK: CustomStringConvertible

    public var description: String { name }

    // MARK: Codable

    private enum CodingKeys: String, CodingKey {
        case intervals, name, aliases, category
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let intervals = try c.decode([Interval].self, forKey: .intervals)
        let name = try c.decode(String.self, forKey: .name)
        let aliases = (try? c.decode([String].self, forKey: .aliases)) ?? []
        let category = (try? c.decode(Category.self, forKey: .category)) ?? .custom
        self.intervals = intervals
        self.name = name
        self.aliases = aliases
        self.category = category
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(intervals, forKey: .intervals)
        try c.encode(name, forKey: .name)
        try c.encode(aliases, forKey: .aliases)
        try c.encode(category, forKey: .category)
    }
}

// MARK: - Mode Generation

extension ScaleType {
    /// Returns the Nth mode of this scale (1-indexed; 1 returns self).
    ///
    /// Mode generation works by rotating the scale to start at the Nth degree,
    /// then re-expressing all intervals relative to the new root.
    public func mode(_ degree: Int) -> ScaleType? {
        guard degree >= 1, degree <= cardinality else { return nil }
        if degree == 1 { return self }

        let idx = degree - 1  // 0-indexed
        // The semitone offset of the new root from the original root
        let newRootSemitones = intervals[idx].semitones

        // Rotate intervals: take from idx..end, then 0..idx
        // Normalise each by subtracting newRootSemitones, wrapping the prefix with +12
        var rotated = [Interval]()
        let count = cardinality
        for i in 0..<count {
            let sourceIdx = (idx + i) % count
            let rawSemitones = intervals[sourceIdx].semitones - newRootSemitones
            let normalised = rawSemitones < 0 ? rawSemitones + 12 : rawSemitones
            // Derive degree: it's just position (1-indexed) in the mode
            let targetDegree = i + 1
            if let interval = Interval(semitones: normalised, degree: targetDegree) {
                rotated.append(interval)
            } else {
                // Fall back: use augmented or diminished based on offset
                let fallback = Interval(unchecked: normalised >= 6 ? .diminished : .augmented, degree: targetDegree)
                rotated.append(fallback)
            }
        }
        return ScaleType(unchecked: rotated, name: "Mode \(degree) of \(name)", category: category)
    }

    /// All modes of this scale.
    public var modes: [ScaleType] {
        return (1...cardinality).compactMap { mode($0) }
    }

    /// Returns true if this scale is a mode of another (same interval set, different rotation).
    public func isMode(of other: ScaleType) -> Bool {
        guard cardinality == other.cardinality else { return false }
        if self == other { return true }
        return other.modes.contains(self)
    }
}

// MARK: - Lookup

extension ScaleType {
    /// Returns all predefined scale types whose interval pattern exactly matches the given intervals.
    public static func find(matching intervals: [Interval]) -> [ScaleType] {
        return all.filter { $0.intervals == intervals }
    }

    /// Returns all predefined scale types whose interval pattern contains all of the given intervals.
    public static func find(containing intervals: [Interval]) -> [ScaleType] {
        return all.filter { scaleType in
            intervals.allSatisfy { scaleType.intervals.contains($0) }
        }
    }

    /// Returns all predefined scale types in the given category.
    public static func scales(in category: Category) -> [ScaleType] {
        return all.filter { $0.category == category }
    }
}

// MARK: - Predefined Scale Types

extension ScaleType {

    // MARK: Diatonic modes (7 modes of the major scale)

    /// Major / Ionian scale.
    public static let major        = ScaleType(unchecked: [.P1, .M2, .M3, .P4, .P5, .M6, .M7], name: "Major", aliases: ["Ionian"], category: .diatonic)
    /// Dorian mode.
    public static let dorian       = ScaleType(unchecked: [.P1, .M2, .m3, .P4, .P5, .M6, .m7], name: "Dorian", category: .diatonic)
    /// Phrygian mode.
    public static let phrygian     = ScaleType(unchecked: [.P1, .m2, .m3, .P4, .P5, .m6, .m7], name: "Phrygian", category: .diatonic)
    /// Lydian mode.
    public static let lydian       = ScaleType(unchecked: [.P1, .M2, .M3, .A4, .P5, .M6, .M7], name: "Lydian", category: .diatonic)
    /// Mixolydian mode.
    public static let mixolydian   = ScaleType(unchecked: [.P1, .M2, .M3, .P4, .P5, .M6, .m7], name: "Mixolydian", category: .diatonic)
    /// Natural Minor / Aeolian mode.
    public static let minor        = ScaleType(unchecked: [.P1, .M2, .m3, .P4, .P5, .m6, .m7], name: "Minor", aliases: ["Aeolian", "Natural Minor"], category: .diatonic)
    /// Locrian mode.
    public static let locrian      = ScaleType(unchecked: [.P1, .m2, .m3, .P4, .d5, .m6, .m7], name: "Locrian", category: .diatonic)

    /// Convenience aliases for readability.
    public static var ionian:       ScaleType { .major }
    public static var aeolian:      ScaleType { .minor }
    public static var naturalMinor: ScaleType { .minor }

    // MARK: Harmonic / Melodic minor and their modes

    /// Harmonic minor scale.
    public static let harmonicMinor         = ScaleType(unchecked: [.P1, .M2, .m3, .P4, .P5, .m6, .M7], name: "Harmonic Minor", category: .harmonicMinorMode)
    /// Locrian ♮6 (mode 2 of harmonic minor).
    public static let locrianNatural6       = ScaleType(unchecked: [.P1, .m2, .m3, .P4, .d5, .M6, .m7], name: "Locrian ♮6", category: .harmonicMinorMode)
    /// Ionian #5 (mode 3 of harmonic minor).
    public static let ionianSharp5          = ScaleType(unchecked: [.P1, .M2, .M3, .P4, .m6, .M6, .M7], name: "Ionian #5", aliases: ["Ionian Augmented"], category: .harmonicMinorMode)
    /// Dorian #4 (mode 4 of harmonic minor).
    public static let dorianSharp4          = ScaleType(unchecked: [.P1, .M2, .m3, .A4, .P5, .M6, .m7], name: "Dorian #4", aliases: ["Ukrainian Dorian"], category: .harmonicMinorMode)
    /// Phrygian Major / Spanish Gypsy (mode 5 of harmonic minor).
    public static let phrygianMajor         = ScaleType(unchecked: [.P1, .m2, .M3, .P4, .P5, .m6, .m7], name: "Phrygian Major", aliases: ["Spanish Gypsy", "Flamenco", "Byzantine", "Double Harmonic", "Maqam"], category: .harmonicMinorMode)
    /// Lydian #2 (mode 6 of harmonic minor).
    public static let lydianSharp2          = ScaleType(unchecked: [.P1, .m3, .M3, .A4, .P5, .M6, .M7], name: "Lydian #2", category: .harmonicMinorMode)
    /// Super Locrian bb7 (mode 7 of harmonic minor).
    public static let superLocrianBb7       = ScaleType(unchecked: [.P1, .m2, .m3, .M3, .d5, .m6, .d7], name: "Super Locrian bb7", category: .harmonicMinorMode)

    /// Melodic minor (ascending form).
    public static let melodicMinor          = ScaleType(unchecked: [.P1, .M2, .m3, .P4, .P5, .M6, .M7], name: "Melodic Minor", aliases: ["Jazz Melodic Minor"], category: .melodicMinorMode)
    /// Dorian b2 (mode 2 of melodic minor).
    public static let dorianFlat2           = ScaleType(unchecked: [.P1, .m2, .m3, .P4, .P5, .M6, .m7], name: "Dorian b2", aliases: ["Phrygian #6"], category: .melodicMinorMode)
    /// Lydian Augmented (mode 3 of melodic minor).
    public static let lydianAugmented       = ScaleType(unchecked: [.P1, .M2, .M3, .A4, .A5, .M6, .M7], name: "Lydian Augmented", category: .melodicMinorMode)
    /// Lydian b7 / Overtone (mode 4 of melodic minor).
    public static let lydianFlat7           = ScaleType(unchecked: [.P1, .M2, .M3, .A4, .P5, .M6, .m7], name: "Lydian b7", aliases: ["Overtone", "Lydian Dominant"], category: .melodicMinorMode)
    /// Mixolydian b6 (mode 5 of melodic minor).
    public static let mixolydianFlat6       = ScaleType(unchecked: [.P1, .M2, .M3, .P4, .P5, .m6, .m7], name: "Mixolydian b6", aliases: ["Hindu", "Descending Melodic Minor"], category: .melodicMinorMode)
    /// Locrian ♮2 / Half-Diminished (mode 6 of melodic minor).
    public static let halfDiminished        = ScaleType(unchecked: [.P1, .M2, .m3, .P4, .d5, .m6, .m7], name: "Half Diminished", aliases: ["Locrian ♮2", "Locrian 2"], category: .melodicMinorMode)
    /// Altered / Super Locrian (mode 7 of melodic minor).
    public static let altered               = ScaleType(unchecked: [.P1, .m2, .m3, .M3, .d5, .m6, .m7], name: "Altered", aliases: ["Super Locrian", "Diminished Whole Tone"], category: .melodicMinorMode)

    // MARK: Harmonic major and its modes

    /// Harmonic major scale.
    public static let harmonicMajor        = ScaleType(unchecked: [.P1, .M2, .M3, .P4, .P5, .m6, .M7], name: "Harmonic Major", category: .harmonicMajorMode)
    /// Dorian b5 (mode 2 of harmonic major).
    public static let dorianFlat5          = ScaleType(unchecked: [.P1, .M2, .m3, .P4, .d5, .M6, .m7], name: "Dorian b5", category: .harmonicMajorMode)
    /// Phrygian b4 (mode 3 of harmonic major).
    public static let phrygianFlat4        = ScaleType(unchecked: [.P1, .m2, .m3, .M3, .P5, .m6, .m7], name: "Phrygian b4", aliases: ["Ultraphrygian"], category: .harmonicMajorMode)
    /// Lydian b3 (mode 4 of harmonic major).
    public static let lydianFlat3          = ScaleType(unchecked: [.P1, .M2, .m3, .A4, .P5, .M6, .M7], name: "Lydian b3", aliases: ["Lydian Diminished"], category: .harmonicMajorMode)
    /// Mixolydian b2 (mode 5 of harmonic major).
    public static let mixolydianFlat2      = ScaleType(unchecked: [.P1, .m2, .M3, .P4, .P5, .M6, .m7], name: "Mixolydian b2", category: .harmonicMajorMode)
    /// Lydian Augmented #2 (mode 6 of harmonic major).
    public static let lydianAugmentedSharp2 = ScaleType(unchecked: [.P1, .m3, .M3, .A4, .A5, .M6, .M7], name: "Lydian Augmented #2", category: .harmonicMajorMode)
    /// Locrian bb7 (mode 7 of harmonic major).
    public static let locrianDiminished    = ScaleType(unchecked: [.P1, .m2, .m3, .P4, .d5, .m6, .M6], name: "Locrian Diminished", category: .harmonicMajorMode)

    // MARK: Pentatonic

    /// Pentatonic major scale.
    public static let pentatonicMajor      = ScaleType(unchecked: [.P1, .M2, .M3, .P5, .M6], name: "Pentatonic Major", aliases: ["Mongolian", "Ritsusen"], category: .pentatonic)
    /// Pentatonic minor scale.
    public static let pentatonicMinor      = ScaleType(unchecked: [.P1, .m3, .P4, .P5, .m7], name: "Pentatonic Minor", aliases: ["Yo"], category: .pentatonic)
    /// Pentatonic blues scale.
    public static let pentatonicBlues      = ScaleType(unchecked: [.P1, .m3, .P4, .d5, .P5, .m7], name: "Pentatonic Blues", category: .pentatonic)
    /// Pentatonic neutral scale.
    public static let pentatonicNeutral    = ScaleType(unchecked: [.P1, .M2, .P4, .P5, .m7], name: "Pentatonic Neutral", category: .pentatonic)
    /// Hirajoshi scale.
    public static let hirajoshi            = ScaleType(unchecked: [.P1, .M2, .m3, .P5, .m6], name: "Hirajoshi", category: .pentatonic)
    /// Balinese scale.
    public static let balinese             = ScaleType(unchecked: [.P1, .m2, .m3, .P5, .m6], name: "Balinese", category: .pentatonic)
    /// Kumoi scale.
    public static let kumoi               = ScaleType(unchecked: [.P1, .M2, .m3, .P5, .M6], name: "Kumoi", category: .pentatonic)
    /// Iwato scale.
    public static let iwato               = ScaleType(unchecked: [.P1, .m2, .P4, .d5, .m7], name: "Iwato", category: .pentatonic)
    /// Insen scale.
    public static let insen               = ScaleType(unchecked: [.P1, .m2, .P4, .P5, .m7], name: "Insen", category: .pentatonic)
    /// Man Gong scale.
    public static let manGong             = ScaleType(unchecked: [.P1, .m3, .P4, .m6, .m7], name: "Man Gong", category: .pentatonic)
    /// Chinese scale.
    public static let chinese             = ScaleType(unchecked: [.P1, .M3, .A4, .P5, .M7], name: "Chinese", category: .pentatonic)

    // MARK: Hexatonic

    /// Whole-tone scale.
    public static let whole               = ScaleType(unchecked: [.P1, .M2, .M3, .A4, .m6, .m7], name: "Whole Tone", aliases: ["Auxiliary Augmented"], category: .symmetric)
    /// Augmented scale (symmetric hexatonic).
    public static let augmented           = ScaleType(unchecked: [.P1, .m3, .M3, .P5, .m6, .M7], name: "Augmented", category: .symmetric)
    /// Tritone hexatonic scale.
    public static let tritone             = ScaleType(unchecked: [.P1, .m2, .M3, .d5, .P5, .m7], name: "Tritone", category: .hexatonic)
    /// Prometheus scale.
    public static let prometheus          = ScaleType(unchecked: [.P1, .M2, .M3, .A4, .M6, .m7], name: "Prometheus", category: .hexatonic)
    /// Prometheus Neopolitan scale.
    public static let prometheusNeopolitan = ScaleType(unchecked: [.P1, .m2, .M3, .A4, .M6, .m7], name: "Prometheus Neopolitan", category: .hexatonic)
    /// Six Tone Symmetrical scale.
    public static let sixToneSymmetrical  = ScaleType(unchecked: [.P1, .m2, .M3, .P4, .m6, .M6], name: "Six Tone Symmetrical", category: .symmetric)
    /// Istrian scale.
    public static let istrian             = ScaleType(unchecked: [.P1, .m2, .m3, .d4, .d5, .P5], name: "Istrian", category: .hexatonic)
    /// Major Blues hexatonic scale.
    public static let majorBluesHexatonic = ScaleType(unchecked: [.P1, .M2, .m3, .M3, .P5, .M6], name: "Major Blues Hexatonic", category: .blues)
    /// Minor Blues hexatonic scale.
    public static let minorBluesHexatonic = ScaleType(unchecked: [.P1, .m3, .P4, .d5, .P5, .m7], name: "Minor Blues Hexatonic", category: .blues)
    /// Pelog scale.
    public static let pelog              = ScaleType(unchecked: [.P1, .m2, .m3, .d5, .m7, .M7], name: "Pelog", category: .world)

    // MARK: Octatonic / Bebop

    /// Whole-half diminished scale.
    public static let wholeDiminished     = ScaleType(unchecked: [.P1, .M2, .m3, .P4, .d5, .m6, .M6, .M7], name: "Whole Diminished", category: .symmetric)
    /// Half-whole diminished scale.
    public static let halfDiminishedScale = ScaleType(unchecked: [.P1, .m2, .m3, .M3, .d5, .P5, .M6, .m7], name: "Half Diminished Scale", aliases: ["Eight Tone Spanish", "Auxiliary Diminished Blues"], category: .symmetric)
    /// Major bebop scale.
    public static let majorBebop          = ScaleType(unchecked: [.P1, .M2, .M3, .P4, .P5, .m6, .M6, .M7], name: "Major Bebop", category: .bebop)
    /// Minor bebop scale.
    public static let minorBebop          = ScaleType(unchecked: [.P1, .M2, .m3, .P4, .P5, .M6, .m7, .M7], name: "Minor Bebop", category: .bebop)
    /// Bebop dominant scale.
    public static let bebopDominant       = ScaleType(unchecked: [.P1, .M2, .M3, .P4, .P5, .M6, .m7, .M7], name: "Bebop Dominant", category: .bebop)
    /// Ichikosucho scale.
    public static let ichikosucho        = ScaleType(unchecked: [.P1, .M2, .M3, .P4, .A4, .P5, .M6, .M7], name: "Ichikosucho", category: .world)
    /// Nine-tone scale.
    public static let nineTone           = ScaleType(unchecked: [.P1, .M2, .m3, .M3, .A4, .P5, .m6, .M6, .M7], name: "Nine Tone", category: .exotic)

    // MARK: Chromatic

    /// Chromatic scale.
    public static let chromatic          = ScaleType(unchecked: [.P1, .m2, .M2, .m3, .M3, .P4, .d5, .P5, .m6, .M6, .m7, .M7], name: "Chromatic", category: .chromatic)

    // MARK: Other diatonic / world scales (7-note)

    /// Neopolitan scale.
    public static let neopolitan         = ScaleType(unchecked: [.P1, .m2, .m3, .P4, .P5, .m6, .M7], name: "Neopolitan", category: .exotic)
    /// Neopolitan Major.
    public static let neopolitanMajor    = ScaleType(unchecked: [.P1, .m2, .m3, .P4, .P5, .M6, .M7], name: "Neopolitan Major", category: .exotic)
    /// Neopolitan Minor.
    public static let neopolitanMinor    = ScaleType(unchecked: [.P1, .m2, .m3, .P4, .P5, .m6, .m7], name: "Neopolitan Minor", category: .exotic)
    /// Persian scale.
    public static let persian            = ScaleType(unchecked: [.P1, .m2, .M3, .P4, .d5, .m6, .M7], name: "Persian", category: .world)
    /// Enigmatic scale.
    public static let enigmatic          = ScaleType(unchecked: [.P1, .m2, .M3, .A4, .A5, .A6, .M7], name: "Enigmatic", category: .exotic)
    /// Leading Whole Tone scale.
    public static let leadingWholeTone   = ScaleType(unchecked: [.P1, .M2, .M3, .A4, .A5, .M6, .m7], name: "Leading Whole Tone", category: .exotic)
    /// Hungarian Major scale.
    public static let hungarianMajor     = ScaleType(unchecked: [.P1, .m3, .M3, .A4, .P5, .M6, .m7], name: "Hungarian Major", category: .world)
    /// Hungarian Minor scale.
    public static let hungarianMinor     = ScaleType(unchecked: [.P1, .M2, .m3, .A4, .P5, .m6, .M7], name: "Hungarian Minor", aliases: ["Gypsy", "Algerian"], category: .world)
    /// Romanian Minor scale.
    public static let romanianMinor      = ScaleType(unchecked: [.P1, .M2, .m3, .A4, .P5, .M6, .m7], name: "Romanian Minor", aliases: ["Dorian #4", "Pfluke"], category: .world)
    /// Arabian scale.
    public static let arabian            = ScaleType(unchecked: [.P1, .M2, .M3, .P4, .d5, .m6, .m7], name: "Arabian", aliases: ["Major Locrian"], category: .world)
    /// Oriental scale.
    public static let oriental           = ScaleType(unchecked: [.P1, .m2, .M3, .P4, .d5, .M6, .m7], name: "Oriental", category: .world)
    /// Mohammedan scale.
    public static let mohammedan         = ScaleType(unchecked: [.P1, .M2, .m3, .P4, .P5, .m6, .M7], name: "Mohammedan", aliases: ["Algerian"], category: .world)
    /// Major Locrian scale.
    public static let majorLocrian       = ScaleType(unchecked: [.P1, .M2, .M3, .P4, .d5, .m6, .m7], name: "Major Locrian", category: .diatonic)
    /// Dominant 7th scale.
    public static let dominant7th        = ScaleType(unchecked: [.P1, .M2, .M3, .P4, .P5, .M6, .m7], name: "Dominant 7th", category: .diatonic)
    /// Purvi Theta scale.
    public static let purviTheta         = ScaleType(unchecked: [.P1, .m2, .M3, .A4, .P5, .m6, .M7], name: "Purvi Theta", category: .world)
    /// Todi Theta scale.
    public static let todiTheta          = ScaleType(unchecked: [.P1, .m2, .m3, .A4, .P5, .m6, .M7], name: "Todi Theta", category: .world)
    /// Hawaiian scale.
    public static let hawaiian           = ScaleType(unchecked: [.P1, .M2, .m3, .P4, .P5, .M6, .M7], name: "Hawaiian", category: .world)
    /// Diatonic pentatonic (W-W-3H-W-3H).
    public static let diatonic           = ScaleType(unchecked: [.P1, .M2, .M3, .P5, .M6], name: "Diatonic", category: .pentatonic)
    /// Locrian 3 scale.
    public static let locrian3           = ScaleType(unchecked: [.P1, .m2, .M3, .P4, .d5, .m6, .m7], name: "Locrian 3", category: .diatonic)
    /// Locrian 6 scale.
    public static let locrian6           = ScaleType(unchecked: [.P1, .m2, .m3, .P4, .d5, .M6, .m7], name: "Locrian 6", category: .diatonic)
    /// Lydian Minor scale.
    public static let lydianMinor        = ScaleType(unchecked: [.P1, .M2, .M3, .A4, .P5, .m6, .m7], name: "Lydian Minor", category: .exotic)
    /// Lydian b6 scale.
    public static let lydianFlat6        = ScaleType(unchecked: [.P1, .M2, .M3, .A4, .P5, .m6, .m7], name: "Lydian b6", category: .exotic)
    /// Lydian #6 scale.
    public static let lydianSharp6       = ScaleType(unchecked: [.P1, .M2, .M3, .A4, .P5, .m7, .M7], name: "Lydian #6", category: .exotic)
    /// Lydian #2 #6 scale.
    public static let lydianSharp2Sharp6 = ScaleType(unchecked: [.P1, .m3, .M3, .A4, .P5, .m7, .M7], name: "Lydian #2 #6", category: .exotic)
    /// Mixolydian Augmented scale.
    public static let mixolydianAugmented = ScaleType(unchecked: [.P1, .M2, .M3, .P4, .m6, .M6, .m7], name: "Mixolydian Augmented", category: .exotic)
    /// Locrian Diminished bb3 scale.
    public static let locrianDiminishedFlatFlat3 = ScaleType(unchecked: [.P1, .m2, .P4, .d5, .m6, .M6], name: "Locrian Diminished bb3", category: .exotic)
    /// Ionian #2 scale.
    public static let ionianSharp2       = ScaleType(unchecked: [.P1, .m3, .M3, .P4, .P5, .M6, .M7], name: "Ionian #2", category: .harmonicMajorMode)
    /// Super Locrian Diminished bb3 scale.
    public static let superLocrianDiminishedFlatFlat3 = ScaleType(unchecked: [.P1, .m2, .M2, .M3, .d5, .m6, .M6], name: "Super Locrian Diminished bb3", category: .exotic)
    /// Ionian Augmented #2 scale.
    public static let ionianAugmentedSharp2 = ScaleType(unchecked: [.P1, .m3, .M3, .P4, .m6, .M6, .M7], name: "Ionian Augmented #2", category: .harmonicMajorMode)
    /// Lydian Augmented #6 scale.
    public static let lydianAugmentedSharp6 = ScaleType(unchecked: [.P1, .M2, .M3, .A4, .m6, .m7, .M7], name: "Lydian Augmented #6", category: .melodicMinorMode)

    // MARK: All

    /// All predefined scale types.
    public static let all: [ScaleType] = [
        .major, .dorian, .phrygian, .lydian, .mixolydian, .minor, .locrian,
        .harmonicMinor, .locrianNatural6, .ionianSharp5, .dorianSharp4, .phrygianMajor,
        .lydianSharp2, .superLocrianBb7,
        .melodicMinor, .dorianFlat2, .lydianAugmented, .lydianFlat7, .mixolydianFlat6,
        .halfDiminished, .altered,
        .harmonicMajor, .dorianFlat5, .phrygianFlat4, .lydianFlat3, .mixolydianFlat2,
        .lydianAugmentedSharp2, .locrianDiminished,
        .pentatonicMajor, .pentatonicMinor, .pentatonicBlues, .pentatonicNeutral,
        .hirajoshi, .balinese, .kumoi, .iwato, .insen, .manGong, .chinese, .diatonic,
        .whole, .augmented, .tritone, .prometheus, .prometheusNeopolitan,
        .sixToneSymmetrical, .istrian, .majorBluesHexatonic, .minorBluesHexatonic, .pelog,
        .wholeDiminished, .halfDiminishedScale, .majorBebop, .minorBebop, .bebopDominant,
        .ichikosucho, .nineTone,
        .chromatic,
        .neopolitan, .neopolitanMajor, .neopolitanMinor, .persian, .enigmatic,
        .leadingWholeTone, .hungarianMajor, .hungarianMinor, .romanianMinor,
        .arabian, .oriental, .mohammedan, .majorLocrian, .dominant7th,
        .purviTheta, .todiTheta, .hawaiian, .locrian3, .locrian6,
        .lydianMinor, .lydianSharp6, .lydianSharp2Sharp6, .lydianFlat6,
        .mixolydianAugmented, .locrianDiminishedFlatFlat3, .ionianSharp2,
        .superLocrianDiminishedFlatFlat3, .ionianAugmentedSharp2,
        .lydianAugmentedSharp6,
    ]
}
