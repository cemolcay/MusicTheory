//
//  Scale.swift
//  MusicTheory
//
//  Created by Cem Olcay on 24.10.2017.
//  Copyright © 2017 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - HarmonicFieldEntry

/// One entry in a scale's harmonic field: the chord for a given scale degree,
/// along with the raw stacked intervals (always populated even when the chord
/// cannot be identified).
public struct HarmonicFieldEntry: CustomStringConvertible, Sendable {
    /// 1-based scale degree this entry corresponds to.
    public let degree: Int
    /// The chord built on this degree, or `nil` if the intervals don't match any known chord type.
    public let chord: Chord?
    /// The intervals from the root of this chord to each stacked note (includes `.P1`).
    public let intervals: [Interval]

    public var description: String {
        if let chord { return "Degree \(degree): \(chord)" }
        let intStr = intervals.map(\.notation).joined(separator: " ")
        return "Degree \(degree): [\(intStr)]"
    }
}

// MARK: - Scale

/// A musical scale: a `ScaleType` (interval pattern) anchored to a root `NoteName`.
public struct Scale: Hashable, Codable, CustomStringConvertible, Sendable {

    // MARK: Stored properties

    /// The interval pattern of the scale.
    public var type: ScaleType

    /// The root note of the scale.
    public var root: NoteName

    // MARK: Initializers

    public init(type: ScaleType, key: NoteName) {
        self.type = type
        self.root = key
    }

    /// Convenience initialiser using the `root` label.
    public init(type: ScaleType, root: NoteName) {
        self.type = type
        self.root = root
    }

    // MARK: Correctly-spelled note names

    /// Returns the note names of the scale with correct enharmonic spelling:
    /// each scale degree uses a different letter, and the accidental is computed
    /// to hit the exact required pitch class.
    ///
    /// For example, D major → [D, E, F♯, G, A, B, C♯] (not [D, E, G♭, G, A, B, D♭]).
    public var noteNames: [NoteName] {
        return type.intervals.map { interval in
            spelledNoteName(for: interval)
        }
    }

    private func spelledNoteName(for interval: Interval) -> NoteName {
        let targetLetter = root.letter.advanced(by: interval.degree - 1)
        let targetPitchClass = (root.pitchClass + interval.semitones) % 12
        let naturalPC = targetLetter.semitonesFromC
        var diff = targetPitchClass - naturalPC
        // Normalise to -6..+6 to prefer simpler accidentals
        while diff > 6  { diff -= 12 }
        while diff < -6 { diff += 12 }
        return NoteName(letter: targetLetter, accidental: Accidental(semitones: diff))
    }

    // MARK: Pitch generation

    /// Returns pitches of the scale in the given octave.
    /// Notes are correctly spelled (one letter per degree).
    public func pitches(in octave: Int) -> [Pitch] {
        return pitches(octaves: [octave])
    }

    /// Returns pitches of the scale in a closed octave range.
    public func pitches(octaves: ClosedRange<Int>) -> [Pitch] {
        return pitches(octaves: Array(octaves))
    }

    /// Returns pitches of the scale in the given octaves (variadic).
    public func pitches(octave: Int) -> [Pitch] {
        return pitches(octaves: [octave])
    }

    /// Returns pitches of the scale in the given octaves (variadic convenience).
    public func pitches(octaves: Int...) -> [Pitch] {
        return pitches(octaves: octaves)
    }

    /// Returns pitches of the scale across the given array of octaves.
    public func pitches(octaves: [Int]) -> [Pitch] {
        var result = [Pitch]()
        for octave in octaves {
            let rootPitch = Pitch(noteName: root, octave: octave)
            result += type.intervals.map { rootPitch + $0 }
        }
        return result
    }

    // MARK: Degree lookup

    /// Returns the 1-based scale degree for the given note name, or `nil` if not in scale.
    public func degree(of noteName: NoteName) -> Int? {
        return noteNames.firstIndex(of: noteName).map { $0 + 1 }
    }

    // MARK: Modes

    /// Returns the Nth mode of this scale (1-indexed). Preserves the root's octave context.
    public func mode(_ degree: Int) -> Scale? {
        guard let modeType = type.mode(degree) else { return nil }
        let modeRoot = noteNames[safe: degree - 1] ?? root
        return Scale(type: modeType, root: modeRoot)
    }

