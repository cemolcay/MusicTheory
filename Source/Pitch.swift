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

/// Calculates the `Pitch` above `Interval`.
///
/// - Parameters:
///   - note: The pitch that is being added interval.
///   - interval: Interval above.
/// - Returns: Returns `Pitch` above interval.
public func +(pitch: Pitch, interval: Interval) -> Pitch {
  return Pitch(midiNote: pitch.rawValue + interval.rawValue)
}

/// Calculates the `Pitch` above halfsteps.
///
/// - Parameters:
///   - note: The pitch that is being added halfsteps.
///   - halfstep: Halfsteps above.
/// - Returns: Returns `Pitch` above halfsteps.
public func +(pitch: Pitch, halfstep: Int) -> Pitch {
  return Pitch(midiNote: pitch.rawValue + halfstep)
}

/// Calculates the `Pitch` below `Interval`.
///
/// - Parameters:
///   - note: The pitch that is being calculated.
///   - interval: Interval below.
/// - Returns: Returns `Pitch` below interval.
public func -(pitch: Pitch, interval: Interval) -> Pitch {
  return Pitch(midiNote: pitch.rawValue - interval.rawValue)
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

/// Calculates the interval between two pitches.
/// Doesn't matter left hand side and right hand side note places.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: `Intreval` between two pitches. You can get the halfsteps from interval as well.
public func -(lhs: Pitch, rhs: Pitch) -> Interval {
  return Interval(integerLiteral: abs(rhs.rawValue - lhs.rawValue))
}

/// Compares the equality of two pitches by their keys and octaves.
///
/// - Parameters:
///   - left: Left handside `Pitch` to be compared.
///   - right: Right handside `Pitch` to be compared.
/// - Returns: Returns the bool value of comparisation of two pitches.
public func ==(left: Pitch, right: Pitch) -> Bool {
  return left.key == right.key && left.octave == right.octave
}

/// Pitch object with a `Key` and an octave.
/// Could be initilized with MIDI note number and preferred accident type.
public struct Pitch: RawRepresentable, Codable, Equatable, ExpressibleByIntegerLiteral, CustomStringConvertible {

  /// Key of the pitch like C, D, A, B with accidents.
  public private(set) var key: Key

  /// Octave of the pitch.
  /// In theory this must be zero or a positive integer.
  /// But `Note` does not limit octave and calculates every possible octave including the negative ones.
  public private(set) var octave: Int

  /// Initilizes the `Pitch` with MIDI note number.
  ///
  /// - Parameter midiNote: Midi note in range of [0 - 127].
  /// - Parameter isPreferredAccidentSharps: Make it true if preferred accidents is sharps. Defaults true.
  public init(midiNote: Int, isPreferredAccidentSharps: Bool = true) {
    octave = (midiNote / 12) - 1
    key = Key(midiNote: midiNote, isPreferredAccidentSharps: isPreferredAccidentSharps) ?? 0
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

  /// Converts `Note` to string with its type and octave.
  public var description: String {
    return "\(key)\(octave)"
  }
}
