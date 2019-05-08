//
//  MusicTheoryTests.swift
//  MusicTheoryTests
//
//  Created by Cem Olcay on 30/12/2016.
//  Copyright © 2016 prototapp. All rights reserved.
//

import MusicTheory
import XCTest

class MusicTheoryTests: XCTestCase {
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
}

// MARK: - Note Tests

extension MusicTheoryTests {
  func testIntervals() {
    let key = Key(type: .c)
    let pitch = Pitch(key: key, octave: 1)
    XCTAssert((pitch + 12).octave == pitch.octave + 1)
    XCTAssert((pitch + 1).key == Key(type: .c, accidental: .sharp))
    XCTAssert((pitch - 1) == Pitch(key: Key(type: .b), octave: 0))

    let c1 = Pitch(key: Key(type: .c), octave: 1)
    let d1 = Pitch(key: Key(type: .d), octave: 1)
    XCTAssert(d1 - c1 == .M2)
  }

  func testAccidentals() {
    XCTAssert(Accidental.flat * 2 == Accidental.doubleFlat)
    XCTAssert(Accidental.doubleFlat / 2 == Accidental.flat)
    XCTAssert(Accidental.sharps(amount: 2) - 2 == Accidental.natural)
    XCTAssert(Accidental.flats(amount: 2) + 2 == 0)
    XCTAssert(Accidental.sharps(amount: 2) + Accidental.sharps(amount: 1) == Accidental.sharps(amount: 3))
    XCTAssert(Accidental(integerLiteral: -3) + Accidental(rawValue: 3)! == 0)
  }

  func testKeys() {
    let d = Key.KeyType.d
    XCTAssert(d.key(at: -2) == .b)
    XCTAssert(d.key(at: -19) == .f)
    XCTAssert(d.key(at: 12) == .b)
    XCTAssert(d.key(at: 0) == .d)
    XCTAssert(d.key(at: 1) == .e)
    XCTAssert(d.key(at: 2) == .f)
    XCTAssert(d.key(at: -3) == .a)
    XCTAssert(d.key(at: -301) == .d)

    let f = Key.KeyType.f
    XCTAssert(f.key(at: -3) == .c)

    let k: Key = "a##b"
    XCTAssert(k.accidental == .sharp && k.type == .a)

    let b = Key(type: .b, accidental: .natural)
    XCTAssert(Key(type: .c, accidental: .flat) == b)
    XCTAssert(Key(type: .c, accidental: .sharps(amount: 23)) == b)
    XCTAssert(Key(type: .c, accidental: .flats(amount: 13)) == b)
    XCTAssert(Key(type: .c, accidental: .flats(amount: 25)) == b)
    XCTAssert(Key(type: .c, accidental: .flats(amount: 24)) != b)
  }

  func testPitches() {
    let c0: Pitch = 12
    XCTAssert(c0.octave == 0 && c0.key.accidental == .natural && c0.key.type == .c)
    XCTAssert(c0 - 12 == 0)

    var pitch = Pitch(midiNote: 127)
    XCTAssert(pitch.key == Key(type: .g))
    pitch = Pitch(midiNote: 0)
    XCTAssert(pitch.key == Key(type: .c))
    pitch = Pitch(midiNote: 66, isPreferredAccidentalSharps: false)
    XCTAssert(pitch.key == Key(type: .g, accidental: .flat))

    let c1 = Pitch(key: Key(type: .c), octave: 1)
    XCTAssert(c1 + .m2 == Pitch(key: Key(type: .d, accidental: .flat), octave: 1))
    XCTAssert(c1 + .M2 == Pitch(key: Key(type: .d, accidental: .natural), octave: 1))
    XCTAssert(c1 + .m3 == Pitch(key: Key(type: .e, accidental: .flat), octave: 1))
    XCTAssert(c1 + .M3 == Pitch(key: Key(type: .e, accidental: .natural), octave: 1))
    XCTAssert(c1 + .P8 == Pitch(key: Key(type: .c, accidental: .natural), octave: 2))

    let d1 = Pitch(key: Key(type: .d), octave: 1)
    XCTAssert(d1 - .m2 == Pitch(key: Key(type: .c, accidental: .sharp), octave: 1))
    XCTAssert(d1 - .M2 == Pitch(key: Key(type: .c, accidental: .natural), octave: 1))

    let p: Pitch = "f#-5"
    XCTAssert(p.key === Key(type: .f, accidental: .sharp))
    XCTAssert(p.octave == -5)
    
    let uppercasePitch: Pitch = "A#3"
    XCTAssert(uppercasePitch.key === Key(type: .a, accidental: .sharp))
    XCTAssert(uppercasePitch.octave == 3)
    
    let uppercasePitch2: Pitch = "F4"
    XCTAssert(uppercasePitch2.key === Key(type: .f, accidental: .natural))
    XCTAssert(uppercasePitch2.octave == 4)
  }

