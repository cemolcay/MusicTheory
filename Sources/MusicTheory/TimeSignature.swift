//
//  TimeSignature.swift
//  MusicTheory iOS
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

/// Defines how many beats in a measure with which note value.
public struct TimeSignature: Codable, Hashable, CustomStringConvertible {
  /// Beats per measure.
  public var beats: Int
  /// Note value per beat.
  public var noteValue: NoteValueType

  /// Initilizes the time signature with beats per measure and the value of the notes in beat.
  ///
  /// - Parameters:
  ///   - beats: Number of beats in a measure
  ///   - noteValue: Note value of the beats.
  public init(beats: Int = 4, noteValue: NoteValueType = .quarter) {
    self.beats = beats
    self.noteValue = noteValue
  }

  // MARK: CustomStringConvertible

  public var description: String {
    return "\(beats)/\(Int(noteValue.rate))"
  }
}
