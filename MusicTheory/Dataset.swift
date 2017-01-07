//
//  Dataset.swift
//  MusicTheory
//
//  Created by Cem Olcay on 01/01/2017.
//  Copyright © 2017 prototapp. All rights reserved.
//

import Foundation

// MARK: - ScaleType Extension

public extension ScaleType {

  /// An array of all `ScaleType` values.
  public static var all: [ScaleType] {
    return [
      .major,
      .minor,
      .harmonicMinor,
      .dorian,
      .phrygian,
      .lydian,
      .mixolydian,
      .locrian
    ]
  }
}

// MARK: - ChordType Extension

public extension ChordType {

  /// An array of all `ChordType` values.
  public static var all: [ChordType] {
    return [
      .maj,
      .min,
      .aug,
      .b5,
      .dim,
      .sus,
      .sus2,
      .M6,
      .m6,
      .dom7,
      .M7,
      .m7,
      .aug7,
      .dim7,
      .M7b5,
      .m7b5
    ]
  }
}

/// Generates all scales and chords in midi key format for neural network training or finding matching notes or something useful.
public class Dataset {

  /// Generates all scales of all notes in midi note format
  ///
  /// - Returns: Returns array of midi note sequences which are also array of `Int`s.
  public class func generateAllScales() -> [[Int]] {
    var scales = [[Int]]()
    for scale in ScaleType.all {
      for note in NoteType.all {
        scales.append(Scale(type: scale, key: note).notes(octave: 0).map({ $0.midiNote }))
      }
    }
    return scales
  }

  /// Generates all chords of all notes in midi key format
  ///
  /// - Returns: Returns array of midi note sequences which are also array of `Int`s.
  public class func generateAllChords() -> [[Int]] {
    var chords = [[Int]]()
    for chord in ChordType.all {
      for note in NoteType.all {
        chords.append(Chord(type: chord, key: note).notes(octave: 0).map({ $0.midiNote }))
      }
    }
    return chords
  }
}
