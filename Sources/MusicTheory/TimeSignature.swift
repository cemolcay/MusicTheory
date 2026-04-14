//
//  TimeSignature.swift
//  MusicTheory iOS
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

/// Defines how many beats are in each measure and what note value receives one beat.
public struct TimeSignature: Codable, Hashable, CustomStringConvertible, Sendable {
    /// Beats per measure (numerator).
    public var beats: Int
    /// The note value that receives one beat (denominator) — e.g. 4 for quarter note, 8 for eighth.
    public var beatUnit: Int

    /// Initialises the time signature.
    ///
    /// - Parameters:
    ///   - beats: Number of beats in a measure.
    ///   - beatUnit: Note value that gets one beat (4 = quarter, 8 = eighth, etc.).
    public init(beats: Int = 4, beatUnit: Int = 4) {
        self.beats = beats
        self.beatUnit = beatUnit
    }

    /// Convenience initialiser accepting a `NoteValueType` for the beat unit.
    ///
    /// - Parameters:
    ///   - beats: Number of beats in a measure.
    ///   - noteValue: Note value type that gets one beat.
    public init(beats: Int, noteValue: NoteValueType) {
        self.beats = beats
        // Rate is a fraction of a whole note: quarter = 0.25 → denominator = 4
        self.beatUnit = Int(round(1.0 / noteValue.rate))
    }

    /// The `NoteValueType` corresponding to `beatUnit`.
    public var noteValue: NoteValueType {
        let rate = 1.0 / Double(beatUnit)
        return NoteValueType.all.first { $0.rate == rate }
            ?? NoteValueType(rate: rate, description: "1/\(beatUnit)")
    }

    /// Returns `true` for compound meters (beats divisible by 3 and beats > 3),
    /// e.g. 6/8, 9/8, 12/8.
    public var isCompound: Bool {
        return beats > 3 && beats % 3 == 0
    }

    // MARK: CustomStringConvertible

    public var description: String {
        return "\(beats)/\(beatUnit)"
    }
}
