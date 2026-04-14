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

    /// The root note of the scale.
    public var root: NoteName

    /// Intervals from the root used to build this scale.
    public var intervals: [Interval]

    /// Optional display name for the scale.
    public var name: String?

    // MARK: Initializers

    public init(type: ScaleType, key: NoteName) {
        self.root = key
        self.intervals = type.intervals
        self.name = type.name
    }

    /// Convenience initialiser using the `root` label.
    public init(type: ScaleType, root: NoteName) {
        self.root = root
        self.intervals = type.intervals
        self.name = type.name
    }

    /// Creates a scale directly from intervals, without requiring a predefined scale type.
    public init(intervals: [Interval], root: NoteName, name: String? = nil) {
        self.root = root
        self.intervals = intervals
        self.name = name
    }

    // MARK: Correctly-spelled note names

    /// Returns the note names of the scale with correct enharmonic spelling:
    /// each scale degree uses a different letter, and the accidental is computed
    /// to hit the exact required pitch class.
    ///
    /// For example, D major → [D, E, F♯, G, A, B, C♯] (not [D, E, G♭, G, A, B, D♭]).
    public var noteNames: [NoteName] {
        return intervals.map { interval in
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
            result += intervals.map { rootPitch + $0 }
        }
        return result
    }

    // MARK: Degree lookup

    /// Returns the 1-based scale degree for the given note name, or `nil` if not in scale.
    public func degree(of noteName: NoteName) -> Int? {
        return noteNames.firstIndex(of: noteName).map { $0 + 1 }
    }

    /// Returns a lightweight scale type using this scale's intervals and name.
    public var type: ScaleType {
        return ScaleType(intervals: intervals, name: name ?? "Custom Scale")
    }

    // MARK: Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(root)
        hasher.combine(intervals)
        hasher.combine(name)
    }

    // MARK: Equatable

    public static func == (lhs: Scale, rhs: Scale) -> Bool {
        return lhs.root == rhs.root && lhs.intervals == rhs.intervals && lhs.name == rhs.name
    }

    // MARK: CustomStringConvertible

    public var description: String {
        let noteStr = noteNames.map { $0.description }.joined(separator: ", ")
        let scaleName = name ?? "Custom Scale"
        return "\(root) \(scaleName): \(noteStr)"
    }
}
