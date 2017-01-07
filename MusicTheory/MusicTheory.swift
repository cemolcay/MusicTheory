//
//  MusicTheory.swift
//  MusicTheory
//
//  Created by Cem Olcay on 29/12/2016.
//  Copyright © 2016 prototapp. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - NoteType

/// Calculates the `NoteType` above `Interval`
///
/// - Parameters:
///   - noteType: The note type being added interval.
///   - interval: Interval above.
/// - Returns: Returns `NoteType` above interval
public func +(noteType: NoteType, interval: Interval) -> NoteType {
  return NoteType(midiNote: noteType.rawValue + interval.halfstep)!
}

/// Calculates the `NoteType` above halfsteps.
///
/// - Parameters:
///   - noteType: The note type being added halfsteps.
///   - halfstep: Halfsteps above
/// - Returns: Returns `NoteType` above halfsteps
public func +(noteType: NoteType, halfstep: Int) -> NoteType {
  return NoteType(midiNote: noteType.rawValue + halfstep)!
}

/// Calculates the `NoteType` below `Interval`
///
/// - Parameters:
///   - noteType: The note type being calculated.
///   - interval: Interval below.
/// - Returns: Returns `NoteType` below interval.
public func -(noteType: NoteType, interval: Interval) -> NoteType {
  return NoteType(midiNote: noteType.rawValue - interval.halfstep)!
}

/// Calculates the `NoteType` below halfsteps
///
/// - Parameters:
///   - noteType: The note type being calculated.
///   - halfstep: Halfsteps below.
/// - Returns: Returns `NoteType` below halfsteps.
public func -(noteType: NoteType, halfstep: Int) -> NoteType {
  return NoteType(midiNote: noteType.rawValue - halfstep)!
}

/// Represents 12 base notes in music.
/// C, D, E, F, G, A, B with their flats.
/// Raw values are included for easier calculation based on midi notes.
public enum NoteType: Int {
  case c = 0
  case dFlat
  case d
  case eFlat
  case e
  case f
  case gFlat
  case g
  case aFlat
  case a
  case bFlat
  case b

  /// All the notes in static array
  public static let all: [NoteType] = [
    .c, .dFlat, .d, .eFlat, .e, .f,
    .gFlat, .g, .aFlat, .a, .bFlat, .b
  ]

  /// Initilizes the note type with midiNote.
  ///
  /// - parameters:
  ///  - midiNote: The midi note value wanted to be converted to `NoteType`.
  public init?(midiNote: Int) {
    let octave = (midiNote / 12) - (midiNote < 0 ? 1 : 0)
    let raw = octave > 0 ? midiNote - (octave * 12) : midiNote - ((octave + 1) * 12) + 12
    guard let note = NoteType(rawValue: raw) else { return nil }
    self = note
  }
}

extension NoteType: CustomStringConvertible {

  public var description: String {
    switch self {
    case .c: return "C"
    case .dFlat: return "D♭"
    case .d: return "D"
    case .eFlat: return "E♭"
    case .e: return "E"
    case .f: return "F"
    case .gFlat: return "G♭"
    case .g: return "G"
    case .aFlat: return "A♭"
    case .a: return "A"
    case .bFlat: return "B♭"
    case .b: return "B"
    }
  }
}

// MARK: - Note

/// Calculates the `Note` above `Interval`
///
/// - Parameters:
///   - note: The note being added interval.
///   - interval: Interval above.
/// - Returns: Returns `Note` above interval
public func +(note: Note, interval: Interval) -> Note {
  return Note(midiNote: note.midiNote + interval.halfstep)
}

/// Calculates the `Note` above halfsteps.
///
/// - Parameters:
///   - note: The note being added halfsteps.
///   - halfstep: Halfsteps above
/// - Returns: Returns `Note` above halfsteps
public func +(note: Note, halfstep: Int) -> Note {
  return Note(midiNote: note.midiNote + halfstep)
}

/// Calculates the `Note` below `Interval`
///
/// - Parameters:
///   - note: The note being calculated.
///   - interval: Interval below.
/// - Returns: Returns `Note` below interval.
public func -(note: Note, interval: Interval) -> Note {
  return Note(midiNote: note.midiNote - interval.halfstep)
}

/// Calculates the `Note` below halfsteps
///
/// - Parameters:
///   - note: The note being calculated.
///   - halfstep: Halfsteps below.
/// - Returns: Returns `Note` below halfsteps.
public func -(note: Note, halfstep: Int) -> Note {
  return Note(midiNote: note.midiNote - halfstep)
}

