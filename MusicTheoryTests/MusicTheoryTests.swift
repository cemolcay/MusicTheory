//
//  MusicTheoryTests.swift
//  MusicTheoryTests
//
//  Created by Cem Olcay on 30/12/2016.
//  Copyright © 2016 prototapp. All rights reserved.
//

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

  func testChords() {
    let cmajNotes: [NoteType] = [.c, .e, .g]
    let cmaj = Chord(type: .maj, key: .c)
    XCTAssert(cmajNotes == cmaj.noteTypes)
    let cminNotes: [NoteType] = [.c, .eFlat, .g]
    let cmin = Chord(type: .min, key: .c)
    XCTAssert(cminNotes == cmin.noteTypes)
  }
}