    // MARK: Relative / parallel

    /// The relative major scale (shares the same notes but starts on the 6th degree of minor, or 3rd of major).
    public var relativeMajor: Scale? {
        guard type == .minor else { return nil }
        guard let noteAtDegree3 = noteNames[safe: 2] else { return nil }
        return Scale(type: .major, root: noteAtDegree3)
    }

    /// The relative minor scale.
    public var relativeMinor: Scale? {
        guard type == .major else { return nil }
        guard let noteAtDegree6 = noteNames[safe: 5] else { return nil }
        return Scale(type: .minor, root: noteAtDegree6)
    }

    /// The parallel major (same root, major scale type).
    public var parallelMajor: Scale { Scale(type: .major, root: root) }

    /// The parallel minor (same root, minor scale type).
    public var parallelMinor: Scale { Scale(type: .minor, root: root) }

    // MARK: Harmonic field

    /// Stack of notes used to build chords for each scale degree.
    public enum HarmonicFieldType: Int, Codable, CaseIterable, Sendable {
        /// Triads: 1st, 3rd, 5th.
        case triad
        /// Seventh chords: 1st, 3rd, 5th, 7th.
        case seventh
        /// Ninth chords: 1st, 3rd, 5th, 7th, 9th.
        case ninth
        /// Eleventh chords: 1st, 3rd, 5th, 7th, 9th, 11th.
        case eleventh
        /// Thirteenth chords: 1st, 3rd, 5th, 7th, 9th, 11th, 13th.
        case thirteenth

        /// Number of stacked notes for this field type.
        public var stackSize: Int {
            switch self {
            case .triad:       return 3
            case .seventh:     return 4
            case .ninth:       return 5
            case .eleventh:    return 6
            case .thirteenth:  return 7
            }
        }

        // MARK: - Backward-compatible HarmonicField typealiases

        public static let tetrad = HarmonicFieldType.seventh
    }

    // MARK: - Backward-compat HarmonicField alias

    public typealias HarmonicField = HarmonicFieldType

    /// Generates the harmonic field for the scale: one `HarmonicFieldEntry` per scale degree.
    ///
    /// Uses tercian stacking (every other scale note). For non-heptatonic scales the
    /// same "skip-one" rule applies using available scale degrees.
    ///
    /// Unlike the old API, this method never silently discards information: even when
    /// the intervals don't match a known `ChordType`, the `intervals` field is populated.
    public func harmonicField(for field: HarmonicFieldType, inversion: Int = 0) -> [HarmonicFieldEntry] {
        let octaves = [0, 1, 2, 3, 4]
        let scalePitches = pitches(octaves: octaves)
        let noteCount = type.cardinality
        var entries = [HarmonicFieldEntry]()

        for i in 0..<noteCount {
            var chordPitches = [Pitch]()
            for stack in 0..<field.stackSize {
                let idx = i + stack * 2
                guard idx < scalePitches.count else { break }
                chordPitches.append(scalePitches[idx])
            }
            guard !chordPitches.isEmpty else { continue }

            let rootPitch = chordPitches[0]
            let intervals = chordPitches.map { rootPitch.interval(to: $0) }

            let chordResult = ChordType.from(intervals: intervals)
            let chord: Chord?
            switch chordResult {
            case .success(let chordType):
                var c = Chord(type: chordType, root: rootPitch.noteName)
                c.inversion = inversion
                chord = c
            case .failure:
                chord = nil
            }

            entries.append(HarmonicFieldEntry(degree: i + 1, chord: chord, intervals: intervals))
        }
        return entries
    }

    // MARK: Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(root)
        hasher.combine(type)
    }

    // MARK: Equatable

    public static func == (lhs: Scale, rhs: Scale) -> Bool {
        return lhs.root == rhs.root && lhs.type == rhs.type
    }

    // MARK: CustomStringConvertible

    public var description: String {
        let noteStr = noteNames.map { $0.description }.joined(separator: ", ")
        return "\(root) \(type): \(noteStr)"
    }
}

