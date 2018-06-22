//: Playground - noun: a place where people can play

import Foundation
import MusicTheory

let dFlat = Key(type: .d, accidental: .flat)
let d = Key(type: .d, accidental: .natural)

let dFlatHarmonicMinor = Scale(type: .harmonicMinor, key: dFlat)
let dHarmonicMinor = Scale(type: .harmonicMinor, key: d)
Scale(type: .pentatonicBlues, key: d)
