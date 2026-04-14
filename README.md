MusicTheory
===

A music theory library with `NoteName`, `Pitch`, `Interval`, `Scale` and `Chord` representations in Swift.

Requirements
----
* Swift 5.0+
* iOS 13.0+
* macOS 10.15+
* tvOS 13.0+
* watchOS 6.0+

Install
----

### Swift Package Manager

``` swift
let package = Package(
  name: "...",
  dependencies: [
    .package(url: "https://github.com/cemolcay/MusicTheory.git", from: "2.0.0")
  ],
  targets: [
    .target(name: "...", dependencies: ["MusicTheory"])
  ]
)
```

### CocoaPods

```
pod 'MusicTheorySwift'
```

Usage
----

`MusicTheory` provides strongly-typed, correct-by-construction primitives for music theory. All types conform to `Codable`, `Hashable`, `Sendable` and `CustomStringConvertible`.

Equality is **structural** throughout: `C#` ≠ `D♭`. Use `isEnharmonic(with:)` wherever you want sound-based comparison.

#### `NoteName` and `LetterName`

`NoteName` is a letter (A–G) combined with an `Accidental`. Accidentals are a struct wrapping a single `semitones: Int` — no degenerate states possible.

``` swift
let cSharp = NoteName(letter: .c, accidental: .sharp)  // C#
let dFlat  = NoteName(letter: .d, accidental: .flat)   // Db

cSharp == dFlat                        // false — structural equality
cSharp.isEnharmonic(with: dFlat)       // true  — same pitch class

// Convenience constants
let root: NoteName = .fs               // F#
let flat: NoteName = "Bb"             // string literal

// Accidental arithmetic
let doubleSharp = Accidental.sharp + Accidental.sharp  // ##
let natural: Accidental = 0
```

#### `Pitch`

A `NoteName` combined with an octave number. Middle C is `C4` (MIDI 60).

``` swift
let c4  = Pitch(noteName: .c, octave: 4)
let a4  = Pitch(noteName: .a, octave: 4)

a4.midiNoteNumber           // 69
a4.frequency()              // 440.0 Hz
a4.frequency(a4: 432.0)     // 432.0 Hz (custom tuning)

// Transposition with correct enharmonic spelling
let d4 = c4 + .M2           // D4
let b3 = c4 - .m2           // B3

// Interval between pitches — handles B→C correctly
let b3pitch = Pitch(noteName: .b, octave: 3)
b3pitch.interval(to: c4)    // m2 (minor second, not a major seventh)

// MIDI and string literals
let pitch: Pitch = 60       // C4
let gFlat3: Pitch = "Gb3"  // G♭3

// Enharmonic comparison
let cs4 = Pitch(noteName: .cs, octave: 4)
let db4 = Pitch(noteName: .db, octave: 4)
cs4 == db4                          // false — structural
cs4.isEnharmonic(with: db4)         // true  — same MIDI note

// Nearest pitch from frequency
let nearest = Pitch.nearest(frequency: 440.0)  // A4
```

#### `Interval`

Intervals are defined by a `Quality` and a `degree`. Semitones are always **computed** — never stored — so invalid combinations are unrepresentable.

``` swift
Interval.M3.semitones   // 4
Interval.P5.semitones   // 7
Interval.m7.semitones   // 10
Interval.P8.semitones   // 12
Interval.M9.semitones   // 14

// Validated construction
let tritone = Interval(quality: .augmented, degree: 4)  // A4, 6 semitones
let invalid = Interval(quality: .minor, degree: 1)      // nil — minor unison doesn't exist

// Inversion
Interval.M3.inverted    // m6
Interval.P4.inverted    // P5

// Enharmonic (same semitones, different quality/degree)
Interval.A4.isEnharmonic(with: .d5)  // true
Interval.A4 == Interval.d5           // false — structurally different
```

#### `ScaleType` and `Scale`

`ScaleType` is a lightweight named interval preset for common built-in scales. `Scale` is the flexible construction API: you can build a scale from a predefined `ScaleType` or provide your own interval collection directly.

