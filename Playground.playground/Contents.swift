//: Playground - noun: a place where people can play

import Foundation
import MusicTheory

// 0, 1, 2, 3, 4, 5, 6, 0, 1, 2, 3, 4, 5, 6, 0, 1, 2, 3, 4, 5, 6, 0, 1, 2, 3, 4, 5, 6
// c, d, e, f, g, a, b, c, d, e, f, g, a, b, c, d, e, f, g, a, b, c, d, e, f, g, a, b

extension Scale {

  public func harmonicField(for field: HarmonicField, inversion: Int = 0) -> [Chord?] {
    var chords = [Chord?]()

    let octaves = [0, 1, 2, 3, 4]
    let scalePitches = pitches(octaves: octaves)

    for i in 0..<scalePitches.count/octaves.count {
      var chordPitches = [Pitch]()
      switch field {
      case .triad:
        chordPitches = [scalePitches[i], scalePitches[i + 2], scalePitches[i + 4]]
      case .tetrad:
        chordPitches = [scalePitches[i], scalePitches[i + 2], scalePitches[i + 4], scalePitches[i + 6]]
      case .ninth:
        chordPitches = [scalePitches[i + 0], scalePitches[i + 2], scalePitches[i + 4], scalePitches[i + 6], scalePitches[i + 8]]
      case .eleventh:
        chordPitches = [scalePitches[i + 0], scalePitches[i + 2], scalePitches[i + 4], scalePitches[i + 6], scalePitches[i + 8], scalePitches[i + 10]]
      case .thirteenth:
        chordPitches = [scalePitches[i + 0], scalePitches[i + 2], scalePitches[i + 4], scalePitches[i + 6], scalePitches[i + 8], scalePitches[i + 10], scalePitches[i + 12]]
      }

      print(chordPitches)
      let root = chordPitches[0]
      let intervals = chordPitches.map({ $0 - root })
      print(intervals)
      if let chordType = ChordType(intervals: intervals) {
        let chord = Chord(type: chordType, key: root.key, inversion: inversion)
        chords.append(chord)
      } else {
        chords.append(nil)
      }
    }

    return chords
  }
}

let cMajor = Scale(type: .chromatic, key: Key(type: .c, accidental: .natural))
cMajor.harmonicField(for: .triad).forEach({ print($0?.notation) })

let b0 = Pitch(key: Key(type: .b, accidental: .natural), octave: 0)
let e1 = Pitch(key: Key(type: .e, accidental: .natural), octave: 1)
b0 - e1
