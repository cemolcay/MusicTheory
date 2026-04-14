//
//  Tempo.swift
//  MusicTheory
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

/// Defines the tempo of the music with beats per minute and a time signature.
public struct Tempo: Codable, Hashable, Equatable, CustomStringConvertible, Sendable {
    /// Time signature of the music.
    public var timeSignature: TimeSignature
    /// Beats per minute.
    public var bpm: Double

    /// Initialises tempo with a time signature and BPM.
    ///
    /// - Parameters:
    ///   - timeSignature: Time Signature.
    ///   - bpm: Beats per minute.
    public init(timeSignature: TimeSignature = TimeSignature(), bpm: Double = 120.0) {
        self.timeSignature = timeSignature
        self.bpm = bpm
    }

    // MARK: Duration

    /// Calculates the duration of a note value in seconds.
    public func duration(of noteValue: NoteValue) -> TimeInterval {
        let secondsPerBeat = 60.0 / bpm
        // Normalise: express noteValue.rate relative to one beat
        let beatRate = 1.0 / Double(timeSignature.beatUnit)
        return secondsPerBeat * (noteValue.rate / beatRate)
    }

    /// Calculates the note length in samples. Useful for sample-accurate sequencing in the DSP.
    ///
    /// - Parameters:
    ///   - noteValue: The note value whose sample length to calculate.
    ///   - sampleRate: Number of samples per second. Defaults to 44100.
    /// - Returns: The sample length of the note value.
    public func sampleLength(of noteValue: NoteValue, sampleRate: Double = 44100.0) -> Double {
        return duration(of: noteValue) * sampleRate
    }

    /// Calculates the LFO speed of a note value in hertz.
    public func hertz(of noteValue: NoteValue) -> Double {
        return 1.0 / duration(of: noteValue)
    }

    // MARK: Equatable

    public static func == (lhs: Tempo, rhs: Tempo) -> Bool {
        return lhs.bpm == rhs.bpm && lhs.timeSignature == rhs.timeSignature
    }

    // MARK: CustomStringConvertible

    public var description: String {
        return "\(bpm) BPM (\(timeSignature))"
    }
}
