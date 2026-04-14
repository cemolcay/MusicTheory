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
