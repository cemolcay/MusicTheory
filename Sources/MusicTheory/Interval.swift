//
//  Interval.swift
//  MusicTheory
//
//  Created by Cem Olcay on 22.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//

import Foundation

/// Checks the equality of two `Interval`s in terms of their semitones.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns true if two `Interval`s are equal.
public func == (lhs: Interval, rhs: Interval) -> Bool {
  return lhs.semitones == rhs.semitones
}

/// Checks the equality of two `Interval`s in terms of their quality, degree and semitones.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns true if two `Interval`s are equal.
public func === (lhs: Interval, rhs: Interval) -> Bool {
  return lhs.quality == rhs.quality && rhs.degree == rhs.degree && lhs.semitones == rhs.semitones
}

/// Defines the interval between `Pitch`es in semitones.
public struct Interval: Codable, Equatable, CustomStringConvertible {
  /// Quality type of the interval.
  public enum Quality: Int, Codable, Equatable, CustomStringConvertible {
    /// Diminished
    case diminished
    /// Perfect
    case perfect
    /// Minor.
    case minor
    /// Major.
    case major
    /// Augmented.
    case augmented

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
  /// Perfect eleventh.
  public static let P11 = Interval(quality: .perfect, degree: 11, semitones: 17)
  /// Perfect twelfth.
  public static let P12 = Interval(quality: .perfect, degree: 12, semitones: 19)
  /// Perfect fifteenth, double octave.
  public static let P15 = Interval(quality: .perfect, degree: 15, semitones: 24)

  /// Minor second.
  public static let m2 = Interval(quality: .minor, degree: 2, semitones: 1)
  /// Minor third.
  public static let m3 = Interval(quality: .minor, degree: 3, semitones: 3)
  /// Minor sixth.
  public static let m6 = Interval(quality: .minor, degree: 6, semitones: 8)
  /// Minor seventh.
  public static let m7 = Interval(quality: .minor, degree: 7, semitones: 10)
  /// Minor ninth.
  public static let m9 = Interval(quality: .minor, degree: 9, semitones: 13)
  /// Minor tenth.
  public static let m10 = Interval(quality: .minor, degree: 10, semitones: 15)
  /// Minor thirteenth.
  public static let m13 = Interval(quality: .minor, degree: 13, semitones: 20)
  /// Minor fourteenth.
  public static let m14 = Interval(quality: .minor, degree: 14, semitones: 22)

  /// Major second.
  public static let M2 = Interval(quality: .major, degree: 2, semitones: 2)
  /// Major third.
  public static let M3 = Interval(quality: .major, degree: 3, semitones: 4)
  /// Major sixth.
  public static let M6 = Interval(quality: .major, degree: 6, semitones: 9)
  /// Major seventh.
  public static let M7 = Interval(quality: .major, degree: 7, semitones: 11)
  /// Major ninth.
  public static let M9 = Interval(quality: .major, degree: 9, semitones: 14)
  /// Major tenth.
  public static let M10 = Interval(quality: .major, degree: 10, semitones: 16)
  /// Major thirteenth.
  public static let M13 = Interval(quality: .major, degree: 13, semitones: 21)
  /// Major fourteenth.
  public static let M14 = Interval(quality: .major, degree: 14, semitones: 23)

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
  /// Diminished ninth.
  public static let d9 = Interval(quality: .diminished, degree: 9, semitones: 12)
  /// Diminished tenth.
  public static let d10 = Interval(quality: .diminished, degree: 10, semitones: 14)
  /// Diminished eleventh.
  public static let d11 = Interval(quality: .diminished, degree: 11, semitones: 16)
  /// Diminished twelfth.
  public static let d12 = Interval(quality: .diminished, degree: 12, semitones: 18)
  /// Diminished thirteenth.
  public static let d13 = Interval(quality: .diminished, degree: 13, semitones: 19)
  /// Diminished fourteenth.
  public static let d14 = Interval(quality: .diminished, degree: 14, semitones: 21)
  /// Diminished fifteenth.
  public static let d15 = Interval(quality: .diminished, degree: 15, semitones: 23)

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
  /// Augmented octave.
  public static let A8 = Interval(quality: .augmented, degree: 8, semitones: 13)
  /// Augmented ninth.
  public static let A9 = Interval(quality: .augmented, degree: 9, semitones: 15)
  /// Augmented tenth.
  public static let A10 = Interval(quality: .augmented, degree: 10, semitones: 17)
  /// Augmented eleventh.
  public static let A11 = Interval(quality: .augmented, degree: 11, semitones: 18)
  /// Augmented twelfth.
  public static let A12 = Interval(quality: .augmented, degree: 12, semitones: 20)
  /// Augmented thirteenth.
  public static let A13 = Interval(quality: .augmented, degree: 13, semitones: 22)
  /// Augmented fourteenth.
  public static let A14 = Interval(quality: .augmented, degree: 14, semitones: 24)
  /// Augmented fifteenth.
  public static let A15 = Interval(quality: .augmented, degree: 15, semitones: 25)

  /// All pre-defined intervals in a static array. You can filter it out with qualities, degrees or semitones.
  public static let all: [Interval] = [
    .P1, .P4, .P5, .P8, .P11, .P12, .P15,
    .m2, .m3, .m6, .m7, .m9, .m10, .m13, .m14,
    .M2, .M3, .M6, .M7, .M9, .M10, .M13, .M14,
    .d1, .d2, .d3, .d4, .d5, .d6, .d7, .d8, .d9, .d10, .d11, .d12, .d13, .d14, .d15,
    .A1, .A2, .A3, .A4, .A5, .A6, .A7, .A8, .A9, .A10, .A11, .A12, .A13, .A14, .A15,
  ]

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
