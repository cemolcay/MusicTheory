//
//  ChordRecognition.swift
//  MusicTheory
//
//  Created by Cem Olcay on 2025.
//  Copyright © 2025 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - ChordIdentification

/// The result of attempting to identify a chord from a set of notes or MIDI values.
public struct ChordIdentification: CustomStringConvertible, Sendable {

    /// The identified chord.
    public let chord: Chord

    /// Confidence score from 0.0 to 1.0 (1.0 = exact match, no omissions).
    public let confidence: Double

    /// Human-readable notes about what assumptions were made.
    public let assumptions: [String]

    public var description: String {
        let assumptionStr = assumptions.isEmpty ? "" : " (\(assumptions.joined(separator: ", ")))"
        return String(format: "%@ [%.0f%%]%@", chord.notation, confidence * 100, assumptionStr)
    }
}

// MARK: - Chord Recognition

extension ChordType {

    // MARK: From NoteName array

    /// Attempts to identify all possible chords from the given note names.
    ///
    /// Tries every note as the potential root, computes intervals to the remaining
    /// notes, and scores the match against known chord types. Results are sorted
    /// by confidence (highest first).
    ///
    /// - Parameter noteNames: An unordered collection of note names.
    /// - Returns: An array of `ChordIdentification` values sorted by confidence.
    public static func identify(noteNames: [NoteName]) -> [ChordIdentification] {
        guard noteNames.count >= 2 else { return [] }
        let unique = Array(Set(noteNames)).sorted()
        var results: [ChordIdentification] = []

        for root in unique {
            let others = unique.filter { $0 != root }
            let intervals: [Interval] = [.P1] + others.compactMap { note in
                intervalFrom(root: root, to: note)
            }
            results += identifyCandidates(root: root, intervals: intervals)
        }

        let ranked = results.sorted {
            if $0.confidence != $1.confidence { return $0.confidence > $1.confidence }
            return $0.chord.notation < $1.chord.notation
        }

        // Remove duplicates after ranking so the best-scoring canonical spelling wins.
        var seen = Set<String>()
        return ranked.filter { seen.insert($0.chord.notation).inserted }
    }

    // MARK: From MIDI notes

    /// Attempts to identify all possible chords from the given MIDI note numbers.
    ///
    /// Each MIDI note is spelled as a `NoteName` using sharps (the preferred default),
    /// then identification proceeds as with `identify(noteNames:)`.
    ///
    /// - Parameters:
    ///   - midiNotes: An array of MIDI note numbers (0–127).
    ///   - spelling: Preferred spelling for enharmonic notes (default `.sharps`).
    /// - Returns: An array of `ChordIdentification` values sorted by confidence.
    public static func identify(midiNotes: [Int],
                                spelling: SpellingPreference = .sharps) -> [ChordIdentification] {
        let noteNames = midiNotes.map { Pitch(midiNote: $0, spelling: spelling).noteName }
        return identify(noteNames: noteNames)
    }

    // MARK: Private helpers

    /// Computes the ascending interval from `root` to `note` within one octave,
    /// choosing the enharmonic spelling that matches `note`'s letter.
    private static func intervalFrom(root: NoteName, to note: NoteName) -> Interval? {
        let degreeRaw = root.letter.diatonicDistance(to: note.letter)
        let degree = degreeRaw == 0 ? 7 : degreeRaw  // unison is handled by P1 already; wrap 0→7 for octave
        // We want non-unison degrees (2–7) only; root (P1) is already in the array
        let actualDegree = degreeRaw == 0 ? 8 : degreeRaw + 1  // degree in 1-based interval terms

        let semitones = ((note.pitchClass - root.pitchClass) % 12 + 12) % 12
        // For unison-semitone notes (e.g., C and B# sharing root octave) treat as octave up
        let normalizedSemitones = semitones == 0 && degree != 0 ? 12 : semitones

        return Interval(semitones: normalizedSemitones, degree: actualDegree)
    }

    /// Given a root and a set of intervals, generates all scored chord candidates,
    /// including versions with omitted fifth.
    private static func identifyCandidates(root: NoteName,
                                           intervals: [Interval]) -> [ChordIdentification] {
        var results: [ChordIdentification] = []

        // Exact match
        if case .success(let ct) = ChordType.from(intervals: intervals) {
            let chord = Chord(type: ct, root: root)
            results.append(ChordIdentification(chord: chord, confidence: 1.0, assumptions: []))
        }

        // Try dropping the fifth (P5) — common in extended / jazz voicings
        let withoutFifth = intervals.filter { $0 != .P5 }
        if withoutFifth.count < intervals.count,
           case .success(let ct) = ChordType.from(intervals: withoutFifth) {
            let chord = Chord(type: ct, root: root)
            results.append(ChordIdentification(chord: chord, confidence: 0.9,
                                               assumptions: ["omitted 5th"]))
        }

        // Try enharmonic reinterpretation of each non-root note
        for i in 1..<intervals.count {
            var reinterpreted = intervals
            let original = intervals[i]
            // shift by 1 semitone in either direction and find a matching interval at adj degree
            for delta in [-1, 1] {
                let newSemitones = original.semitones + delta
                guard newSemitones > 0 else { continue }
                // Try same degree first, then adjacent
                for degAdj in [0, delta] {
                    let newDegree = original.degree + degAdj
                    guard newDegree >= 1 else { continue }
                    if let adj = Interval(semitones: newSemitones, degree: newDegree) {
                        reinterpreted[i] = adj
                        if case .success(let ct) = ChordType.from(intervals: reinterpreted) {
                            let chord = Chord(type: ct, root: root)
                            results.append(ChordIdentification(chord: chord, confidence: 0.75,
                                                               assumptions: ["enharmonic reinterpretation"]))
                        }
                        reinterpreted[i] = original
                    }
                }
            }
        }

        return results
    }
}

// MARK: - Convenience on Chord

extension Chord {

    /// Returns all chord identifications for this chord's note names,
    /// sorted by confidence.
    public static func identify(noteNames: [NoteName]) -> [ChordIdentification] {
        return ChordType.identify(noteNames: noteNames)
    }

    /// Returns all chord identifications for the given MIDI notes, sorted by confidence.
    public static func identify(midiNotes: [Int],
                                spelling: SpellingPreference = .sharps) -> [ChordIdentification] {
        return ChordType.identify(midiNotes: midiNotes, spelling: spelling)
    }
}
