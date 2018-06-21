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

public func +(lhs: Key, rhs: Key) -> Key {
  return Key(integerLiteral: lhs.rawValue + rhs.rawValue)
}

public func -(lhs: Key, rhs: Key) -> Key {
  return Key(integerLiteral: lhs.rawValue - rhs.rawValue)
}

public func *(lhs: Key, rhs: Int) -> Key {
  return Key(integerLiteral: lhs.rawValue * rhs)
}

public func /(lhs: Key, rhs: Int) -> Key {
  return Key(integerLiteral: lhs.rawValue / rhs)
}

public func ==(lhs: Key, rhs: Key) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

public func +(lhs: Pitch, rhs: Key) -> Pitch {
  return lhs + rhs.rawValue
}

public func -(lhs: Pitch, rhs: Key) -> Pitch {
  return lhs - rhs.rawValue
}

public struct Key: RawRepresentable, Codable, Equatable, ExpressibleByIntegerLiteral, CustomStringConvertible {

  public enum KeyType: Int, Codable, Equatable, CustomStringConvertible {
    case c = 0
    case d = 2
    case e = 4
    case f = 5
    case g = 7
    case a = 9
    case b = 11

    public var description: String {
      switch self {
      case .c: return "C"
      case .d: return "D"
      case .e: return "E"
      case .f: return "F"
      case .g: return "G"
      case .a: return "A"
      case .b: return "B"
      }
    }
  }

  public var type: KeyType
  public var accident: Accident

  public init(type: KeyType, accident: Accident = .natural) {
    self.type = type
    self.accident = accident
  }

  public init?(midiNote: Int, isPreferredAccidentSharps: Bool = true) {
    let octave = (midiNote / 12) - 1
    let raw = midiNote - ((octave + 1) * 12)

    if let keyType = KeyType(rawValue: raw) { // Use natural
      self.type = keyType
      self.accident = .natural
    } else { // Use accidents
      if isPreferredAccidentSharps { // Use sharps
        if let keyType = KeyType(rawValue: raw - 1) { // Set sharp value
          self.type = keyType
          self.accident = .sharp
        } else {
          return nil
        }
      } else { // Use flats
        if let keyType = KeyType(rawValue: raw + 1) { // Set flat value
          self.type = keyType
          self.accident = .flat
        } else {
          return nil
        }
      }
    }
  }

  // MARK: RawRepresentable

  public typealias RawValue = Int

  public var rawValue: Int {
    return type.rawValue + accident.rawValue
  }

  public init?(rawValue: Key.RawValue) {
    guard let key = Key(midiNote: rawValue) else { return nil }
    self = key
  }

  // MARK: ExpressibleByIntegerLiteral

  public typealias IntegerLiteralType = Int

  public init(integerLiteral value: Key.IntegerLiteralType) {
    self = Key(rawValue: value) ?? Key(type: .c, accident: .natural)
  }

  // MARK: CustomStringConvertible

  public var description: String {
    return "\(type)\(accident)"
  }
}

// MARK: - Note

/// Calculates the `Note` above `Interval`.
///
/// - Parameters:
///   - note: The note being added interval.
///   - interval: Interval above.
/// - Returns: Returns `Note` above interval.
public func +(pitch: Pitch, interval: Interval) -> Pitch {
  return Pitch(midiNote: pitch.rawValue + interval.rawValue)
}

/// Calculates the `Note` above halfsteps.
///
/// - Parameters:
///   - note: The note being added halfsteps.
///   - halfstep: Halfsteps above.
/// - Returns: Returns `Note` above halfsteps.
public func +(pitch: Pitch, halfstep: Int) -> Pitch {
  return Pitch(midiNote: pitch.rawValue + halfstep)
}

/// Calculates the `Note` below `Interval`.
///
/// - Parameters:
///   - note: The note being calculated.
///   - interval: Interval below.
/// - Returns: Returns `Note` below interval.
public func -(pitch: Pitch, interval: Interval) -> Pitch {
  return Pitch(midiNote: pitch.rawValue - interval.rawValue)
}

/// Calculates the `Note` below halfsteps.
///
/// - Parameters:
///   - note: The note being calculated.
///   - halfstep: Halfsteps below.
/// - Returns: Returns `Note` below halfsteps.
public func -(pitch: Pitch, halfstep: Int) -> Pitch {
  return Pitch(midiNote: pitch.rawValue - halfstep)
}

/// Calculates the interval between two notes.
/// Doesn't matter left hand side and right hand side note places.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: `Intreval` between two notes. You can get the halfsteps from interval as well.
public func -(lhs: Pitch, rhs: Pitch) -> Interval {
  return Interval(integerLiteral: abs(rhs.rawValue - lhs.rawValue))
}

/// Compares the equality of two notes by their types and octaves.
///
/// - Parameters:
///   - left: Left handside `Note` to be compared.
///   - right: Right handside `Note` to be compared.
/// - Returns: Returns the bool value of comparisation of two notes.
public func ==(left: Pitch, right: Pitch) -> Bool {
  return left.key == right.key && left.octave == right.octave
}

/// Note object with `NoteType` and octave.
/// Could be initilized with midiNote.
public struct Pitch: RawRepresentable, Codable, Equatable, ExpressibleByIntegerLiteral, CustomStringConvertible {

  /// Key of the note like C, D, A, B.
  public private(set) var key: Key

  /// Octave of the note.
  /// In theory this must be zero or a positive integer.
  /// But `Note` does not limit octave and calculates every possible octave including the negative ones.
  public private(set) var octave: Int

  /// Initilizes the `Note` from midi note.
  ///
  /// - Parameter midiNote: Midi note in range of [0 - 127].
  public init(midiNote: Int, isPreferredAccidentSharps: Bool = true) {
    octave = (midiNote / 12) - 1
    key = Key(midiNote: midiNote, isPreferredAccidentSharps: isPreferredAccidentSharps) ?? 0
  }

  /// Initilizes the `Note` with `NoteType` and octave
  ///
  /// - Parameters:
  ///   - type: The type of the note in `NoteType` enum.
  ///   - octave: Octave of the note.
  public init(key: Key, octave: Int) {
    self.key = key
    self.octave = octave
  }

  /// Calculates and returns the frequency of note on octave based on its location of piano keys.
  /// Bases A4 note of 440Hz frequency standard.
  public var frequency: Float {
    let fn = powf(2.0, Float(rawValue - 69) / 12.0)
    return fn * 440.0
  }

  // MARK: RawRepresentable

  public typealias RawValue = Int

  /// Returns midi note number.
  /// In theory, this must be in range [0 - 127].
  /// But it does not limits the midi note value.
  public var rawValue: Int {
    return key.rawValue + ((octave + 1) * 12)
  }

  public init?(rawValue: Pitch.RawValue) {
    self = Pitch(midiNote: rawValue)
  }

  // MARK: ExpressibleByIntegerLiteral

  public typealias IntegerLiteralType = Int

  public init(integerLiteral value: Pitch.IntegerLiteralType) {
    self = Pitch(midiNote: value)
  }

  // MARK: CustomStringConvertible

  /// Converts `Note` to string with its type and octave.
  public var description: String {
    return "\(key)\(octave)"
  }
}
