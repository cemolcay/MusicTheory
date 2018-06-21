//
//  Tempo.swift
//  MusicTheory
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - Note Value

/// Calculates how many notes of a single `NoteValueType` is equivalent to a given `NoteValue`.
///
/// - Parameters:
///   - noteValue: The note value to be measured.
///   - noteValueType: The note value type to measure the length of the note value.
/// - Returns: Returns how many notes of a single `NoteValueType` is equivalent to a given `NoteValue`.
public func /(noteValue: NoteValue, noteValueType: NoteValueType) -> Double {
  return noteValue.modifier.rawValue * noteValueType.rawValue / noteValue.type.rawValue
}

/// Defines the types of note values.
public enum NoteValueType: Double, Codable {

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

/// Defines the length of a `NoteValue`
public enum NoteModifier: Double, Codable {
  /// No additional length.
  case `default` = 1
  /// Adds half of its own value.
  case dotted = 1.5
  /// Three notes of the same value.
  case triplet = 0.6667
  /// Five of the indicated note value total the duration normally occupied by four.
  case quintuplet = 0.8
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

// MARK: - Time Signature

/// Defines how many beats in a measure with which note value.
public struct TimeSignature: Codable {
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

  /// Initilizes the time signature with beats per measure and the value of the notes in beat. Returns nil if a division is not match a `NoteValue`.
  ///
  /// - Parameters:
  ///   - beats: Number of beats in a measure
  ///   - division: Number of the beats.
  public init?(beats: Int, division: Int) {
    guard let noteValue = NoteValueType(rawValue: Double(division)) else {
      return nil
    }

    self.beats = beats
    self.noteValue = noteValue
  }
}

// MARK: - Tempo

/// Defines the tempo of the music with beats per second and time signature.
public struct Tempo: Codable {
  /// Time signature of music.
  public var timeSignature: TimeSignature

  /// Beats per minutes.
  public var bpm: Double

  /// Initilizes tempo with time signature and BPM.
  ///
  /// - Parameters:
  ///   - timeSignature: Time Signature.
  ///   - bpm: Beats per minute.
  public init(timeSignature: TimeSignature = TimeSignature(), bpm: Double = 120.0) {
    self.timeSignature = timeSignature
    self.bpm = bpm
  }

  /// Caluclates the duration of a note value in seconds.
  public func duration(of noteValue: NoteValue) -> TimeInterval {
    let secondsPerBeat = 60.0 / bpm
    return secondsPerBeat * (timeSignature.noteValue.rawValue / noteValue.type.rawValue) * noteValue.modifier.rawValue
  }

  /// Calculates the note length in samples. Useful for sequencing notes sample accurate in the DSP.
  ///
  /// - Parameters:
  ///   - noteValue: Rate of the note you want to calculate sample length.
  ///   - sampleRate: Number of samples in a second. Defaults to 44100.
  /// - Returns: Returns the sample length of a note value.
  public func sampleLength(of noteValue: NoteValue, sampleRate: Double = 44100.0) -> Double {
    let secondsPerBeat = 60.0 / bpm
    return secondsPerBeat  * sampleRate * ((4 / noteValue.type.rawValue) * noteValue.modifier.rawValue)
  }

  /// Calculates the LFO speed of a note vaule in hertz.
  public func hertz(of noteValue: NoteValue) -> Double {
    return 1 / duration(of: noteValue)
  }
}
