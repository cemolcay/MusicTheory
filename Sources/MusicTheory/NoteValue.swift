//
//  NoteValue.swift
//  MusicTheory iOS
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - NoteValueType

/// Defines the types of note values.
public enum NoteValueType: Int, Codable, CaseIterable, Hashable, CustomStringConvertible {
  /// Four bar notes.
  case fourBars
  /// Two bar notes.
  case twoBars
  /// One bar note.
  case oneBar
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

  /// The note value's duration in beats.
  public var rate: Double {
    switch self {
    case .fourBars: return 16.0 / 1.0
    case .twoBars: return 8.0 / 1.0
    case .oneBar: return 4.0 / 1.0
    case .doubleWhole: return 2.0 / 1.0
    case .whole: return 1.0 / 1.0
    case .half: return 1.0 / 2.0
    case .quarter: return 1.0 / 4.0
    case .eighth: return 1.0 / 8.0
    case .sixteenth: return 1.0 / 16.0
    case .thirtysecond: return 1.0 / 32.0
    case .sixtyfourth: return 1.0 / 64.0
    }
  }

  /// Returns the string representation of the note value type.
  public var description: String {
    switch self {
    case .fourBars: return "4 Bars"
    case .twoBars: return "2 Bars"
    case .oneBar: return "1 Bar"
    case .doubleWhole: return "2/1"
    case .whole: return "1/1"
    case .half: return "1/2"
    case .quarter: return "1/4"
    case .eighth: return "1/8"
    case .sixteenth: return "1/16"
    case .thirtysecond: return "1/32"
    case .sixtyfourth: return "1/64"
    }
  }
}

// MARK: - NoteModifier

/// Defines the length of a `NoteValue`
public enum NoteModifier: Double, Codable, CaseIterable, CustomStringConvertible {
  /// No additional length.
  case `default` = 1
  /// Adds half of its own value.
  case dotted = 1.5
  /// Three notes of the same value.
  case triplet = 0.6667
  /// Five of the indicated note value total the duration normally occupied by four.
  case quintuplet = 0.8

  /// The string representation of the modifier.
  public var description: String {
    switch self {
    case .default: return ""
    case .dotted: return "D"
    case .triplet: return "T"
    case .quintuplet: return "Q"
    }
  }
}

// MARK: - NoteValue

/// Calculates how many notes of a single `NoteValueType` is equivalent to a given `NoteValue`.
///
/// - Parameters:
///   - noteValue: The note value to be measured.
///   - noteValueType: The note value type to measure the length of the note value.
/// - Returns: Returns how many notes of a single `NoteValueType` is equivalent to a given `NoteValue`.
public func / (noteValue: NoteValue, noteValueType: NoteValueType) -> Double {
  return noteValue.modifier.rawValue * noteValueType.rate / noteValue.type.rate
}

/// Defines the duration of a note beatwise.
public struct NoteValue: Codable, CustomStringConvertible {
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

  /// Returns the string representation of the note value.
  public var description: String {
    return "\(type)\(modifier)"
  }
}
