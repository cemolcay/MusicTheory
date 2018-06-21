//
//  Note.swift
//  MusicTheory
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

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

  // MARK: CustomStringConvertible

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
public struct Note: Equatable, Codable, CustomStringConvertible {

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

  // MARK: CustomStringConvertible

  /// Converts `Note` to string with its type and octave.
  public var description: String {
    return "\(type)\(octave)"
  }
}
