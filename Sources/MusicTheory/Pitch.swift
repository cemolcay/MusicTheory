//
//  Pitch.swift
//  MusicTheory
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - Operators

/// Returns the pitch a given interval above the pitch.
public func + (lhs: Pitch, rhs: Interval) -> Pitch {
    return lhs.transposed(by: rhs)
}

/// Returns the pitch a given interval below the pitch.
public func - (lhs: Pitch, rhs: Interval) -> Pitch {
    return lhs._transposed(by: rhs, direction: .down)
}

/// Calculates the ascending interval between two pitches.
/// The result is always the interval from the lower pitch to the higher.
public func - (lhs: Pitch, rhs: Pitch) -> Interval {
    return lhs.interval(to: rhs)
}

/// Returns a pitch shifted up by a raw number of semitones (enharmonic spelling uses sharps).
public func + (pitch: Pitch, halfstep: Int) -> Pitch {
    return Pitch(midiNote: pitch.midiNoteNumber + halfstep)
}

/// Returns a pitch shifted down by a raw number of semitones.
public func - (pitch: Pitch, halfstep: Int) -> Pitch {
    return Pitch(midiNote: pitch.midiNoteNumber - halfstep)
}

// MARK: - Direction

internal enum TransposeDirection {
    case up, down
}

// MARK: - Octave helpers

/// Counts B→C crossings (each = +1 octave) when stepping `steps` diatonic letters upward from `letter`.
private func octaveDiffUp(from letter: LetterName, steps: Int) -> Int {
    var diff = 0
    var current = letter
    for _ in 0..<steps {
        let next = current.advanced(by: 1)
        if current == .b && next == .c { diff += 1 }
        current = next
    }
    return diff
}

/// Counts C→B crossings (each = −1 octave) when stepping `steps` diatonic letters downward from `letter`.
private func octaveDiffDown(from letter: LetterName, steps: Int) -> Int {
    var diff = 0
    var current = letter
    for _ in 0..<steps {
        let next = current.advanced(by: -1)
        if current == .c && next == .b { diff -= 1 }
        current = next
    }
    return diff
}

// MARK: - Pitch

