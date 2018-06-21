//
//  MusicTheory.swift
//  MusicTheory
//
//  Created by Cem Olcay on 29/12/2016.
//  Copyright © 2016 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - Note Value

/// Defines the types of note values.
public enum NoteValueType: Double, Codable {

  /// Two whole notes.
  case doubleWhole = 0.5
  /// Whole note.
  case whole = 1
  /// Half note.
  case half = 2
  /// Quarter note.
  case quarter = 4
  /// Eighth note.
  case eighth = 8
  /// Sixteenth note.
  case sixteenth = 16
  /// Thirtysecond note.
  case thirtysecond = 32
  /// Sixtyfourth note.
  case sixtyfourth = 64
}

/// Defines the length of a `NoteValue`
public enum NoteModifier: Double, Codable {
  /// No additional length.
  case `default` = 1
  /// Adds half of its own value.
  case dotted = 1.5
  /// Three notes of the same value.
  case triplet = 0.6667
  /// Five of the indicated note value total the duration normally occupied by four.
  case quintuplet = 0.8
}

/// Defines the duration of a note beatwise.
public struct NoteValue: Codable {
  /// Type that represents the duration of note.
  public var type: NoteValueType
  /// Modifier for `NoteType` that modifies the duration.
  public var modifier: NoteModifier

  /// Initilize the NoteValue with its type and optional modifier.
  ///
  /// - Parameters:
  ///   - type: Type of note value that represents note duration.
  ///   - modifier: Modifier of note value. Defaults `default`.
  public init(type: NoteValueType, modifier: NoteModifier = .default) {
    self.type = type
    self.modifier = modifier
  }
}

// MARK: - Time Signature

/// Defines how many beats in a measure with which note value.
public struct TimeSignature: Codable {
  /// Beats per measure.
  public var beats: Int

  /// Note value per beat.
  public var noteValue: NoteValueType

  /// Initilizes the time signature with beats per measure and the value of the notes in beat.
  ///
  /// - Parameters:
  ///   - beats: Number of beats in a measure
  ///   - noteValue: Note value of the beats.
  public init(beats: Int = 4, noteValue: NoteValueType = .quarter) {
    self.beats = beats
    self.noteValue = noteValue
  }

  /// Initilizes the time signature with beats per measure and the value of the notes in beat. Returns nil if a division is not match a `NoteValue`.
  ///
  /// - Parameters:
  ///   - beats: Number of beats in a measure
  ///   - division: Number of the beats.
  public init?(beats: Int, division: Int) {
    guard let noteValue = NoteValueType(rawValue: Double(division)) else {
      return nil
    }

    self.beats = beats
    self.noteValue = noteValue
  }
}

// MARK: - Tempo

/// Defines the tempo of the music with beats per second and time signature.
public struct Tempo: Codable {
  /// Time signature of music.
  public var timeSignature: TimeSignature

  /// Beats per minutes.
  public var bpm: Double

  /// Initilizes tempo with time signature and BPM.
  ///
  /// - Parameters:
  ///   - timeSignature: Time Signature.
  ///   - bpm: Beats per minute.
  public init(timeSignature: TimeSignature = TimeSignature(), bpm: Double = 120.0) {
    self.timeSignature = timeSignature
    self.bpm = bpm
  }

  /// Caluclates the duration of a note value in seconds.
  public func duration(of noteValue: NoteValue) -> TimeInterval {
    let secondsPerBeat = 60.0 / bpm
    return secondsPerBeat * (timeSignature.noteValue.rawValue / noteValue.type.rawValue) * noteValue.modifier.rawValue
  }

