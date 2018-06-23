//: Playground - noun: a place where people can play

import Foundation
import MusicTheory

extension Pitch {
  public func convert(to keyType: Key.KeyType, for interval: Interval, isHigher: Bool) -> Pitch {
  // Set target octave
  var targetOctave = octave
  if isHigher {
    if keyType.rawValue < key.type.rawValue {
      targetOctave += 1
    }
  } else {
    if keyType.rawValue > key.type.rawValue {
      targetOctave -= 1
    }
  }

  // Set target pitch
  let currentPitch = self + interval
  var targetPitch = Pitch(key: Key(type: keyType), octave: targetOctave)
  let diff = currentPitch.rawValue - targetPitch.rawValue
  targetPitch.key.accidental = Accidental(integerLiteral: diff)
  return targetPitch
}
}

let cSharp = Pitch(key: Key(type: .c, accidental: .sharp), octave: 1)

(cSharp + .M3).convert(to: .e, isHigher: true)
cSharp.convert(to: .e, for: .M3, isHigher: true)

(cSharp + .M2).convert(to: .d, isHigher: true)
cSharp.convert(to: .d, for: .M2, isHigher: true)

(cSharp + .M7).convert(to: .b, isHigher: true)
cSharp.convert(to: .b, for: .M7, isHigher: true)

let cSharpMajor = Scale(type: .harmonicMinor, key: Key(type: .d, accidental: .flat))
cSharpMajor.pitches(octave: 1).forEach({ print($0) })
