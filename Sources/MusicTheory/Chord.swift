//
//  Chord.swift
//  MusicTheory
//
//  Created by Cem Olcay on 22.10.2017.
//  Copyright © 2017 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - Chord

/// A chord: a `ChordType` rooted on a `NoteName`.
///
/// Supports slash chords via the optional `bass` note.
public struct Chord: Hashable, Codable, CustomStringConvertible, Sendable {

    // MARK: Stored properties

    /// The quality of the chord.
    public let type: ChordType

    /// The root note (the note from which intervals are measured).
    public let root: NoteName

    /// The bass note for slash chords (e.g., C/E). `nil` means root is in the bass.
    public var bass: NoteName?

    /// Inversion index (0 = root position, 1 = first inversion, etc.).
    public var inversion: Int

    // MARK: Initializers

    public init(type: ChordType, root: NoteName, bass: NoteName? = nil, inversion: Int = 0) {
        self.type = type
        self.root = root
        self.bass = bass
        self.inversion = inversion
    }

    // MARK: Note names

    /// Returns the note names of the chord in root position (no inversion applied).
    public var noteNames: [NoteName] {
        return type.intervals.map { interval in
            let targetLetter = root.letter.advanced(by: interval.degree - 1)
            let targetPC = (root.pitchClass + interval.semitones) % 12
            let naturalPC = targetLetter.semitonesFromC
            var diff = targetPC - naturalPC
            while diff > 6  { diff -= 12 }
            while diff < -6 { diff += 12 }
            return NoteName(letter: targetLetter, accidental: Accidental(semitones: diff))
        }
    }

    // MARK: Inversions

    /// All inversions of this chord.
    public var inversions: [Chord] {
        return (0..<noteNames.count).map {
            Chord(type: type, root: root, bass: bass, inversion: $0)
        }
    }

    // MARK: Pitch generation

    /// Returns pitches of the chord in the given octave, applying the current inversion.
    public func pitches(octave: Int) -> [Pitch] {
        var intervals = type.intervals
        for _ in 0..<inversion {
            intervals = intervals.shifted
        }
        let rootPitch = Pitch(noteName: root, octave: octave)
        let invertedPitches = intervals.map { rootPitch + $0 }
        // Pitches that were shifted (inverted) go up an octave
        return invertedPitches.enumerated().map { index, pitch in
            index < type.intervals.count - inversion
                ? pitch
                : Pitch(noteName: pitch.noteName, octave: pitch.octave + 1)
        }
    }

    /// Returns pitches across multiple octaves, sorted ascending.
    public func pitches(octaves: [Int]) -> [Pitch] {
        return octaves.flatMap { pitches(octave: $0) }.sorted()
    }

    // MARK: Notation

    /// Standard chord symbol notation (e.g. "Cm7", "F♯dim", "G/B").
    /// Major chords use just the root letter ("C"), not "CM".
    public var notation: String {
        let sym = type.symbol == "M" ? "" : type.symbol
        var n = "\(root)\(sym)"
        if let bass { n += "/\(bass)" }
        else if inversion > 0, let inv = noteNames[safe: inversion] {
            n += "/\(inv)"
        }
        return n
    }

    // MARK: CustomStringConvertible

    public var description: String {
        let inv = inversion > 0 ? " (\(inversion). inversion)" : ""
        return "\(root) \(type.fullName)\(inv)"
    }
}

// MARK: - Array helpers

extension Array {
    internal var shifted: Array {
        guard let first = first else { return self }
        var arr = self
        arr.removeFirst()
        arr.append(first)
        return arr
    }

    internal subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}
