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

/// Checks the equability between two `Scale`s by their base key and notes.
///
/// - Parameters:
///   - left: Left handside of the equation.
///   - right: Right handside of the equation.
/// - Returns: Returns Bool value of equation of two given scales.
public func == (left: Scale, right: Scale) -> Bool {
    return left.key == right.key && left.type == right.type
}

/// Scale object with `ScaleType` and scale's key of `NoteType`.
/// Could calculate note sequences in [Note] format.
public struct Scale: Hashable, Codable {
    /// Type of the scale that has `interval` info.
    public var type: ScaleType
    /// Root key of the scale that will built onto.
    public var key: Key
    
    /// Initilizes the scale with its type and key.
    ///
    /// - Parameters:
    ///   - type: Type of scale being initilized.
    ///   - key: Key of scale being initilized.
    public init(type: ScaleType, key: Key) {
        self.type = type
        self.key = key
    }
    
    /// Keys generated by the intervals of the scale.
    public var keys: [Key] {
        return pitches(octave: 1).map({ $0.key })
    }
    
    /// Generates `Pitch` array of scale in given octave.
    ///
    /// - Parameter octave: Octave value of notes in scale.
    /// - Returns: Returns `Pitch` array of the scale in given octave.
    public func pitches(octave: Int) -> [Pitch] {
        return pitches(octaves: octave)
    }
    
    /// Generates `Pitch` array of scale in given octaves.
    ///
    /// - Parameter octaves: Variadic value of octaves to generate pitches in scale.
    /// - Returns: Returns `Pitch` array of the scale in given octaves.
    public func pitches(octaves: Int...) -> [Pitch] {
        return pitches(octaves: octaves)
    }
    
    /// Generates `Pitch` array of scale in given octaves.
    ///
    /// - Parameter octaves: Array value of octaves to generate pitches in scale.
    /// - Returns: Returns `Pitch` array of the scale in given octaves.
    public func pitches(octaves: [Int]) -> [Pitch] {
        var pitches = [Pitch]()
        octaves.forEach({ octave in
            let root = Pitch(key: key, octave: octave)
            pitches += type.intervals.map({ root + $0 })
        })
        return pitches
    }
    
    // MARK: Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(type)
    }
}

extension Scale {
    /// Stack of notes to generate chords for each note in the scale.
    public enum HarmonicField: Int, Codable {
        /// First, third and fifth degree notes builds a triad chord.
        case triad
        /// First, third, fifth and seventh notes builds a tetrad chord.
        case tetrad
        /// First, third, fifth, seventh and ninth notes builds a 9th chord.
        case ninth
        /// First, third, fifth, seventh, ninth and eleventh notes builds a 11th chord.
        case eleventh
        /// First, third, fifth, seventh, ninth, eleventh and thirteenth notes builds a 13th chord.
        case thirteenth
        
        /// All possible harmonic fields constructed from.
        public static let all: [HarmonicField] = [.triad, .tetrad, .ninth, .eleventh, .thirteenth]
    }
    
    /// Generates chords for harmonic field of scale.
    ///
    /// - Parameter field: Type of chords you want to generate.
    /// - Parameter inversion: Inversion degree of the chords. Defaults 0.
    /// - Returns: Returns triads or tetrads of chord for each note in scale.
    public func harmonicField(for field: HarmonicField, inversion: Int = 0) -> [Chord?] {
        var chords = [Chord?]()
        
        // Extended notes for picking notes.
        let octaves = [0, 1, 2, 3, 4]
        let scalePitches = pitches(octaves: octaves)
        
        // Build chords for each note in scale.
        for i in 0 ..< scalePitches.count / octaves.count {
            var chordPitches = [Pitch]()
            switch field {
            case .triad:
                chordPitches = [scalePitches[i], scalePitches[i + 2], scalePitches[i + 4]]
            case .tetrad:
                chordPitches = [scalePitches[i], scalePitches[i + 2], scalePitches[i + 4], scalePitches[i + 6]]
            case .ninth:
                chordPitches = [scalePitches[i], scalePitches[i + 2], scalePitches[i + 4], scalePitches[i + 6], scalePitches[i + 8]]
            case .eleventh:
                chordPitches = [scalePitches[i], scalePitches[i + 2], scalePitches[i + 4], scalePitches[i + 6], scalePitches[i + 8], scalePitches[i + 10]]
            case .thirteenth:
                chordPitches = [scalePitches[i], scalePitches[i + 2], scalePitches[i + 4], scalePitches[i + 6], scalePitches[i + 8], scalePitches[i + 10], scalePitches[i + 12]]
            }
            
            // Build intervals
            let root = chordPitches[0]
            let intervals = chordPitches.map({ $0 - root })
            
            // Build chord
            if let chordType = ChordType(intervals: intervals) {
                let chord = Chord(type: chordType, key: root.key, inversion: inversion)
                chords.append(chord)
            } else {
                chords.append(nil)
            }
        }
        
        return chords
    }
}

extension Scale: CustomStringConvertible {
    /// Converts `Scale` to string with its key and type.
    public var description: String {
        return "\(key) \(type): " + keys.map({ "\($0)" }).joined(separator: ", ")
    }
}
