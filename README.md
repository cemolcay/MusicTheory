MusicTheory
===

A music theory library with `Note`, `Interval`, `Scale` and `Chord` representations in swift enums.

Requirements
----
* Swift 3
* Xcode 8
* iOS 8.0+
* macOS 10.9+
* tvOS 9.0+
* watchOS 2.0+

Install
----

```
pod 'MusicTheorySwift'
```

Usage
----

Usage is pretty straitforward. Just import the package and use directly.

```
import MusicTheory
```

### Note

- C, D♭, D, E♭, E, F, G♭, G, A♭, A, B♭ and B notes.
- Could calculate ideal frequancy based on `A4 = 440Hz` piano for given octave..
- Could calculate midi note in range of [0 - 127] for octaves [0 - 10].
- Could calculate piano key value on a 88 key piano for given octave.
- Could calculate next or previous notes for given `Interval` or `Tone`.

```
let d: NoteType = .d
let c = Note(type: .c, octave: 0)
```

### Scale

- Major, minor, harmonic minor, dorian, locrian, mixolydian, lydian, phrygian scales.
- Could create custom scale with base key and intervals like `.custom(key: .c, intervals: [.m2, .M3, .d5, .P5])`.
- Could create midi note sequance of the whole scale.
- Could create `Note`s of the scale starting from the key and going forward by intervals from there.

```
let c: NoteType = .c
let maj: ScaleType = .major
let cMaj = Scale(type: maj, key: c)
```

### Chord

- Major, minor, diminished, augmented, sixth, seventh and more popular chords.
- Could create custom chord with base key and intervals like `.custom(key: .c, intervals: [.m2, .M3, .P5])`
- Could create midi note sequance of the chord.
- Could create `Note`s of the chord.

```
let c: NoteType = .c
let maj: ChordType = .maj
let cMaj = Chord(type: maj, key: c)
```

### Interval

- unison, m2, M2, m3, M3, P4, A4, d5, P5, A5, m6, M6, d7, m7, M7, A7 and P8 intervals.
- Have degree and halfsteps.
- Could create custom interval.
- Used in creation of `Scale`s and `Chord`s.

### Documentation

Documentation created with jazzy, hosted on [github pages](https://cemolcay.github.io/MusicTheory/)

### Unit Tests

You can find unit tests in `MusicTheoryTests` target.  
Press `⌘+U` for running tests.
