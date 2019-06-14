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
public enum NoteValueType: Double, Codable, CaseIterable {
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

// MARK: - NoteModifier

/// Defines the length of a `NoteValue`
public enum NoteModifier: Double, Codable, CaseIterable {
  /// No additional length.
  case `default` = 1
  /// Adds half of its own value.
  case dotted = 1.5
  /// Three notes of the same value.
  case triplet = 0.6667
  /// Five of the indicated note value total the duration normally occupied by four.
  case quintuplet = 0.8
}

// MARK: - NoteValue

/// Calculates how many notes of a single `NoteValueType` is equivalent to a given `NoteValue`.
///
/// - Parameters:
///   - noteValue: The note value to be measured.
///   - noteValueType: The note value type to measure the length of the note value.
/// - Returns: Returns how many notes of a single `NoteValueType` is equivalent to a given `NoteValue`.
public func / (noteValue: NoteValue, noteValueType: NoteValueType) -> Double {
  return noteValue.modifier.rawValue * noteValueType.rawValue / noteValue.type.rawValue
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
