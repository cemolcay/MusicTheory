//: Playground - noun: a place where people can play

import Foundation
import MusicTheory

//: # MusicTheory Playground
//:
//: This page shows the current API for note names, pitches, scales, chords,
//: harmonic fields, and chord recognition.

//: ## Note Names and Enharmonics

let cSharp: NoteName = "C#"
let dFlat: NoteName = "Db"

cSharp
dFlat
cSharp == dFlat
cSharp.isEnharmonic(with: dFlat)
cSharp.enharmonicEquivalents

//: ## Pitches and Intervals

let c4 = Pitch(noteName: .c, octave: 4)
let g4 = c4 + .P5
let b3 = c4 - .m2

c4
g4
b3
c4.frequency()
g4 - c4

//: ## Building Scales

let cMajor = Scale(type: .major, root: .c)
let dMajor = Scale(type: .major, root: .d)
let cSharpHarmonicMinor = Scale(type: .harmonicMinor, root: .cs)
let aMinorPentatonic = Scale(type: .pentatonicMinor, root: .a)

cMajor.noteNames
dMajor.noteNames
cSharpHarmonicMinor.noteNames
aMinorPentatonic.noteNames

// Pitches for a scale in one octave
cMajor.pitches(octave: 4)

// Pitches across multiple octaves
cSharpHarmonicMinor.pitches(octaves: [3, 4])

//: ## Modes and Relatives

let dDorian = cMajor.mode(2)
let ePhrygian = cMajor.mode(3)

dDorian?.noteNames
ePhrygian?.noteNames
cMajor.relativeMinor?.noteNames
Scale(type: .minor, root: .c).relativeMajor?.noteNames

//: ## Chords

let cMajorChord = Chord(type: .major, root: .c)
let gDominant13 = Chord(type: .dominant13, root: .g)
let bHalfDiminished = Chord(type: .halfDiminished7, root: .b)

cMajorChord.notation
gDominant13.notation
bHalfDiminished.notation

cMajorChord.noteNames
gDominant13.noteNames
gDominant13.pitches(octave: 3)

// Inversion notation uses the actual bass note.
var firstInversionC = Chord(type: .major, root: .c)
firstInversionC.inversion = 1
firstInversionC.notation
firstInversionC.pitches(octave: 4)

// Explicit slash chord
let cOverE = Chord(type: .major, root: .c, bass: .e)
cOverE.notation

//: ## Chord Types from Intervals

let detectedMinor = ChordType.from(intervals: [.P1, .m3, .P5])
let detectedDominant9 = ChordType.from(intervals: [.P1, .M3, .P5, .m7, .M9])

detectedMinor
detectedDominant9

//: ## Chord Recognition

let recognizedFromNames = Chord.identify(noteNames: [.c, .e, .g, .bb])
let recognizedFromMidi = Chord.identify(midiNotes: [60, 64, 67, 70])

recognizedFromNames
recognizedFromNames.first?.chord.notation
recognizedFromNames.first?.confidence

recognizedFromMidi
recognizedFromMidi.first?.chord.notation

//: ## Time and Duration

let timeSignature = TimeSignature(beats: 6, beatUnit: 8)
let tempo = Tempo(timeSignature: timeSignature, bpm: 120)
let dottedQuarter = NoteValue(type: .quarter, modifier: .dotted)

timeSignature
timeSignature.isCompound
tempo.duration(of: dottedQuarter)
tempo.sampleLength(of: dottedQuarter)