  /// Calculates the note length in samples. Useful for sequencing notes sample accurate in the DSP.
  ///
  /// - Parameters:
  ///   - noteValue: Rate of the note you want to calculate sample length.
  ///   - sampleRate: Number of samples in a second. Defaults to 44100.
  /// - Returns: Returns the sample length of a note value.
  public func sampleLength(of noteValue: NoteValue, sampleRate: Double = 44100.0) -> Double {
    let secondsPerBeat = 60.0 / bpm
    return secondsPerBeat  * sampleRate * ((4 / noteValue.type.rawValue) * noteValue.modifier.rawValue)
  }

  /// Calculates the LFO speed of a note vaule in hertz.
  public func hertz(of noteValue: NoteValue) -> Double {
    return 1 / duration(of: noteValue)
  }
}

// MARK: - NoteValue

/// Calculates how many notes of a single `NoteValueType` is equivalent to a given `NoteValue`.
///
/// - Parameters:
///   - noteValue: The note value to be measured.
///   - noteValueType: The note value type to measure the length of the note value.
/// - Returns: Returns how many notes of a single `NoteValueType` is equivalent to a given `NoteValue`.
public func /(noteValue: NoteValue, noteValueType: NoteValueType) -> Double {
  return noteValue.modifier.rawValue * noteValueType.rawValue / noteValue.type.rawValue
}

// MARK: - NoteType