``` swift
// Built-in scale types
let cMajor = Scale(type: .major, root: .c)
cMajor.noteNames  // [C, D, E, F, G, A, B]

let dMajor = Scale(type: .major, root: .d)
dMajor.noteNames  // [D, E, F#, G, A, B, C#] — correctly spelled with sharps, not flats

let cMinor = Scale(type: .minor, root: .c)
cMinor.noteNames  // [C, D, Eb, F, G, Ab, Bb]

// Custom scale construction without predefined catalogs or validation
let custom = Scale(
    intervals: [.P1, .m2, .P4, .P5],
    root: .d,
    name: "Custom Tetrachord"
)
custom.noteNames  // [D, Eb, G, A]

// Scale type equality is by intervals
ScaleType.major == ScaleType.ionian          // true
ScaleType.lydianDominant.intervals           // [P1, M2, M3, A4, P5, M6, m7]
```

#### `ChordType` and `Chord`

`ChordType` is a `Set<ChordComponent>`. Building from intervals returns a `Result` so failures are explicit, not silent. Chord symbols use canonical formatting for extended chords (`9`, `Maj9`, `m9`, `11`, `13`, etc.).

``` swift
// Predefined types
let maj  = ChordType.major        // M
let min7 = ChordType.minor7       // m7
let dom9 = ChordType.dominant9    // 9
let maj9 = ChordType.major9       // Maj9
let min9 = ChordType.minor9       // m9

// Build from intervals — returns Result
switch ChordType.from(intervals: [.P1, .m3, .P5]) {
case .success(let type): print(type.symbol)   // "m"
case .failure(let err):  print(err)
}

// Chord with root
let cMaj  = Chord(type: .major,   root: .c)
let gDom7 = Chord(type: .dominant7, root: .g)

cMaj.noteNames           // [C, E, G]
cMaj.notation            // "C"
gDom7.notation           // "G7"

// Slash chord
let cOverE = Chord(type: .major, root: .c, bass: .e)
cOverE.notation          // "C/E"

// Pitches in any octave
cMaj.pitches(octave: 4)  // [C4, E4, G4]

// Inversions
let inversions = gDom7.inversions   // [G7, G7/B, G7/D, G7/F]

var firstInversion = Chord(type: .major, root: .c)
firstInversion.inversion = 1
firstInversion.notation  // "C/E"

// Voicings
cMaj.voiced(.drop2,    octave: 4)
cMaj.voiced(.rootless, octave: 4)
```

#### Chord Recognition

Identify a chord from note names or MIDI note numbers. Results are sorted deterministically for the same input.

``` swift
// From note names
let results = Chord.identify(noteNames: [.c, .e, .g])
results.first?.chord.notation   // "C"
results.first?.confidence       // 1.0

// From MIDI notes — use .flats for minor/dominant chords
let minor = Chord.identify(midiNotes: [60, 63, 67], spelling: .flats)
minor.first?.chord.notation     // "Cm"

// Each result carries assumptions made
for id in Chord.identify(noteNames: [.c, .g]) {
    print("\(id.chord.notation) [\(id.confidence)] \(id.assumptions)")
}
```

#### `Tempo` and `TimeSignature`

``` swift
let ts   = TimeSignature(beats: 4, beatUnit: 4)   // 4/4
ts.description   // "4/4"
ts.isCompound    // false

let ts68 = TimeSignature(beats: 6, beatUnit: 8)   // 6/8
ts68.isCompound  // true

let tempo = Tempo(timeSignature: ts, bpm: 120)

let quarter = NoteValue(type: .quarter)
tempo.duration(of: quarter)     // 0.5 seconds
tempo.sampleLength(of: quarter) // 22050.0 samples @ 44100 Hz

// Note modifiers use exact fractions
NoteModifier.triplet.multiplier      // 2.0/3.0 (exact)
NoteModifier.doubleDotted.multiplier // 1.75
NoteModifier.septuplet.multiplier    // 4.0/7.0
```

Playgrounds
----

- Clone the project and open it in Xcode.
- Build the Mac target.
- Open the Playground page in the project navigator.
- Select the macOS platform and **Build Active Scheme** in Playground settings.

Unit Tests
----

45 tests covering all primitives. Run with `swift test` or `⌘U` in Xcode.

AppStore
----