/// Compares the equality of two notes by their types and octaves.
///
/// - Parameters:
///   - left: Left handside `Note` to be compared.
///   - right: Right handside `Note` to be compared.
/// - Returns: Returns the bool value of comparisation of two notes. 
public func ==(left: Note, right: Note) -> Bool {
  return left.type == right.type && left.octave == right.octave
}

/// Note object with `NoteType` and octave.
/// Could be initilized with midiNote
public struct Note {

  /// Type of the note like C, D, A, B
  public var type: NoteType

  /// Octave of the note.
  /// In theory this must be zero or a positive integer.
  /// But `Note` does not limit octave and calculates every possible octave including the negative ones.
  public var octave: Int

  /// Initilizes the `Note` from midi note
  ///
  /// - Parameter midiNote: Midi note in range of [0 - 127]
  public init(midiNote: Int) {
    octave = (midiNote / 12) - (midiNote < 0 ? 1 : 0)
    type = NoteType(midiNote: midiNote)!
  }

  /// Initilizes the `Note` with `NoteType` and octave
  ///
  /// - Parameters:
  ///   - type: The type of the note in `NoteType` enum.
  ///   - octave: Octave of the note.
  public init(type: NoteType, octave: Int) {
    self.type = type
    self.octave = octave
  }

  /// Returns midi note value.
  /// In theory, this must be in range [0 - 127].
  /// But it does not limits the midi note value.
  public var midiNote: Int {
    return type.rawValue + (octave * 12)
  }
}

public extension Note {

  /// Returns the piano key number by octave based on a standard [1 - 88] key piano;
  public var pianoKey: Int {
    return midiNote + 4
  }

  /// Calculates and returns the frequency of note on octave based on its location of piano keys;
  /// Bases A4 note of 440Hz frequency standard.
  public var frequancy: Float {
    let fn = powf(2.0, Float(pianoKey - 49) / 12.0)
    return fn * 440.0
  }
}

extension Note: CustomStringConvertible {

  public var description: String {
    return "\(type)\(octave)"
  }
}

// MARK: - Interval

/** Represents the interval between `Note`s in halfstep tones and degrees.

- unison: Zero halfstep and zero degree, the note itself.
- m2: One halfstep and one degree between notes.
- M2: Two halfsteps and one degree between notes.
- m3: Three halfsteps and two degree between notes.
- M3: Four halfsteps and two degree between notes.
- P4: Five halfsteps and three degree between notes.
- A4: Six halfsteps and three degree between notes.
- d5: Six halfsteps and four degree between notes.
- P5: Seven halfsteps and four degree between notes.
- A5: Eight halfsteps and four degree between notes.
- m6: Eight halfsteps and five degree between notes.
- M6: Nine halfsteps and five degree between notes.
- d7: Nine halfsteps and six degree between notes.
- m7: Ten halfsteps and six degree between notes.
- M7: Eleven halfsteps and six degree between notes.
- A7: Twelve halfsteps and six degree between notes.
- P8: Twelve halfsteps and seven degree between notes.
- custom: Custom halfsteps and degrees by given input between notes.
*/
public enum Interval {
  case unison
  case m2
  case M2
  case m3
  case M3
  case P4
  case A4
  case d5
  case P5
  case A5
  case m6
  case M6
  case d7
  case m7
  case M7
  case A7
  case P8
  case custom(degree: Int, halfstep: Int)

  /// Initilizes interval with its degree and halfstep.
  ///
  /// - Parameters:
  ///   - degree: Degree of interval
  ///   - halfstep: Halfstep of interval
  public init(degree: Int, halfstep: Int) {
    switch (degree, halfstep) {
    case (0, 0): self = .unison
    case (1, 1): self = .m2
    case (1, 2): self = .M2
    case (2, 3): self = .m3
    case (2, 4): self = .M3
    case (3, 5): self = .P4
    case (3, 6): self = .A4
    case (4, 6): self = .d5
    case (4, 7): self = .P5
    case (4, 8): self = .A5
    case (5, 8): self = .m6
    case (5, 9): self = .M6
    case (6, 9): self = .d7
    case (6, 10): self = .m7
    case (6, 11): self = .M7
    case (6, 12): self = .A7
    case (7, 12): self = .P8
    default: self = .custom(degree: degree, halfstep: halfstep)
    }
  }

  /// Returns the degree of the `Interval`.
  public var degree: Int {
    switch self {
    case .unison: return 0
    case .m2, .M2: return 1
    case .M3, .m3: return 2
    case .P4, .A4: return 3
    case .d5, .P5, .A5: return 4
    case .m6, .M6: return 5
    case .d7, .m7, .M7, .A7: return 6
    case .P8: return 7
    case .custom(let d, _): return d
    }
  }