/// A pitched note: a `NoteName` (letter + accidental) combined with an octave number.
///
/// **Equality is structural.** C#4 ≠ Db4. Use `isEnharmonic(with:)` for sound-based comparison.
///
/// The `midiNoteNumber` follows the standard MIDI convention where middle C (C4) = 60.
public struct Pitch: RawRepresentable, Codable, Hashable, Comparable,
    ExpressibleByIntegerLiteral, ExpressibleByStringLiteral, CustomStringConvertible, Sendable {

    // MARK: Stored properties

    /// The note name (letter + accidental).
    public var noteName: NoteName

    /// The octave number (middle C is octave 4).
    public var octave: Int

    // MARK: Initializers

    public init(noteName: NoteName, octave: Int) {
        self.noteName = noteName
        self.octave = octave
    }

    /// Creates a pitch from a MIDI note number.
    /// - Parameters:
    ///   - midiNote: The MIDI note number (0–127; values outside this range are supported for theory purposes).
    ///   - spelling: Whether to prefer sharps or flats when the note is not a natural. Defaults to sharps.
    public init(midiNote: Int, spelling: SpellingPreference = .sharps) {
        let octaveVal = (midiNote / 12) - 1
        let pitchClass = ((midiNote % 12) + 12) % 12
        let chromatic = NoteName.chromatic(preferring: spelling)
        // chromatic arrays are indexed by pitch class
        let noteName = chromatic.first(where: { $0.pitchClass == pitchClass }) ?? NoteName(letter: .c, accidental: .natural)
        self.noteName = noteName
        self.octave = octaveVal
    }

    // MARK: RawRepresentable  (MIDI note number)

    public typealias RawValue = Int

    /// The MIDI note number. Middle C (C4) = 60.
    public var rawValue: Int { midiNoteNumber }

    public init?(rawValue: Int) {
        self = Pitch(midiNote: rawValue)
    }

    // MARK: Computed

    /// The MIDI note number. Equivalent to `rawValue`.
    public var midiNoteNumber: Int {
        let semitones = noteName.letter.semitonesFromC + noteName.accidental.semitones
        return semitones + (octave + 1) * 12
    }

    /// Frequency in Hz using equal temperament.
    /// - Parameter a4: The reference frequency for A4. Defaults to 440 Hz.
    public func frequency(a4: Double = 440.0) -> Double {
        return a4 * pow(2.0, Double(midiNoteNumber - 69) / 12.0)
    }

    /// Returns true if this pitch and `other` sound the same (same MIDI note number).
    public func isEnharmonic(with other: Pitch) -> Bool {
        return midiNoteNumber == other.midiNoteNumber
    }

    // MARK: Transposition

    /// Returns a new pitch transposed upward by the given interval.
    /// The result is correctly spelled: degree advances by `interval.degree - 1` diatonic steps,
    /// and the accidental is adjusted to hit the exact semitone target.
    public func transposed(by interval: Interval) -> Pitch {
        return _transposed(by: interval, direction: .up)
    }

    internal func _transposed(by interval: Interval, direction: TransposeDirection) -> Pitch {
        let steps = interval.degree - 1
        let targetLetter: LetterName
        let octaveChange: Int
        let targetMIDI: Int

        switch direction {
        case .up:
            targetLetter = noteName.letter.advanced(by: steps)
            octaveChange = octaveDiffUp(from: noteName.letter, steps: steps)
            targetMIDI = midiNoteNumber + interval.semitones
        case .down:
            targetLetter = noteName.letter.advanced(by: -steps)
            octaveChange = octaveDiffDown(from: noteName.letter, steps: steps)
            targetMIDI = midiNoteNumber - interval.semitones
        }

        let targetOctave = octave + octaveChange
        // Build a "natural" pitch at the target letter/octave, then derive the accidental
        let naturalPitch = Pitch(noteName: NoteName(letter: targetLetter, accidental: .natural), octave: targetOctave)
        let accidentalOffset = targetMIDI - naturalPitch.midiNoteNumber
        let targetNoteName = NoteName(letter: targetLetter, accidental: Accidental(semitones: accidentalOffset))
        return Pitch(noteName: targetNoteName, octave: targetOctave)
    }

    /// Calculates the ascending interval from this pitch to `other`.
    /// The degree accounts for octave spans via absolute diatonic indexing,
    /// correctly handling cases like B→C (= a 2nd, not a 7th).
    public func interval(to other: Pitch) -> Interval {
        let top    = midiNoteNumber >= other.midiNoteNumber ? self : other
        let bottom = midiNoteNumber <  other.midiNoteNumber ? self : other
        let semitonesDiff = top.midiNoteNumber - bottom.midiNoteNumber

        // Absolute diatonic index: letter position + octave * 7
        let bottomIdx = bottom.noteName.letter.rawValue + bottom.octave * 7
        let topIdx    = top.noteName.letter.rawValue    + top.octave    * 7
        let degree    = topIdx - bottomIdx + 1

        return Interval(semitones: semitonesDiff, degree: max(degree, 1))
            ?? Interval(unchecked: .perfect, degree: 1)
    }

    // MARK: Nearest pitch from frequency

    /// Returns the nearest pitch to the given frequency.
    /// - Parameters:
    ///   - frequency: Frequency in Hz.
    ///   - a4: Reference frequency for A4. Defaults to 440 Hz.
    ///   - spelling: Preferred accidental spelling. Defaults to sharps.
    public static func nearest(
        frequency: Double,
        a4: Double = 440.0,
        spelling: SpellingPreference = .sharps
    ) -> Pitch {
        // Convert frequency to nearest MIDI note
        let midi = Int((12.0 * log2(frequency / a4) + 69.0).rounded())
        return Pitch(midiNote: midi, spelling: spelling)
    }

    // MARK: ExpressibleByIntegerLiteral

    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: Int) {
        self = Pitch(midiNote: value)
    }

    // MARK: ExpressibleByStringLiteral

    public typealias StringLiteralType = String

    /// Creates a pitch from a string like `"C#4"`, `"Bb3"`, `"F♯-1"`.
    public init(stringLiteral value: String) {
        var letter: LetterName = .c
        var accidental: Accidental = .natural
        var octave = 0
        let pattern = "([A-Ga-g])([#♯♭b]*)(-?)(\\d+)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        if let regex,
           let match = regex.firstMatch(in: value, options: [], range: NSRange(0..<value.count)),
           let letterRange     = Range(match.range(at: 1), in: value),
           let accRange        = Range(match.range(at: 2), in: value),
           let signRange       = Range(match.range(at: 3), in: value),
           let octaveRange     = Range(match.range(at: 4), in: value),
           match.numberOfRanges == 5 {
            letter     = LetterName(stringLiteral: String(value[letterRange]))
            accidental = Accidental(stringLiteral: String(value[accRange]))
            let sign   = String(value[signRange])
            octave     = (Int(String(value[octaveRange])) ?? 0) * (sign == "-" ? -1 : 1)
        }
        self = Pitch(noteName: NoteName(letter: letter, accidental: accidental), octave: octave)
    }

    // MARK: Equatable

    /// Structural equality: C#4 ≠ Db4. Use `isEnharmonic(with:)` for sound-based comparison.
    /// Explicitly defined to override the `RawRepresentable` default that compares MIDI numbers.
    public static func == (lhs: Pitch, rhs: Pitch) -> Bool {
        return lhs.noteName == rhs.noteName && lhs.octave == rhs.octave
    }

    // MARK: Comparable

    public static func < (lhs: Pitch, rhs: Pitch) -> Bool {
        return lhs.midiNoteNumber < rhs.midiNoteNumber
    }

    // MARK: CustomStringConvertible

    public var description: String {
        return "\(noteName)\(octave)"
    }
}

// MARK: - Array circular subscript

extension Array {
    /// Returns the element at a circular (wrapping) index.
    subscript(circular index: Int) -> Element? {
        guard count > 0 else { return nil }
        let mod = index % count
        let offset = index >= 0 ? 0 : count
        let idx = mod == 0 ? 0 : mod + offset
        return self[idx]
    }
}
