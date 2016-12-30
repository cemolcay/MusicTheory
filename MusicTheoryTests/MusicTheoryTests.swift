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
    let note: Note = .c
    XCTAssert(note.nextHalf == Note.dFlat)
  }

  func testInterval() {
    let note: Note = .c
    XCTAssert(note.next(interval: .P8) == note)
    XCTAssert(note.next(interval: .M2) == .d)
    XCTAssert(note.next(interval: .m2) == .dFlat)
  }

  func testPianoKey() {
    XCTAssert(Note.c.pianoKey(octave: 1) == 4)
    XCTAssert(Note.a.pianoKey(octave: 0) == 1)
    XCTAssert(Note.a.pianoKey(octave: 4) == 49)
  }

  func testMidiKey() {
    XCTAssert(Note.c.midiKey(octave: 0) == 0)
    XCTAssert(Note.c.midiKey(octave: 1) == 12)
    XCTAssert(Note.b.midiKey(octave: 8) == 107)
    XCTAssert(Note.g.midiKey(octave: 10) == 127)
  }

  func testScale() {
    let cMaj: [Note] = [.c, .d, .e, .f, .g, .a, .b]
    let cMajScale = Scale.major(key: .c)
    XCTAssert(cMajScale.notes == cMaj)
    let cMin: [Note] = [.c, .d, .eFlat, .f, .g, .aFlat, .bFlat]
    let cMinScale = Scale.minor(key: .c)
    XCTAssert(cMinScale.notes == cMin)
  }

  func testChords() {
    let cmajNotes: [Note] = [.c, .e, .g]
    let cmaj: Chord = .maj(key: .c)
    XCTAssert(cmajNotes == cmaj.notes)
    let cminNotes: [Note] = [.c, .eFlat, .g]
    let cmin: Chord = .min(key: .c)
    XCTAssert(cminNotes == cmin.notes)
  }
}