  /// Returns halfstep representation of `Interval.`
  public var halfstep: Int {
    switch self {
    case .unison: return 0
    case .m2: return 1
    case .M2: return 2
    case .m3: return 3
    case .M3: return 4
    case .P4: return 5
    case .A4, .d5: return 6
    case .P5: return 7
    case .A5, .m6: return 8
    case .M6, .d7: return 9
    case .m7: return 10
    case .M7, .A7: return 11
    case .P8: return 12
    case .custom(_, let h): return h
    }
  }
}

extension Interval: CustomStringConvertible {

  public var description: String {
    switch self {
    case .unison: return "unison"
    case .m2: return "minor second"
    case .M2: return "major second"
    case .m3: return "minor third"
    case .M3: return "major third"
    case .P4: return "perfect forth"
    case .A4: return "agumented fourth"
    case .d5: return "diminished fifth"
    case .P5: return "perfect fifth"
    case .A5: return "agumented fifth"
    case .m6: return "minor sixth"
    case .M6: return "major sixth"
    case .d7: return "diminished seventh"
    case .m7: return "minor seventh"
    case .M7: return "major seventh"
    case .A7: return "agumented seventh"
    case .P8: return "octave"
    case .custom(let degree, let halfstep): return "\(degree), \(halfstep)"
    }
  }
}

// MARK: - ScaleType

/** Represents scale by the intervals between note sequences.

- major: Major scale.
- minor: Minor scale
- harmonicMinor: Harmonic minor scale
- dorian: Dorian scale
- phrygian: Phrygian scale
- lydian: Lydian scale
- mixolydian: Mixolydian scale
- locrian: Locrian scale
- custom: Custom scale by given base key and intervals.
*/
public enum ScaleType {
  case major
  case minor
  case harmonicMinor
  case dorian
  case phrygian
  case lydian
  case mixolydian
  case locrian
  case custom(intervals: [Interval])

  /// Intervals of the scale.
  public var intervals: [Interval] {
    switch self {
    case .major: return [.unison, .M2, .M3, .P4, .P5, .M6, .M7]
    case .minor: return [.unison, .M2, .m3, .P4, .P5, .m6, .m7]
    case .harmonicMinor: return [.unison, .M2, .m3, .P4, .P5, .M6, .m7]
    case .dorian: return [.unison, .M2, .m3, .P4, .P5, .M6, .m7]
    case .phrygian: return [.unison, .m2, .m3, .P4, .P5, .m6, .m7]
    case .lydian: return [.unison, .M2, .M3, .A4, .P5, .M6, .M7]
    case .mixolydian: return [.unison, .M2, .M3, .P4, .P5, .M6, .m7]
    case .locrian: return [.unison, .m2, .m3, .P4, .d5, .m6, .m7]
    case .custom(let intervals): return intervals
    }
  }
}

// MARK: - Scale

/// Scale object with `ScaleType` and scale's key of `NoteType`.
/// Could calculate note sequences in [Note] format
public struct Scale {
  public var type: ScaleType
  public var key: NoteType

  /// Initilizes the scale with its type and key.
  ///
  /// - Parameters:
  ///   - type: Type of scale being initilized.
  ///   - key: Key of scale being initilized.
  public init(type: ScaleType, key: NoteType) {
    self.type = type
    self.key = key
  }

  /// Generates `Note` array of scale in given octave.
  ///
  /// - Parameter octave: Octave value of notes in scale
  /// - Returns: Returns `Note` array of the scale in given octave
  public func notes(octave: Int) -> [Note] {
    return notes(octaves: octave)
  }

  /// Generates `Note` array of scale in given octaves.
  ///
  /// - Parameter octaves: Variadic value of octaves to generate notes in scale.
  /// - Returns: Returns `Note` array of the scale in given octaves.
  public func notes(octaves: Int...) -> [Note] {
    return notes(octaves: octaves)
  }

  /// Generates `Note` array of scale in given octaves.
  ///
  /// - Parameter octaves: Array value of octaves to generate notes in scale.
  /// - Returns: Returns `Note` array of the scale in given octaves.
  public func notes(octaves: [Int]) -> [Note] {
    var notes = [Note]()
    octaves.forEach({ octave in
      let note = Note(type: key, octave: octave)
      notes += type.intervals.map({ note + $0 })
    })
    return notes
  }

  /// Notes generated by the intervals of the scale.
  public var noteTypes: [NoteType] {
    return type.intervals.map({ key + $0 })
  }
}

extension Scale: CustomStringConvertible {

  public var description: String {
    return noteTypes.map({ "\($0)" }).joined(separator: ", ")
  }
}

// MARK: - ChordType

