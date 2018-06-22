//
//  Key.swift
//  MusicTheory iOS
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

/// Adds two `Key` types with each other.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the new `Key` value.
public func +(lhs: Key, rhs: Key) -> Key {
  return Key(integerLiteral: lhs.rawValue + rhs.rawValue)
}

/// Substracts two `Key` types with each other.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the new `Key` value.
public func -(lhs: Key, rhs: Key) -> Key {
  return Key(integerLiteral: lhs.rawValue - rhs.rawValue)
}

/// Multiplies a `Key` value with an integer.
///
/// - Parameters:
///   - lhs: Key you want to multiply.
///   - rhs: Multiplier.
/// - Returns: Returns the new `Key` value.
public func *(lhs: Key, rhs: Int) -> Key {
  return Key(integerLiteral: lhs.rawValue * rhs)
}

/// Divides a `Key` value with an integer.
///
/// - Parameters:
///   - lhs: Key you want to divide.
///   - rhs: Multiplier.
/// - Returns: Returns the new `Key` value.
public func /(lhs: Key, rhs: Int) -> Key {
  return Key(integerLiteral: lhs.rawValue / rhs)
}

/// Checks if two `Key` types are equal in terms of their interval value.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the equation value.
public func ==(lhs: Key, rhs: Key) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

/// Adds a `Pitch` value to a `Key` value.
///
/// - Parameters:
///   - lhs: Pitch, you want to add a key value.
///   - rhs: Key, you want to add on a pitch.
/// - Returns: Returns the new `Pitch` value.
public func +(lhs: Pitch, rhs: Key) -> Pitch {
  return lhs + rhs.rawValue
}

/// Substracts a `Key` value from a `Key` value.
///
/// - Parameters:
///   - lhs: Pitch, you want to substract a key value.
///   - rhs: Key, you want to substract from a pitch.
/// - Returns: Returns the new `Pitch` value.
public func -(lhs: Pitch, rhs: Key) -> Pitch {
  return lhs - rhs.rawValue
}

/// Adds an `Interval` value to a `Key` value.
///
/// - Parameters:
///   - lhs: Key, you want to add an interval value.
///   - rhs: Interval value, you want to add on a key.
/// - Returns: Returns the new `Key` value.
public func +(lhs: Key, rhs: Interval) -> Key {
  return Key(integerLiteral: lhs.rawValue + rhs.rawValue)
}

/// Substracts an `Interval` value from a `Key` value.
///
/// - Parameters:
///   - lhs: Key, you want to substract an interval value.
///   - rhs: Interval value, you want to substract from a key.
/// - Returns: Returns the new `Key` value.
public func -(lhs: Key, rhs: Interval) -> Key {
  return Key(integerLiteral: lhs.rawValue - rhs.rawValue)
}

/// Adds an `Int` value to a `Key` value.
///
/// - Parameters:
///   - lhs: Key, you want to add an int value.
///   - rhs: Int value, you want to add on a key.
/// - Returns: Returns the new `Key` value.
public func +(lhs: Key, rhs: Int) -> Key {
  return Key(integerLiteral: lhs.rawValue + rhs)
}

/// Substracts an `Int` value from a `Key` value.
///
/// - Parameters:
///   - lhs: Key, you want to substract an int value.
///   - rhs: Int value, you want to substract from a key.
/// - Returns: Returns the new `Key` value.
public func -(lhs: Key, rhs: Int) -> Key {
  return Key(integerLiteral: lhs.rawValue - rhs)
}

/// Represents the keys that notes and pitches are based on.
public struct Key: RawRepresentable, Codable, Equatable, ExpressibleByIntegerLiteral, CustomStringConvertible {

  /// Base pitch of the key without accidentals. Accidentals will take account in the parent struct, `Key`. Integer values are based on C = 0 on western chromatic scale.
  public enum KeyType: Int, Codable, Equatable, CustomStringConvertible {
    /// C key.
    case c = 0
    /// D key.
    case d = 2
    /// E key.
    case e = 4
    /// F key.
    case f = 5
    /// G key.
    case g = 7
    /// A key.
    case a = 9
    /// B key.
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

  /// Type of the key.
  public var type: KeyType

  /// Accidental of the key.
  public var accidental: Accidental

  /// Initilizes the key with its type and accidental.
  ///
  /// - Parameters:
  ///   - type: The type of the key.
  ///   - accidental: Accidental of the key. Defaults natural.
  public init(type: KeyType, accidental: Accidental = .natural) {
    self.type = type
    self.accidental = accidental
  }

  /// Initilizes the key with an integer value that represents the MIDI note value.
  ///
  /// - Parameters:
  ///   - midiNote: MIDI note value of the key.
  ///   - isPreferredAccidentalSharps: Calculates the key in sharp or flat accidentals. Defaults sharp accidens.
  public init?(midiNote: Int, isPreferredAccidentalSharps: Bool = true) {
    let octave = (midiNote / 12) - 1
    let raw = midiNote - ((octave + 1) * 12)

    if let keyType = KeyType(rawValue: raw) { // Use natural
      self.type = keyType
      self.accidental = .natural
    } else { // Use accidentals
      if isPreferredAccidentalSharps { // Use sharps
        if let keyType = KeyType(rawValue: raw - 1) { // Set sharp value
          self.type = keyType
          self.accidental = .sharp
        } else {
          return nil
        }
      } else { // Use flats
        if let keyType = KeyType(rawValue: raw + 1) { // Set flat value
          self.type = keyType
          self.accidental = .flat
        } else {
          return nil
        }
      }
    }
  }

  // MARK: RawRepresentable

  public typealias RawValue = Int

  /// MIDI note value of the key.
  public var rawValue: Int {
    return type.rawValue + accidental.rawValue
  }

  /// Initilizes the key with an integer value that represents the MIDI note value. Calculates the key in sharp accidentals by default.
  ///
  /// - Parameter rawValue: MIDI note value of the key.
  public init?(rawValue: Key.RawValue) {
    guard let key = Key(midiNote: rawValue) else { return nil }
    self = key
  }

  // MARK: ExpressibleByIntegerLiteral

  public typealias IntegerLiteralType = Int

  /// Initilizes the key with an integer value that represents the MIDI note value. Calculates the key in sharp accidentals by default.
  ///
  /// - Parameter value: MIDI note value of the key.
  public init(integerLiteral value: Key.IntegerLiteralType) {
    self = Key(rawValue: value) ?? Key(type: .c, accidental: .natural)
  }

  // MARK: CustomStringConvertible

  /// Returns the key notation with its type and accidental, if has any.
  public var description: String {
    return "\(type)\(accidental)"
  }
}
