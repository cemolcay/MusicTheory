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

  func testHalfstep() {
    let noteType: NoteType = .c
    XCTAssert(noteType + 1 == .dFlat)
    XCTAssert(noteType + 11 == .b)
    XCTAssert(noteType + 12 == .c)
    let note: Note = Note(type: noteType, octave: 1)
    XCTAssert((note + 12).octave == note.octave + 1)
    XCTAssert((note + 1).type == .dFlat)
    XCTAssert((note - 1) == Note(type: .b, octave: 0))
  }

  func testNote() {
    var note = Note(midiNote: 127)
    XCTAssert(note.type == .g)
    note = Note(midiNote: 0)
    XCTAssert(note.type == .c)
    note = Note(midiNote: 66)
    XCTAssert(note.type == .gFlat)
  }

  func testInterval() {
    let note: NoteType = .c
    XCTAssert(note + .P8 == note)
    XCTAssert(note + .M2 == .d)
    XCTAssert(note + .m2 == .dFlat)
		
		let b = Note(type: .b, octave: 1)
		let d = Note(type: .d, octave: 2)
		XCTAssert(b - d == .m3)
		XCTAssert(d - b == .m3)
  }

  func testPianoKey() {
    XCTAssert(Note(type: .c, octave: 0).pianoKey == 4)
    XCTAssert(Note(type: .a, octave: -1).pianoKey == 1)
    XCTAssert(Note(type: .a, octave: 3).pianoKey == 49)
  }

  func testMidiNote() {
    XCTAssert(Note(type: .c, octave: 0).midiNote == 0)
    XCTAssert(Note(type: .c, octave: 1).midiNote == 12)
    XCTAssert(Note(type: .b, octave: 8).midiNote == 107)
    XCTAssert(Note(type: .g, octave: 10).midiNote == 127)
  }

  func testScale() {
    let cMaj: [NoteType] = [.c, .d, .e, .f, .g, .a, .b]
    let cMajScale = Scale(type: .major, key: .c)
    XCTAssert(cMajScale.noteTypes == cMaj)
    let cMin: [NoteType] = [.c, .d, .eFlat, .f, .g, .aFlat, .bFlat]
    let cMinScale = Scale(type: .minor, key: .c)
    XCTAssert(cMinScale.noteTypes == cMin)
  }

	func testHarmonicFields() {
		let cmaj = Scale(type: .major, key: .c)
		let cChords = cmaj.harmonicField(for: .triad)
		let cChordsExpected = [
			Chord(type: .maj, key: .c),
			Chord(type: .min, key: .d),
			Chord(type: .min, key: .e),
			Chord(type: .maj, key: .f),
			Chord(type: .maj, key: .g),
			Chord(type: .min, key: .a),
			Chord(type: .dim, key: .b),
			]
		XCTAssert(cChords == cChordsExpected)
	}

  func testChords() {
    let cmajNotes: [NoteType] = [.c, .e, .g]
    let cmaj = Chord(type: .maj, key: .c)
    XCTAssert(cmajNotes == cmaj.noteTypes)
    let cminNotes: [NoteType] = [.c, .eFlat, .g]
    let cmin = Chord(type: .min, key: .c)
    XCTAssert(cminNotes == cmin.noteTypes)
		let c13Notes: [Note] = [
			Note(type: .c, octave: 1),
			Note(type: .e, octave: 1),
			Note(type: .g, octave: 1),
			Note(type: .bFlat, octave: 1),
			Note(type: .d, octave: 2),
			Note(type: .f, octave: 2),
			Note(type: .a, octave: 2)]
		let c13 = Chord(type: .dom13, key: .c)
		XCTAssert(c13.notes(octave: 1) == c13Notes)
		let cm13Notes: [Note] = [
			Note(type: .c, octave: 1),
			Note(type: .eFlat, octave: 1),
			Note(type: .g, octave: 1),
			Note(type: .bFlat, octave: 1),
			Note(type: .d, octave: 2),
			Note(type: .f, octave: 2),
			Note(type: .a, octave: 2)]
		let cm13 = Chord(type: .m13, key: .c)
		XCTAssert(cm13.notes(octave: 1) == cm13Notes)

		let minorIntervals: [Interval] = [.unison, .m3, .P5]
		let minorChord = ChordType(intervals: minorIntervals)
		XCTAssert(minorChord == .min)
		let majorIntervals: [Interval] = [.unison, .M3, .P5]
		let majorChord = ChordType(intervals: majorIntervals)
		XCTAssert(majorChord == .maj)
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
    let c7 = Chord(type: .dom7, key: .c)
    let c7Inversions = [
      [Note(type: .e, octave: 1), Note(type: .g, octave: 1), Note(type: .bFlat, octave: 1), Note(type: .c, octave: 2)],
      [Note(type: .g, octave: 1), Note(type: .bFlat, octave: 1), Note(type: .c, octave: 2), Note(type: .e, octave: 2)],
      [Note(type: .bFlat, octave: 1), Note(type: .c, octave: 2), Note(type: .e, octave: 2), Note(type: .g, octave: 2)],
    ]
    for (index, chord) in c7.inversions.enumerated() {
      XCTAssert(chord.notes(octave: 1) == c7Inversions[index])
    }
  }
}
