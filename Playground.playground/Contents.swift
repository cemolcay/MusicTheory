//: Playground - noun: a place where people can play

import Foundation
import MusicTheory

let c1 = Pitch(key: Key(type: .c, accidental: .sharp), octave: 1)
let d1 = Pitch(key: Key(type: .e, accidental: .doubleFlat), octave: 1)
d1 - c1

for key in Key.keysWithFlats {
  let first = Pitch(key: Key.keysWithFlats[0], octave: 1)
  let pitch = Pitch(key: key, octave: 1)
  print(first - pitch)
}
