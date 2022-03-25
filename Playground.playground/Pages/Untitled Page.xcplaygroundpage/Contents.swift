//: Playground - noun: a place where people can play

import Foundation
import MusicTheory

let p: Pitch = "cb2"
let b: Key = "b"
p.key == b

let ds: Key = "d#"
let eb: Key = "eb"
ds == eb
ds === eb

// e f f# g g# a a# b c c# d d#
Pitch(key: Key(type: .e, accidental: .natural), octave: 0) - .A5
Pitch(key: Key(type: .e, accidental: .natural), octave: 0) - .d5
Pitch(key: Key(type: .e, accidental: .natural), octave: 0) + .A5
Pitch(key: Key(type: .e, accidental: .natural), octave: 0) + .d5

// c# d d# e f f# g g# a a# b c
let cSharpHarmonicMinor = Scale(type: .harmonicMinor, key: Key(type: .c, accidental: .sharp))
Pitch(key: Key(type: .c, accidental: .sharp), octave: 0) + .M7
Pitch(key: Key(type: .b, accidental: .natural), octave: 1) - .M7

// A minor pentatonic triads
let aminP = Scale(type: .pentatonicMinor, key: "a")
let aminPtriad = aminP.harmonicField(for: .thirteenth)
print(aminPtriad)

// chord progression for C# harmonic minor triads
let progression = ChordProgression.i_ii_vi_iv
let cSharpHarmonicMinorTriadsProgression = progression.chords(
  for: cSharpHarmonicMinor,
  harmonicField: .triad,
  inversion: 0
)
print(cSharpHarmonicMinorTriadsProgression)

let c13 = Chord(
  type: ChordType(
    third: .major,
    fifth: .perfect,
    sixth: nil,
    seventh: .dominant,
    suspended: nil,
    extensions: [
      ChordExtensionType(type: .thirteenth, accidental: .natural),
    ]
  ),
  key: Key(
    type: .c,
    accidental: .natural
  )
)

let cdim7 = Chord(
  type: ChordType(
    third: .major,
    fifth: .diminished,
    seventh: .diminished),
  key: Key(type: .c))
cdim7.notation
print(cdim7.keys)

print(c13.type.intervals)
Pitch(key: Key(type: .c, accidental: .natural), octave: 1) + .M9
print(c13.pitches(octave: 1))
print(c13.inversions[1].pitches(octave: 1))

var dmajor = Scale(type: .major, key: Key(type: .d, accidental: .natural))
print(dmajor.pitches(octave: 1))

// d d# e f f# g g# a a# b c c#
Pitch(key: Key(type: .d, accidental: .natural), octave: 1) + .M7
Interval.M7.degree
Interval.M7.semitones

// c c# d d# e f f# g g# a a# b c c# d
Pitch(key: Key(type: .c, accidental: .natural), octave: 1) + .M9
Interval.M9.degree
Interval.M9.semitones

// bb b c cb d db e f gb g ab a bb b c
Pitch(key: Key(type: .b, accidental: .flat), octave: 1) + .M9

Pitch(key: Key(type: .c, accidental: .natural), octave: 3) - .M9

let aHarmonicMinor = Scale(type: .harmonicMinor, key: Key(type: .a))
print(aHarmonicMinor)
let harmonicFunctions = HarmonicFunctions(scale: aHarmonicMinor)
HarmonicFunctionType.allCases.forEach({ type in
  let relatedKeys = type.direction.map({ related in
    harmonicFunctions.harmonicFunction(for: related)!
  })
  print(type, relatedKeys)
})

func nearestKey(key: Key, scale: Scale) -> Key {
    var nearest = key
    var distance = 100
    let keyValue = key.type.rawValue + key.accidental.rawValue
    for scaleKey in scale.keys {
        let scaleKeyValue = scaleKey.type.rawValue + scaleKey.accidental.rawValue
        let diff = abs(scaleKeyValue - keyValue)
        if diff < distance {
            distance = diff
            nearest = scaleKey
        }
    }
    return nearest
}

nearestKey(key: "f", scale: dmajor)