  func testFrequency() {
    let note = Pitch(key: Key(type: .a), octave: 4)
    XCTAssertEqual(note.frequency, 440.0)

    let a4 = Pitch.nearest(frequency: 440.0)
    XCTAssertEqual(note, a4)
  }
}

// MARK: - Tempo Tests

extension MusicTheoryTests {
  func testNoteValueConversions() {
    let noteValue = NoteValue(type: .half, modifier: .dotted)
    XCTAssertEqual(noteValue / NoteValueType.sixteenth, 12)
    XCTAssertEqual(noteValue / NoteValueType.whole, 0.75)
  }

  func testDurations() {
    let timeSignature = TimeSignature(beats: 4, noteValue: .quarter) // 4/4
    let tempo = Tempo(timeSignature: timeSignature, bpm: 120) // 120BPM
    var noteValue = NoteValue(type: .quarter)
    var duration = tempo.duration(of: noteValue)
    XCTAssert(duration == 0.5)

    noteValue.modifier = .dotted
    duration = tempo.duration(of: noteValue)
    XCTAssert(duration == 0.75)
  }

  func testSampleLengthCalcuation() {
    let rates = [
      NoteValue(type: .whole, modifier: .default),
      NoteValue(type: .half, modifier: .default),
      NoteValue(type: .half, modifier: .dotted),
      NoteValue(type: .half, modifier: .triplet),
      NoteValue(type: .quarter, modifier: .default),
      NoteValue(type: .quarter, modifier: .dotted),
      NoteValue(type: .quarter, modifier: .triplet),
      NoteValue(type: .eighth, modifier: .default),
      NoteValue(type: .eighth, modifier: .dotted),
      NoteValue(type: .sixteenth, modifier: .default),
      NoteValue(type: .sixteenth, modifier: .dotted),
      NoteValue(type: .thirtysecond, modifier: .default),
      NoteValue(type: .sixtyfourth, modifier: .default),
    ]

    let tempo = Tempo()
    let sampleLengths = rates
      .map({ tempo.sampleLength(of: $0) })
      .map({ round(100 * $0) / 100 })

    let expected: [Double] = [
      88200.0,
      44100.0,
      66150.0,
      29401.47,
      22050.0,
      33075.0,
      14700.73,
      11025.0,
      16537.5,
      5512.5,
      8268.75,
      2756.25,
      1378.13,
    ]

    XCTAssertEqual(sampleLengths, expected)
  }
}

// MARK: - Scale Tests

extension MusicTheoryTests {
  func testScale() {
    let cMaj: [Key] = [
      Key(type: .c),
      Key(type: .d),
      Key(type: .e),
      Key(type: .f),
      Key(type: .g),
      Key(type: .a),
      Key(type: .b),
    ]

    let cMajScale = Scale(type: .major, key: Key(type: .c))
    XCTAssert(cMajScale.keys == cMaj)

    let cMin: [Key] = [
      Key(type: .c),
      Key(type: .d),
      Key(type: .e, accidental: .flat),
      Key(type: .f),
      Key(type: .g),
      Key(type: .a, accidental: .flat),
      Key(type: .b, accidental: .flat),
    ]

    let cMinScale = Scale(type: .minor, key: Key(type: .c))
    XCTAssert(cMinScale.keys == cMin)
  }

  func testHarmonicFields() {
    let cmaj = Scale(type: .major, key: Key(type: .c))
    let triads = cmaj.harmonicField(for: .triad)
    let triadsExpected = [
      Chord(type: ChordType(third: .major), key: Key(type: .c)),
      Chord(type: ChordType(third: .minor), key: Key(type: .d)),
      Chord(type: ChordType(third: .minor), key: Key(type: .e)),
      Chord(type: ChordType(third: .major), key: Key(type: .f)),
      Chord(type: ChordType(third: .major), key: Key(type: .g)),
      Chord(type: ChordType(third: .minor), key: Key(type: .a)),
      Chord(type: ChordType(third: .minor, fifth: .diminished), key: Key(type: .b)),
    ]
    XCTAssert(triads.enumerated().map({ $1 == triadsExpected[$0] }).filter({ $0 == false }).count == 0)
  }
}

// MARK: - Chord Tests

