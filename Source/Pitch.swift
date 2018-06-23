//
//  Pitch.swift
//  MusicTheory
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

/// Calculates the `Pitch` above halfsteps.
///
/// - Parameters:
///   - note: The pitch that is being added halfsteps.
///   - halfstep: Halfsteps above.
/// - Returns: Returns `Pitch` above halfsteps.
public func +(pitch: Pitch, halfstep: Int) -> Pitch {
  return Pitch(midiNote: pitch.rawValue + halfstep)
}

/// Calculates the `Pitch` below halfsteps.
///
/// - Parameters:
///   - note: The pitch that is being calculated.
///   - halfstep: Halfsteps below.
/// - Returns: Returns `Pitch` below halfsteps.
public func -(pitch: Pitch, halfstep: Int) -> Pitch {
  return Pitch(midiNote: pitch.rawValue - halfstep)
}

/// Compares the equality of two pitches by their MIDI note value.
/// Alternative notes passes this equality. Use `===` function if you want to check exact equality in terms of exact keys.
///
/// - Parameters:
///   - left: Left handside `Pitch` to be compared.
///   - right: Right handside `Pitch` to be compared.
/// - Returns: Returns the bool value of comparisation of two pitches.
public func ==(left: Pitch, right: Pitch) -> Bool {
  return left.rawValue == right.rawValue
}

/// Compares the exact equality of two pitches by their keys and octaves.
/// Alternative notes not passes this equality. Use `==` function if you want to check equality in terms of MIDI note value.
///
/// - Parameters:
///   - left: Left handside `Pitch` to be compared.
///   - right: Right handside `Pitch` to be compared.
/// - Returns: Returns the bool value of comparisation of two pitches.
public func ===(left: Pitch, right: Pitch) -> Bool {
  return left.key == right.key && left.octave == right.octave
}

/// Compares two `Pitch`es in terms of their semitones.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns true if left hand side `Pitch` lower than right hand side `Pitch`.
public func < (lhs: Pitch, rhs: Pitch) -> Bool {
  return lhs.rawValue < rhs.rawValue
}

/// Pitch object with a `Key` and an octave.
/// Could be initilized with MIDI note number and preferred accidental type.
public struct Pitch: RawRepresentable, Codable, Equatable, Comparable, ExpressibleByIntegerLiteral, CustomStringConvertible {

  /// Key of the pitch like C, D, A, B with accidentals.
  public var key: Key

  /// Octave of the pitch.
  /// In theory this must be zero or a positive integer.
  /// But `Note` does not limit octave and calculates every possible octave including the negative ones.
  public var octave: Int

  /// Initilizes the `Pitch` with MIDI note number.
  ///
  /// - Parameter midiNote: Midi note in range of [0 - 127].
  /// - Parameter isPreferredAccidentalSharps: Make it true if preferred accidentals is sharps. Defaults true.
  public init(midiNote: Int, isPreferredAccidentalSharps: Bool = true) {
    octave = (midiNote / 12) - 1
    let keyIndex = midiNote % 12
    key = (isPreferredAccidentalSharps ? Key.keysWithSharps : Key.keysWithFlats)[keyIndex]
  }

  /// Initilizes the `Pitch` with `Key` and octave
  ///
  /// - Parameters:
  ///   - key: Key of the pitch.
  ///   - octave: Octave of the pitch.
  public init(key: Key, octave: Int) {
    self.key = key
    self.octave = octave
  }

  /// Converts and returns enharmonic equivalent pitch in target `KeyType`.
  ///
  /// - Parameters:
  ///   - keyType: Target `KeyType` you want to convert.
  ///   - isHigher: Is target key type is a higher pitch or not.
  /// - Returns: Returns the converted `Pitch` in target `KeyType`.
  public func convert(to keyType: Key.KeyType, isHigher: Bool) -> Pitch {
    // Set target octave
    var targetOctave = octave
    if isHigher {
      if keyType.rawValue < key.type.rawValue {
        targetOctave += 1
      }
    } else {
      if keyType.rawValue > key.type.rawValue {
        targetOctave -= 1
      }
    }


    // Set target pitch
    var targetPitch = Pitch(key: Key(type: keyType), octave: targetOctave)

    let diff = rawValue - targetPitch.rawValue
    targetPitch.key.accidental = Accidental(integerLiteral: diff)

    return targetPitch
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
    let semitones = key.type.rawValue + key.accidental.rawValue
    return semitones + ((octave + 1) * 12)
  }

  /// Initilizes the pitch with an integer value that represents the MIDI note number of the pitch.
  ///
  /// - Parameter rawValue: MIDI note number of the pitch.
  public init?(rawValue: Pitch.RawValue) {
    self = Pitch(midiNote: rawValue)
  }

  // MARK: ExpressibleByIntegerLiteral

  public typealias IntegerLiteralType = Int

  /// Initilizes the pitch with an integer value that represents the MIDI note number of the pitch.
  ///
  /// - Parameter value: MIDI note number of the pitch.
  public init(integerLiteral value: Pitch.IntegerLiteralType) {
    self = Pitch(midiNote: value)
  }

  // MARK: CustomStringConvertible

  /// Converts `Pitch` to string with its key and octave.
  public var description: String {
    return "\(key)\(octave)"
  }
}