/** Represents chords by note sequences initilized by their intervals.

- maj: Major chord.
- min: Minor chord.
- aug: Augmented chord.
- b5: Power chord.
- dim: Dimineshed chord.
- sus: Suspended chord.
- sus2: Suspended second chord.
- M6: Major sixth chord.
- m6: Minor sixth chord.
- dom7: Dominant seventh chord.
- M7: Major seventh chord.
- m7: Minor seventh chord.
- aug7: Augmented seventh chord.
- dim7: Diminished seventh chord.
- M7b5: Major seventh power chord.
- m7b5: Minor seventh power chord.
- custom: Custom chord with given base key `Note` and intervals.
*/
public enum ChordType {
  case maj
  case min
  case aug
  case b5
  case dim
  case sus
  case sus2
  case M6
  case m6
  case dom7
  case M7
  case m7
  case aug7
  case dim7
  case M7b5
  case m7b5
  case custom(intervals: [Interval], description: String)

  /// Intervals of the chord based on the chord's key.
  public var intervals: [Interval] {
    switch self {
    case .maj: return [.unison, .M3, .P5]
    case .min: return [.unison, .m3, .P5]
    case .aug: return [.unison, .M3, .A5]
    case .b5: return [.unison, .M3, .d5]
    case .dim: return [.unison, .m3, .d5]
    case .sus: return [.unison, .P4, .P5]
    case .sus2: return [.unison, .M2, .P5]
    case .M6: return [.unison, .M3, .P5, .M6]
    case .m6: return [.unison, .m3, .P5, .M6]
    case .dom7: return [.unison, .M3, .P5, .m7]
    case .M7: return [.unison, .M3, .P5, .M7]
    case .m7: return [.unison, .m3, .P5, .m7]
    case .aug7: return [.unison, .M3, .A5, .m7]
    case .dim7: return [.unison, .m3, .d5, .d7]
    case .M7b5: return [.unison, .M3, .A5, .M7]
    case .m7b5: return [.unison, .M3, .d5, .M7]
    case .custom(let intervals, _): return intervals
    }
  }
}

extension ChordType: CustomStringConvertible {

  public var description: String {
    switch self {
    case .maj: return "maj"
    case .min: return "min"
    case .aug: return "aug"
    case .b5: return "b5"
    case .dim: return "dim"
    case .sus: return "sus4"
    case .sus2: return "sus2"
    case .M6: return "6"
    case .m6: return "m6"
    case .dom7: return "7"
    case .M7: return "M7"
    case .m7: return "m7"
    case .aug7: return "+7"
    case .dim7: return "dim7"
    case .M7b5: return "7b5"
    case .m7b5: return "m7b5"
    case .custom(_, let description): return "\(description)"
    }
  }
}

// MARK: - Chord

/// Chord object with its type and key.
public struct Chord {
  public var type: ChordType
  public var key: NoteType

  /// Initilizes the chord with type and key.
  ///
  /// - Parameters:
  ///   - type: `ChordType` of the chord.
  ///   - key: Key note of the chord.
  public init(type: ChordType, key: NoteType) {
    self.type = type
    self.key = key
  }

  /// Generates chord `Note`s for given octave.
  ///
  /// - Parameter octave: Octave of the chord.
  /// - Returns: Returns `Note` array with chord's notes in given octave.
  public func notes(octave: Int) -> [Note] {
    return notes(octaves: 0)
  }

  /// Generates chord `Note`s for given octaves.
  ///
  /// - Parameter octaves: Variadic value of octaves.
  /// - Returns: Returns `Note` array with chord's notes in given octaves.
  public func notes(octaves: Int...) -> [Note] {
    return notes(octaves: octaves)
  }

  /// Generates chord `Note`s for given octaves.
  ///
  /// - Parameter octaves: Array value of octaves.
  /// - Returns: Returns `Note` array with chord's notes in given octaves.
  public func notes(octaves: [Int]) -> [Note] {
    var notes = [Note]()
    octaves.forEach({ octave in
      let note = Note(type: key, octave: octave)
      notes += type.intervals.map({ note + $0 })
    })
    return notes
  }

  /// Notes generated by the intervals of the chord.
  public var noteTypes: [NoteType] {
    return type.intervals.map({ key + $0 })
  }
}

extension Chord: CustomStringConvertible {

  public var description: String {
    return "\(key)\(type)"
  }
}

/// Checks the equability between two chords by their base key and notes.
///
/// - Parameters:
///   - left: Left handside of the equation.
///   - right: Right handside of the equation.
/// - Returns: Returns Bool value of equation of two given chords.
public func ==(left: Chord, right: Chord) -> Bool {
  return left.key == right.key && left.noteTypes == right.noteTypes
}
