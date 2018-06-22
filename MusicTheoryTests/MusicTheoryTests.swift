//
//  MusicTheoryTests.swift
//  MusicTheoryTests
//
//  Created by Cem Olcay on 30/12/2016.
//  Copyright © 2016 prototapp. All rights reserved.
//

import XCTest
import MusicTheory

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

  func testHalfstep() {
    let key = Key(type: .c)
    XCTAssert(key + 1 == Key(type: .d, accidental: .flat))
    XCTAssert(key + 11 == Key(type: .b))
    XCTAssert(key + 12 == Key(type: .c))
    let pitch = Pitch(key: key, octave: 1)
    XCTAssert((pitch + 12).octave == pitch.octave + 1)
    XCTAssert((pitch + 1).key == Key(type: .d, accidental: .flat))
    XCTAssert((pitch - 1) == Pitch(key: Key(type: .b), octave: 0))
  }

  func testPitch() {
    var pitch = Pitch(midiNote: 127)
    XCTAssert(pitch.key == Key(type: .g))
    pitch = Pitch(midiNote: 0)
    XCTAssert(pitch.key == Key(type: .c))
    pitch = Pitch(midiNote: 66)
    XCTAssert(pitch.key == Key(type: .g, accidental: .flat))
  }

  func testFrequency() {
    let note = Pitch(key: Key(type: .a), octave: 4)
    XCTAssertEqual(note.frequency, 440.0)
  }

  func testInterval() {
    let b = Pitch(key: Key(type: .b), octave: 1)
    let d = Pitch(key: Key(type: .d), octave: 2)
    XCTAssert(b - d == .m3)
    XCTAssert(d - b == .m3)
    XCTAssert(b - d == 3)
  }

  func testMidiNote() {
    XCTAssert(Pitch(key: Key(type: .c), octave: -1).rawValue == 0)
    XCTAssert(Pitch(key: Key(type: .c), octave: 0).rawValue == 12)
    XCTAssert(Pitch(key: Key(type: .b), octave: 7).rawValue == 107)
    XCTAssert(Pitch(key: Key(type: .g), octave: 9).rawValue == 127)
  }

  func testChords() {
    let cmajNotes: [Key] = [Key(type: .c), Key(type: .e), Key(type: .g)]
    let cmaj = Chord(type: ChordType(third: .major), key: Key(type: .c))
    XCTAssert(cmajNotes == cmaj.keys)
    
    let cminNotes: [Key] = [
      Key(type: .c),
      Key(type: .e, accidental: .flat),
      Key(type: .g)
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
          ChordExtensionType(type: .thirteenth)
        ]),
      key: Key(type: .c))
    XCTAssert(c13.pitches(octave: 1) == c13Notes)

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
          ChordExtensionType(type: .thirteenth)
        ]),
      key: Key(type: .c))
    XCTAssert(cm13.pitches(octave: 1) == cm13Notes)

    let minorIntervals: [Interval] = [.P1, .m3, .P5]
    guard let minorChord = ChordType(intervals: minorIntervals) else { return XCTFail() }
    XCTAssert(minorChord == ChordType(third: .minor))

    let majorIntervals: [Interval] = [.P1, .M3, .P5]
    guard let majorChord = ChordType(intervals: majorIntervals) else { return XCTFail() }
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
        extensions: [ChordExtensionType(type: .thirteenth)]),
      key: Key(type: .c))
    XCTAssert(cmadd13.pitches(octave: 1) == cmadd13Notes)
  }

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

  func testInversions() {
    let c7 = Chord(
      type: ChordType(third: .major, seventh: .dominant),
      key: Key(type: .c))
    let c7Inversions = [
      [
        Pitch(key: Key(type: .c), octave: 1),
        Pitch(key: Key(type: .e), octave: 1),
        Pitch(key: Key(type: .g), octave: 1),
        Pitch(key: Key(type: .b, accidental: .flat), octave: 1)
      ],
      [
        Pitch(key: Key(type: .e), octave: 1),
        Pitch(key: Key(type: .g), octave: 1),
        Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
        Pitch(key: Key(type: .c), octave: 2)
      ],
      [
        Pitch(key: Key(type: .g), octave: 1),
        Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
        Pitch(key: Key(type: .c), octave: 2),
        Pitch(key: Key(type: .e), octave: 2)],
      [
        Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
        Pitch(key: Key(type: .c), octave: 2),
        Pitch(key: Key(type: .e), octave: 2),
        Pitch(key: Key(type: .g), octave: 2)
      ],
    ]
    for (index, chord) in c7.inversions.enumerated() {
      XCTAssert(chord.pitches(octave: 1) == c7Inversions[index])
    }
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

  func testAccidentalals() {
    XCTAssert(Accidental.flat * 2 == Accidental.doubleFlat)
    XCTAssert(Accidental.doubleFlat / 2 == Accidental.flat)
    XCTAssert(Accidental.sharps(amount: 2) - 2 == Accidental.natural)
    XCTAssert(Accidental.flats(amount: 2) + 2 == 0)
    XCTAssert(Accidental.sharps(amount: 2) + Accidental.sharps(amount: 1) == Accidental.sharps(amount: 3))
    XCTAssert(Accidental(integerLiteral: -3) + Accidental(rawValue: 3)! == 0)

    let cSharp = Key(midiNote: 1, isPreferredAccidentalSharps: true)!
    let dFlat = Key(midiNote: 1, isPreferredAccidentalSharps: false)!
    XCTAssert(cSharp.alternative == dFlat.alternative)
    XCTAssert(cSharp === dFlat.alternative!)
    XCTAssert(dFlat === cSharp.alternative!)
  }

  func testKeys() {
    XCTAssert(Key(midiNote: 0) == 0)

    let cSharp = Key(midiNote: 1, isPreferredAccidentalSharps: true)!
    let dFlat = Key(midiNote: 1, isPreferredAccidentalSharps: false)!
    XCTAssert(cSharp.type == .c && cSharp.accidental == .sharp)
    XCTAssert(dFlat.type == .d && dFlat.accidental == .flat)
    XCTAssert(cSharp == dFlat)
  }

  func testPitches() {
    let c0: Pitch = 12
    XCTAssert(c0.octave == 0 && c0.key.accidental == .natural && c0.key.type == .c)
    XCTAssert(c0 - 12 == 0)
  }
}
