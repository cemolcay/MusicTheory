//: Playground - noun: a place where people can play

import Foundation
import MusicTheory

let cMajor = Scale(type: .major, key: Key(type: .c, accidental: .natural))
cMajor.harmonicField(for: .triad).forEach({ print($0?.notation) })

let b0 = Pitch(key: Key(type: .b, accidental: .natural), octave: 0)
let e1 = Pitch(key: Key(type: .e, accidental: .natural), octave: 1)
b0 - e1
