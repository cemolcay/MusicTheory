//
//  Dataset.swift
//  MusicTheory
//
//  Created by Cem Olcay on 01/01/2017.
//  Copyright © 2017 prototapp. All rights reserved.
//

import UIKit

public extension Scale {

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

public extension Chord {

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

public class Dataset {

  public class func generateAllScales() -> [[Int]] {
    var scales = [[Int]]()
    Note.all.forEach({ Scale.all(of: $0).forEach({ scales.append($0.midiKeys) }) })
    return scales
  }

  public class func generateAllChords() -> [[Int]] {
    var chords = [[Int]]()
    Note.all.forEach({ Chord.all(of: $0).forEach({ chords.append($0.midiKeys) }) })
    return chords
  }
}
