//
//  Dataset.swift
//  MusicTheory
//
//  Created by Cem Olcay on 01/01/2017.
//  Copyright © 2017 prototapp. All rights reserved.
//

import UIKit

// MARK: - Scale Extension
public extension Scale {

  /// Generates an array of all `Scale` values based on desired `Note`.
  ///
  /// - Parameter key: The `Note` value of scales base.
  /// - Returns: All scales in desired key `Note`.
  public static func all(of key: Note) -> [Scale] {
    return [
      .major(key: key),
      .minor(key: key),
      .harmonicMinor(key: key),
      .dorian(key: key),
      .phrygian(key: key),
      .lydian(key: key),
      .mixolydian(key: key),
      .locrian(key: key)
    ]
  }
}

// MARK: - Chord Extension
public extension Chord {


  /// Generates an array of all `Chord` values based on desired `Note`.
  ///
  /// - Parameter key: The `Note` value of chords base.
  /// - Returns: All Chords in desired key `Note`.
  public static func all(of key: Note) -> [Chord] {
    return [
      .maj(key: key),
      .min(key: key),
      .aug(key: key),
      .b5(key: key),
      .dim(key: key),
      .sus(key: key),
      .sus2(key: key),
      .M6(key: key),
      .m6(key: key),
      .dom7(key: key),
      .M7(key: key),
      .m7(key: key),
      .aug7(key: key),
      .dim7(key: key),
      .M7b5(key: key),
      .m7b5(key: key)
    ]
  }
}


/// Generates all scales and chords in midi key format for neural network training or finding matching notes or something useful.
public class Dataset {


  /// Generates all scales of all notes in midi key format
  ///
  /// - Returns: Returns array of midi key sequences which are also array of `Int`s.
  public class func generateAllScales() -> [[Int]] {
    var scales = [[Int]]()
    Note.all.forEach({ Scale.all(of: $0).forEach({ scales.append($0.midiKeys) }) })
    return scales
  }

  /// Generates all chords of all notes in midi key format
  ///
  /// - Returns: Returns array of midi key sequences which are also array of `Int`s.
  public class func generateAllChords() -> [[Int]] {
    var chords = [[Int]]()
    Note.all.forEach({ Chord.all(of: $0).forEach({ chords.append($0.midiKeys) }) })
    return chords
  }
}