/// Calculates the `NoteType` above `Interval`.
///
/// - Parameters:
///   - noteType: The note type being added interval.
///   - interval: Interval above.
/// - Returns: Returns `NoteType` above interval.
public func +(noteType: NoteType, interval: Interval) -> NoteType {
  return NoteType(midiNote: noteType.rawValue + interval.rawValue)!
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

/// Calculates the `NoteType` below `Interval`.
///
/// - Parameters:
///   - noteType: The note type being calculated.
///   - interval: Interval below.
/// - Returns: Returns `NoteType` below interval.
public func -(noteType: NoteType, interval: Interval) -> NoteType {
  return NoteType(midiNote: noteType.rawValue - interval.rawValue)!
}

/// Calculates the `NoteType` below halfsteps.
///
/// - Parameters:
///   - noteType: The note type being calculated.
///   - halfstep: Halfsteps below.
/// - Returns: Returns `NoteType` below halfsteps.
public func -(noteType: NoteType, halfstep: Int) -> NoteType {
  return NoteType(midiNote: noteType.rawValue - halfstep)!
}

/// Defines 12 base notes in music.
/// C, D, E, F, G, A, B with their flats.
/// Raw values are included for easier calculation based on midi notes.
public enum NoteType: Int, Equatable, Codable {
  /// C note.
  case c = 0
  /// D♭ or C♯ note.
  case dFlat
  /// D note.
  case d
  /// E♭ or D♯ note.
  case eFlat
  /// E note.
  case e
  /// F note.
  case f
  /// G♭ or F♯ note.
  case gFlat
  /// G Note.
  case g
  /// A♭ or G♯ note.
  case aFlat
  /// A note.
  case a
  /// B♭ or A♯ note.
  case bFlat
  /// B note.
  case b

  /// All the notes in static array.
  public static let all: [NoteType] = [
    .c, .dFlat, .d, .eFlat, .e, .f,
    .gFlat, .g, .aFlat, .a, .bFlat, .b
  ]

  /// Initilizes the note type with midiNote.
  ///
  /// - parameters:
  ///  - midiNote: The midi note value wanted to be converted to `NoteType`.
  public init?(midiNote: Int) {
    let octave = (midiNote / 12) - 1
    let raw = midiNote - ((octave + 1) * 12)
    guard let note = NoteType(rawValue: abs(raw)) else { return nil }
    self = note
  }
}

extension NoteType: CustomStringConvertible {

  /// Converts `NoteType` to string with its name.
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

/// Calculates the `Note` above `Interval`.
///
/// - Parameters:
///   - note: The note being added interval.
///   - interval: Interval above.
/// - Returns: Returns `Note` above interval.
public func +(note: Note, interval: Interval) -> Note {
  return Note(midiNote: note.midiNote + interval.rawValue)
}

/// Calculates the `Note` above halfsteps.
///
/// - Parameters:
///   - note: The note being added halfsteps.
///   - halfstep: Halfsteps above.
/// - Returns: Returns `Note` above halfsteps.
public func +(note: Note, halfstep: Int) -> Note {
  return Note(midiNote: note.midiNote + halfstep)
}

/// Calculates the `Note` below `Interval`.
///
/// - Parameters:
///   - note: The note being calculated.
///   - interval: Interval below.
/// - Returns: Returns `Note` below interval.
public func -(note: Note, interval: Interval) -> Note {
  return Note(midiNote: note.midiNote - interval.rawValue)
}

/// Calculates the `Note` below halfsteps.
///
/// - Parameters:
///   - note: The note being calculated.
///   - halfstep: Halfsteps below.
/// - Returns: Returns `Note` below halfsteps.
public func -(note: Note, halfstep: Int) -> Note {
  return Note(midiNote: note.midiNote - halfstep)
}

/// Calculates the interval between two notes.
/// Doesn't matter left hand side and right hand side note places.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: `Intreval` between two notes. You can get the halfsteps from interval as well.
public func -(lhs: Note, rhs: Note) -> Interval {
  return Interval(integerLiteral: abs(rhs.midiNote - lhs.midiNote))
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
/// Could be initilized with midiNote.
public struct Note: Equatable, Codable {

  /// Type of the note like C, D, A, B.
  public var type: NoteType

  /// Octave of the note.
  /// In theory this must be zero or a positive integer.
  /// But `Note` does not limit octave and calculates every possible octave including the negative ones.
  public var octave: Int

  /// Initilizes the `Note` from midi note.
  ///
  /// - Parameter midiNote: Midi note in range of [0 - 127].
  public init(midiNote: Int) {
    octave = (midiNote / 12) - 1
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

  /// Returns midi note number.
  /// In theory, this must be in range [0 - 127].
  /// But it does not limits the midi note value.
  public var midiNote: Int {
    return type.rawValue + ((octave + 1) * 12)
  }

  /// Calculates and returns the frequency of note on octave based on its location of piano keys.
  /// Bases A4 note of 440Hz frequency standard.
  public var frequency: Float {
    let fn = powf(2.0, Float(midiNote - 69) / 12.0)
    return fn * 440.0
  }
}

extension Note: CustomStringConvertible {

  /// Converts `Note` to string with its type and octave.
  public var description: String {
    return "\(type)\(octave)"
  }
}

// MARK: - Interval

/// Adds two intervals and returns combined value of two.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Combined interval value of two.
public func +(lhs: Interval, rhs: Interval) -> Interval {
  return Interval(integerLiteral: lhs.rawValue + rhs.rawValue)
}

/// Subsracts two intervals and returns the interval value between two.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Interval between two intervals.
public func -(lhs: Interval, rhs: Interval) -> Interval {
  return Interval(integerLiteral: lhs.rawValue - rhs.rawValue)
}

/// Compares two `Interval` types.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns bool value of equeation.
public func ==(lhs: Interval, rhs: Interval) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

/// Extends `Interval` by any given octave.
/// For example between C1 and D1, there are 2 halfsteps but between C1 and D2 there are 14 halfsteps.
//// ```.M2 * 2``` will give you D2 from a C1.
///
/// - Parameters:
///   - interval: Interval you want to extend by an octave.
///   - octave: Octave you want to extend your interval by.
/// - Returns: Returns new interval by calculating halfsteps between target interval and octave.
public func *(interval: Interval, octave: Int) -> Interval {
  return Interval(integerLiteral: interval.rawValue + (12 * (octave - 1)))
}

/// Defines the interval between `Note`s in halfstep tones and degrees.
public enum Interval: Codable, Equatable, RawRepresentable, ExpressibleByIntegerLiteral {
  /// Zero halfstep and zero degree, unison, the note itself.
  case P1
  /// One halfstep and one degree between notes.
  case m2
  /// Two halfsteps and one degree between notes.
  case M2
  /// Three halfsteps and two degree between notes.
  case m3
  /// Four halfsteps and two degree between notes.
  case M3
  /// Five halfsteps and three degree between notes.
  case P4
  /// Six halfsteps and four degree between notes.
  case d5
  /// Seven halfsteps and four degree between notes.
  case P5
  /// Eight halfsteps and five degree between notes.
  case m6
  /// Nine halfsteps and five degree between notes.
  case M6
  /// Ten halfsteps and six degree between notes.
  case m7
  /// Eleven halfsteps and six degree between notes.
  case M7
  /// Twelve halfsteps and seven degree between notes.
  case P8
  /// Custom halfsteps and degrees by given input between notes.
  case custom(halfstep: Int)

  /// Returns the degree of the `Interval`.
  public var degree: Int {
    switch self {
    case .m2, .M2: return 1
    case .M3, .m3: return 2
    case .P4: return 3
    case .d5, .P5: return 4
    case .m6, .M6: return 5
    case .m7, .M7: return 6
    case .P8: return 7
    default: return 0
    }
  }

  // MARK: RawRepresentable

  public typealias RawValue = Int

  /// Halfstep value of the interval.
  public var rawValue: Int {
    switch self {
    case .P1: return 0
    case .m2: return 1
    case .M2: return 2
    case .m3: return 3
    case .M3: return 4
    case .P4: return 5
    case .d5: return 6
    case .P5: return 7
    case .m6: return 8
    case .M6: return 9
    case .m7: return 10
    case .M7: return 11
    case .P8: return 12
    case .custom(let h): return h
    }
  }

  /// Initilizes interval with its halfsteps.
  ///
  /// - Parameters:
  ///   - rawValue: Halfstep of interval.
  public init?(rawValue: Interval.RawValue) {
    switch rawValue {
    case 0: self = .P1
    case 1: self = .m2
    case 2: self = .M2
    case 3: self = .m3
    case 4: self = .M3
    case 5: self = .P4
    case 6: self = .d5
    case 7: self = .P5
    case 8: self = .m6
    case 9: self = .M6
    case 10: self = .m7
    case 11: self = .M7
    case 12: self = .P8
    default: self = .custom(halfstep: rawValue)
    }
  }

  // MARK: ExpressibleByIntegerLiteral

  /// ExpressibleByIntegerLiteral init function.
  /// You can convert Int value of halfsteps to Interval.
  ///
  /// -           :
  ///   - value: Halfstep value of Interval.
  public init(integerLiteral value: IntegerLiteralType) {
    self = Interval(rawValue: value) ?? .P1
  }

  // MARK: CustomStringConvertible

  /// Description of the interval in terms of music theory.
  public var description: String {
    switch self {
    case .P1: return "unison"
    case .m2: return "minor second"
    case .M2: return "major second"
    case .m3: return "minor third"
    case .M3: return "major third"
    case .P4: return "perfect forth"
    case .d5: return "diminished fifth"
    case .P5: return "perfect fifth"
    case .m6: return "minor sixth"
    case .M6: return "major sixth"
    case .m7: return "minor seventh"
    case .M7: return "major seventh"
    case .P8: return "octave"
    case .custom(let halfstep): return "\(halfstep)th"
    }
  }

  /// Roman numeric value of interval by its halfstep value.
  public var roman: String {
    switch self {
    case .P1: return "i"
    case .m2: return "ii"
    case .M2: return "II"
    case .m3: return "iii"
    case .M3: return "III"
    case .P4: return "IV"
    case .d5: return "v"
    case .P5: return "V"
    case .m6: return "vi"
    case .M6: return "VI"
    case .m7: return "vii"
    case .M7: return "VII"
    case .P8: return "VII"
    case .custom(let halfstep): return "\(halfstep)"
    }
  }
}
