//
//  Interval.swift
//  MusicTheory
//
//  Created by Cem Olcay on 22.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//

import Foundation

/// Checks the equality of two `Interval`s.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns true if two `Interval`s are equal.
public func ==(lhs: Interval, rhs: Interval) -> Bool {
  return lhs.quality == rhs.quality && lhs.degree == rhs.degree
}

/// Defines the interval between `Pitch`es in semitones.
public struct Interval: Codable, Equatable, CustomStringConvertible {

  /// Quality type of the interval.
  public enum Quality: Int, Codable, Equatable, CustomStringConvertible {
    /// Diminished
    case diminished = -1
    /// Perfect
    case perfect = 0
    /// Minor.
    case minor = 1
    /// Major.
    case major = 2
    /// Augmented.
    case augmented = 3

    // MARK: CustomStringConvertible

    /// Returns the notation of the interval quality.
    public var notation: String {
      switch self {
      case .diminished: return "d"
      case .perfect: return "P"
      case .minor: return "m"
      case .major: return "M"
      case .augmented: return "A"
      }
    }

    /// Returns the name of the interval quality.
    public var description: String {
      switch self {
      case .diminished: return "Diminished"
      case .perfect: return "Perfect"
      case .minor: return "Minor"
      case .major: return "Major"
      case .augmented: return "Augmented"
      }
    }
  }

  /// Quality of the interval.
  public var quality: Quality
  /// Degree of the interval.
  public var degree: Int
  /// Semitones interval affect on a pitch.
  public var semitones: Int

  /// Initilizes the interval with its quality, degree and semitones.
  ///
  /// - Parameters:
  ///   - quality: Quality of the interval.
  ///   - degree: Degree of the interval.
  ///   - semitones: Semitones of the interval.
  public init(quality: Quality, degree: Int, semitones: Int) {
    self.quality = quality
    self.degree = degree
    self.semitones = semitones
  }

  /// Unison.
  public static let P1 = Interval(quality: .perfect, degree: 1, semitones: 0)
  /// Perfect fourth.
  public static let P4 = Interval(quality: .perfect, degree: 4, semitones: 5)
  /// Perfect fifth.
  public static let P5 = Interval(quality: .perfect, degree: 5, semitones: 7)
  /// Octave.
  public static let P8 = Interval(quality: .perfect, degree: 8, semitones: 12)

  /// Minor second.
  public static let m2 = Interval(quality: .minor, degree: 2, semitones: 1)
  /// Minor third.
  public static let m3 = Interval(quality: .minor, degree: 3, semitones: 3)
  /// Minor sixth.
  public static let m6 = Interval(quality: .minor, degree: 6, semitones: 8)
  /// Minor seventh.
  public static let m7 = Interval(quality: .minor, degree: 7, semitones: 10)

  /// Major second.
  public static let M2 = Interval(quality: .major, degree: 2, semitones: 2)
  /// Major third.
  public static let M3 = Interval(quality: .major, degree: 3, semitones: 4)
  /// Major sixth.
  public static let M6 = Interval(quality: .major, degree: 6, semitones: 9)
  /// Major seventh.
  public static let M7 = Interval(quality: .major, degree: 7, semitones: 11)

  /// Diminished first.
  public static let d1 = Interval(quality: .diminished, degree: 1, semitones: -1)
  /// Diminished second.
  public static let d2 = Interval(quality: .diminished, degree: 2, semitones: 0)
  /// Diminished third.
  public static let d3 = Interval(quality: .diminished, degree: 3, semitones: 2)
  /// Diminished fourth.
  public static let d4 = Interval(quality: .diminished, degree: 4, semitones: 4)
  /// Diminished fifth.
  public static let d5 = Interval(quality: .diminished, degree: 5, semitones: 6)
  /// Diminished sixth.
  public static let d6 = Interval(quality: .diminished, degree: 6, semitones: 7)
  /// Diminished seventh.
  public static let d7 = Interval(quality: .diminished, degree: 7, semitones: 9)
  /// Diminished eighth.
  public static let d8 = Interval(quality: .diminished, degree: 8, semitones: 11)

  /// Augmented first.
  public static let A1 = Interval(quality: .augmented, degree: 1, semitones: 1)
  /// Augmented second.
  public static let A2 = Interval(quality: .augmented, degree: 2, semitones: 3)
  /// Augmented third.
  public static let A3 = Interval(quality: .augmented, degree: 3, semitones: 5)
  /// Augmented fourth.
  public static let A4 = Interval(quality: .augmented, degree: 4, semitones: 6)
  /// Augmented fifth.
  public static let A5 = Interval(quality: .augmented, degree: 5, semitones: 8)
  /// Augmented sixth.
  public static let A6 = Interval(quality: .augmented, degree: 6, semitones: 10)
  /// Augmented seventh.
  public static let A7 = Interval(quality: .augmented, degree: 7, semitones: 12)

  // MARK: CustomStringConvertible

  /// Returns the notation of the interval.
  public var notation: String {
    return "\(quality.notation)\(degree)"
  }

  /// Returns the name of the interval.
  public var description: String {
    var formattedDegree = "\(degree)"
    
    if #available(OSX 10.11, iOS 9.0, *) {
      let formatter = NumberFormatter()
      formatter.numberStyle = .ordinal
      formattedDegree = formatter.string(from: NSNumber(integerLiteral: degree)) ?? formattedDegree
    }

    return "\(quality) \(formattedDegree)"
  }
}