This library is battle-tested in production across iOS, macOS, watchOS and tvOS:  
[KeyBud](https://itunes.apple.com/us/app/keybud-music-theory-app/id1203856335?mt=8) (iOS, watchOS, tvOS, macOS)  
[FretBud](https://itunes.apple.com/us/app/fretbud-chord-scales-for-guitar-bass-and-more/id1234224249?mt=8) (iOS, watchOS, tvOS)  
[ChordBud](https://itunes.apple.com/us/app/chordbud-chord-progressions/id1313017378?mt=8) (iOS)  
[ArpBud](https://itunes.apple.com/us/app/arpbud-midi-sequencer-more/id1349342326?ls=1&mt=8) (iOS)  
[ScaleBud](https://itunes.apple.com/us/app/scalebud-auv3-midi-keyboard/id1409125865?ls=1&mt=8) (iOS, AUv3, M1)  
[StepBud](https://itunes.apple.com/us/app/stepbud-auv3-midi-sequencer/id1453104408?mt=8) (iOS, AUv3, M1)  
[RhythmBud](https://apps.apple.com/us/app/rhythmbud-auv3-midi-fx/id1484320891#) (iOS, AUv3, M1)  
[ArpBud 2](https://apps.apple.com/us/app/arpbud-2-auv3-midi-arpeggiator/id1500403326) (iOS, AUv3, M1)  
[ChordBud 2](https://apps.apple.com/us/app/chordbud-2-auv3-midi-sequencer/id1526221230) (iOS, AUv3, M1)  
[LoopBud](https://apps.apple.com/us/app/loopbud-auv3-midi-recorder/id1554773709) (iOS, AUv3, M1)  
[Euclid Goes to Party](https://apps.apple.com/us/app/euclid-goes-to-party-auv3-bass/id1565732327) (iOS, AUv3, M1)  
[SnakeBud](https://apps.apple.com/us/app/snakebud-auv3-midi-sequencer/id1568600625) (iOS, AUv3, M1)  
[MelodyBud](https://apps.apple.com/us/app/melodybud-auv3-midi-sequencer/id1601357369) (iOS, AUv3, M1)  
[ScaleBud 2](https://apps.apple.com/us/app/scalebud-2-auv3-midi-keyboard/id1605842538) (iOS, AUv3, M1)  
[ShiftBud](https://apps.apple.com/us/app/shiftbud-generative-midi-auv3/id1616169031) (iOS, AUv3, M1)  
[PolyBud](https://apps.apple.com/us/app/polybud-polyrhythmic-sequencer/id1624211288) (iOS, AUv3, M1)  
[PatternBud](https://apps.apple.com/us/app/patternbud-midi-cc-sequencer/id1608966928) (iOS, AUv3, M1)  
[MIDI Motion](https://apps.apple.com/us/app/midi-motion-for-apple-watch/id6444314230) (iOS, watchOS)  
[Textquencer](https://apps.apple.com/us/app/textquencer-auv3-midi/id1661316322) (iOS, AUv3, M1)  
[In Theory](https://apps.apple.com/us/app/in-theory-interval-keyboard/id1667984658) (iOS, AUv3, M1)  
[BrainBud](https://apps.apple.com/us/app/brainbud-bud-app-controller/id6446066258) (iOS, AUv3, M1)  
[Binarhythmic](https://apps.apple.com/us/app/binarhythmic-rhythm-generator/id6447797078) (iOS, AUv3, M1)  
[Auto Bass](https://apps.apple.com/us/app/auto-bass-auv3-midi-generator/id6450610419) (iOS, AUv3, M1)  
[BounceBud](https://apps.apple.com/us/app/bouncebud-physics-based-midi/id6464171933) (iOS, AUv3, M1)  
[MuseBud](https://apps.apple.com/us/app/musebud-auv3-midi-generator/id6472487197) (iOS, AUv3, M1)  
[Auto Fills](https://apps.apple.com/us/app/auto-fills-drum-fill-generator/id6476319733) (iOS, AUv3, M1)  
[Kebarp](https://apps.apple.com/us/app/kebarp-auv3-midi-arpeggiator/id6479562640) (iOS, AUv3, M1)  
[FuncBud](https://apps.apple.com/us/app/funcbud-generative-sequencer/id6502771916) (iOS, AUv3, M1)  
[Note to Be](https://apps.apple.com/us/app/note-to-be-midi-quantizer/id6596771972) (iOS, AUv3, M1)  
[Harmonicc](https://apps.apple.com/us/app/harmonicc-chord-sequencer-auv3/id6692624491) (iOS, AUv3, M1)  