extension MusicTheoryTests {
  func testChords() {
    let cmajNotes: [Key] = [Key(type: .c), Key(type: .e), Key(type: .g)]
    let cmaj = Chord(type: ChordType(third: .major), key: Key(type: .c))
    XCTAssert(cmajNotes == cmaj.keys)

    let cminNotes: [Key] = [
      Key(type: .c),
      Key(type: .e, accidental: .flat),
      Key(type: .g),
    ]
    let cmin = Chord(type: ChordType(third: .minor), key: Key(type: .c))
    XCTAssert(cminNotes == cmin.keys)

    let c13Notes: [Pitch] = [
      Pitch(key: Key(type: .c), octave: 1),
      Pitch(key: Key(type: .e), octave: 1),
      Pitch(key: Key(type: .g), octave: 1),
      Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
      Pitch(key: Key(type: .d), octave: 2),
      Pitch(key: Key(type: .f), octave: 2),
      Pitch(key: Key(type: .a), octave: 2),
    ]
    let c13 = Chord(
      type: ChordType(
        third: .major,
        seventh: .dominant,
        extensions: [
          ChordExtensionType(type: .thirteenth),
        ]
      ),
      key: Key(type: .c)
    )
    XCTAssert(c13.pitches(octave: 1) === c13Notes)

    let cm13Notes: [Pitch] = [
      Pitch(key: Key(type: .c), octave: 1),
      Pitch(key: Key(type: .e, accidental: .flat), octave: 1),
      Pitch(key: Key(type: .g), octave: 1),
      Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
      Pitch(key: Key(type: .d), octave: 2),
      Pitch(key: Key(type: .f), octave: 2),
      Pitch(key: Key(type: .a), octave: 2),
    ]
    let cm13 = Chord(
      type: ChordType(
        third: .minor,
        seventh: .dominant,
        extensions: [
          ChordExtensionType(type: .thirteenth),
        ]
      ),
      key: Key(type: .c)
    )
    XCTAssert(cm13.pitches(octave: 1) === cm13Notes)

    let minorIntervals: [Interval] = [.P1, .m3, .P5]
    guard let minorChord = ChordType(intervals: minorIntervals.map({ $0 })) else { return XCTFail() }
    XCTAssert(minorChord == ChordType(third: .minor))

    let majorIntervals: [Interval] = [.P1, .M3, .P5]
    guard let majorChord = ChordType(intervals: majorIntervals.map({ $0 })) else { return XCTFail() }
    XCTAssert(majorChord == ChordType(third: .major))

    let cmadd13Notes: [Pitch] = [
      Pitch(key: Key(type: .c), octave: 1),
      Pitch(key: Key(type: .e, accidental: .flat), octave: 1),
      Pitch(key: Key(type: .g), octave: 1),
      Pitch(key: Key(type: .a), octave: 2),
    ]
    let cmadd13 = Chord(
      type: ChordType(
        third: .minor,
        extensions: [ChordExtensionType(type: .thirteenth)]
      ),
      key: Key(type: .c)
    )
    XCTAssert(cmadd13.pitches(octave: 1) === cmadd13Notes)
  }

  func testRomanNumerics() {
    let cmaj = Scale(type: .major, key: Key(type: .c))
    let cmin = Scale(type: .minor, key: Key(type: .c))
    let cmajNumerics = ["I", "ii", "iii", "IV", "V", "vi", "vii°"]
    let cminNumerics = ["i", "ii°", "III", "iv", "v", "VI", "VII"]
    let cmajChords = cmaj.harmonicField(for: .triad)
    let cminChords = cmin.harmonicField(for: .triad)
    XCTAssertEqual(cmajNumerics, cmajChords.compactMap({ $0?.romanNumeric(for: cmaj) }))
    XCTAssertEqual(cminNumerics, cminChords.compactMap({ $0?.romanNumeric(for: cmin) }))
  }

  func testInversions() {
    let c7 = Chord(
      type: ChordType(third: .major, seventh: .dominant),
      key: Key(type: .c)
    )
    let c7Inversions = [
      [
        Pitch(key: Key(type: .c), octave: 1),
        Pitch(key: Key(type: .e), octave: 1),
        Pitch(key: Key(type: .g), octave: 1),
        Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
      ],
      [
        Pitch(key: Key(type: .e), octave: 1),
        Pitch(key: Key(type: .g), octave: 1),
        Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
        Pitch(key: Key(type: .c), octave: 2),
      ],
      [
        Pitch(key: Key(type: .g), octave: 1),
        Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
        Pitch(key: Key(type: .c), octave: 2),
        Pitch(key: Key(type: .e), octave: 2),
      ],
      [
        Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
        Pitch(key: Key(type: .c), octave: 2),
        Pitch(key: Key(type: .e), octave: 2),
        Pitch(key: Key(type: .g), octave: 2),
      ],
    ]
    for (index, chord) in c7.inversions.enumerated() {
      XCTAssert(chord.pitches(octave: 1) === c7Inversions[index])
    }
  }
}

// MARK: - [Pitch] Extension

// A function for checking pitche arrays exactly equal in terms of their pitches keys and octaves.
func === (lhs: [Pitch], rhs: [Pitch]) -> Bool {
  guard lhs.count == rhs.count else { return false }
  for i in 0 ..< lhs.count {
    if lhs[i] === rhs[i] {
      continue
    } else {
      return false
    }
  }
  return true
}
