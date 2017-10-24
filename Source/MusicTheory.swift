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
public enum NoteValueType {
  /// Two whole notes.
  case doubleWhole
  /// Whole note.
  case whole
  /// Half note.
  case half
  /// Quarter note.
  case quarter
  /// Eighth note.
  case eighth
  /// Sixteenth note.
  case sixteenth
  /// Thirtysecond note.
  case thirtysecond
  /// Sixtyfourth note.
  case sixtyfourth

  /// Init with beat count.
  /// For example for a whole note, beats should be 1,
  /// For a eighth note, beats should be 8.
  /// Returns nil, if no beats match.
  public init?(beats: Double) {
    switch beats {
    case 0.5: self = .doubleWhole
    case 1: self = .whole
    case 2: self = .half
    case 4: self = .quarter
    case 8: self = .eighth
    case 16: self = .sixteenth
    case 32: self = .thirtysecond
    case 64: self = .sixtyfourth
    default: return nil
    }
  }

  /// Beat count
  public var beats: Double {
    switch self {
    case .doubleWhole: return 0.5
    case .whole: return 1
    case .half: return 2
    case .quarter: return 4
    case .eighth: return 8
    case .sixteenth: return 16
    case .thirtysecond: return 32
    case .sixtyfourth: return 64
    }
  }
}

/// Defines the lenght of a `NoteValue`
public enum NoteModifier {
  /// No additional lenght.
  case `default`
  /// Adds half of its own value.
  case dotted
  /// Three notes of the same value.
  case triplet

  /// Multiplier using in caluclation of note duration in seconds.
  public var durationMultiplier: Double {
    switch self {
    case .default: return 1
    case .dotted: return 1.5
    case .triplet: return 0.67
    }
  }
}

/// Defines the duration of a note beatwise.
public struct NoteValue {
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
public struct TimeSignature {
  /// Beats per measure.
  public var beats: UInt

  /// Note value per beat.
  public var noteValue: NoteValueType

  /// Initilizes the time signature with beats per measure and the value of the notes in beat.
  ///
  /// - Parameters:
  ///   - beats: Number of beats in a measure
  ///   - noteValue: Note value of the beats.
  public init(beats: UInt, noteValue: NoteValueType) {
    self.beats = beats
    self.noteValue = noteValue
  }

  /// Initilizes the time signature with beats per measure and the value of the notes in beat. Returns nil if a division is not match a `NoteValue`.
  ///
  /// - Parameters:
  ///   - beats: Number of beats in a measure
  ///   - division: Number of the beats.
  public init?(beats: UInt, division: UInt) {
    guard let noteValue = NoteValueType(beats: Double(division)) else {
      return nil
    }

    self.beats = beats
    self.noteValue = noteValue
  }
}

// MARK: - Tempo

/// Defines the tempo of the music with beats per second and time signature.
public struct Tempo {
  /// Time signature of music.
  public var timeSignature = TimeSignature(beats: 4, noteValue: .quarter)

  /// Beats per minutes.
  public var bpm: Double = 120.0

  /// Initilizes tempo with time signature and BPM.
  ///
  /// - Parameters:
  ///   - timeSignature: Time Signature.
  ///   - bpm: Beats per minute.
  public init(timeSignature: TimeSignature, bpm: Double) {
    self.timeSignature = timeSignature
    self.bpm = bpm
  }

  /// Caluclates the duration of a note value in seconds.
  public func duration(of noteValue: NoteValue) -> TimeInterval {
    let secondsPerBeat = 60.0 / bpm
    let secondsPerNote = secondsPerBeat * (timeSignature.noteValue.beats / noteValue.type.beats) * noteValue.modifier.durationMultiplier
    return secondsPerNote
  }

  /// Calculates the LFO speed of a note vaule in hertz.
  public func hertz(of noteValue: NoteValue) -> Double {
    return 1 / duration(of: noteValue)
  }
}

// MARK: - NoteType

/// Calculates the `NoteType` above `Interval`.
///
/// - Parameters:
///   - noteType: The note type being added interval.
///   - interval: Interval above.
/// - Returns: Returns `NoteType` above interval.
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

/// Calculates the `NoteType` below `Interval`.
///
/// - Parameters:
///   - noteType: The note type being calculated.
///   - interval: Interval below.
/// - Returns: Returns `NoteType` below interval.
public func -(noteType: NoteType, interval: Interval) -> NoteType {
  return NoteType(midiNote: noteType.rawValue - interval.halfstep)!
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
public enum NoteType: Int, Equatable {
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
    let octave = (midiNote / 12) - (midiNote < 0 ? 1 : 0)
    let raw = octave > 0 ? midiNote - (octave * 12) : midiNote - ((octave + 1) * 12) + 12
    guard let note = NoteType(rawValue: raw) else { return nil }
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
  return Note(midiNote: note.midiNote + interval.halfstep)
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
  return Note(midiNote: note.midiNote - interval.halfstep)
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
	return Interval(halfstep: abs(rhs.midiNote - lhs.midiNote))
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
public struct Note: Equatable {

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

  /// Returns the piano key number by octave based on a standard [1 - 88] key piano.
  public var pianoKey: Int {
    return midiNote + 4
  }

  /// Calculates and returns the frequency of note on octave based on its location of piano keys.
  /// Bases A4 note of 440Hz frequency standard.
  public var frequancy: Float {
    let fn = powf(2.0, Float(pianoKey - 49) / 12.0)
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
  return Interval(halfstep: lhs.halfstep + rhs.halfstep)
}

/// Subsracts two intervals and returns the interval value between two.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Interval between two intervals.
public func -(lhs: Interval, rhs: Interval) -> Interval {
  return Interval(halfstep: lhs.halfstep - rhs.halfstep)
}

/// Compares two `Interval` types.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns bool value of equeation.
public func ==(lhs: Interval, rhs: Interval) -> Bool {
	return lhs.halfstep == rhs.halfstep
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
	return Interval(halfstep: interval.halfstep + (12 * (octave - 1)))
}

/// Defines the interval between `Note`s in halfstep tones and degrees.
public enum Interval: Equatable, ExpressibleByIntegerLiteral {
  public typealias IntegerLiteralType = Int

  /// Zero halfstep and zero degree, the note itself.
  case unison
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

  /// Initilizes interval with its degree and halfstep.
  ///
  /// - Parameters:
  ///   - degree: Degree of interval.
  ///   - halfstep: Halfstep of interval.
  public init(halfstep: Int) {
    switch halfstep {
    case 0: self = .unison
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
    default: self = .custom(halfstep: halfstep)
    }
  }

  /// ExpressibleByIntegerLiteral init function.
  /// You can convert Int value of halfsteps to Interval.
  ///
  /// -           :
  ///   - value: Halfstep value of Interval.
  public init(integerLiteral value: IntegerLiteralType) {
    self.init(halfstep: value)
  }

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

  /// Returns halfstep representation of `Interval.`
  public var halfstep: Int {
    switch self {
    case .unison: return 0
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
    case .unison: return "i"
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
