//
//  ClefTests.swift
//  MusicTheoryTests
//
//  Created by Sihao Lu on 11/9/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

import MusicTheory
import XCTest

class ClefTests: XCTestCase {
  func testCleves() {
    XCTAssertEqual(Clef.treble.position(forPitch: Pitch(key: "C", octave: 4)), 0)
    XCTAssertEqual(Clef.treble.position(forPitch: Pitch(key: "D", octave: 4)), 1)
    XCTAssertEqual(Clef.treble.position(forPitch: Pitch(key: "F", octave: 4)), 3)
    XCTAssertEqual(Clef.treble.position(forPitch: Pitch(key: "G", octave: 4)), 4)
    XCTAssertEqual(Clef.treble.position(forPitch: Pitch(key: "A", octave: 4)), 5)
    XCTAssertEqual(Clef.treble.position(forPitch: Pitch(key: "C", octave: 5)), 7)

    XCTAssertEqual(Clef.bass.position(forPitch: Pitch(key: "C", octave: 4)), 12)
    XCTAssertEqual(Clef.bass.position(forPitch: Pitch(key: "C", octave: 3)), 5)
    XCTAssertEqual(Clef.bass.position(forPitch: Pitch(key: "F", octave: 2)), 1)
    XCTAssertEqual(Clef.bass.position(forPitch: Pitch(key: "F", octave: 3)), 8)
    XCTAssertEqual(Clef.bass.position(forPitch: Pitch(key: "G", octave: 3)), 9)
    XCTAssertEqual(Clef.bass.position(forPitch: Pitch(key: "A", octave: 3)), 10)

    XCTAssertEqual(Clef.tenor.position(forPitch: Pitch(key: "C", octave: 3)), 0)
    XCTAssertEqual(Clef.tenor.position(forPitch: Pitch(key: "D", octave: 3)), 1)
    XCTAssertEqual(Clef.tenor.position(forPitch: Pitch(key: "F", octave: 3)), 3)
    XCTAssertEqual(Clef.tenor.position(forPitch: Pitch(key: "G", octave: 3)), 4)
    XCTAssertEqual(Clef.tenor.position(forPitch: Pitch(key: "A", octave: 3)), 5)
    XCTAssertEqual(Clef.tenor.position(forPitch: Pitch(key: "C", octave: 4)), 7)

    XCTAssertEqual(Clef.alto.position(forPitch: Pitch(key: "C", octave: 4)), 6)
  }

  func testClefInfo() {
    XCTAssertTrue(Clef.treble.isLine(forPitch: Pitch(key: "C", octave: 4)))
    XCTAssertFalse(Clef.treble.isLine(forPitch: Pitch(key: "C", octave: 5)))
    XCTAssertFalse(Clef.treble.isLine(forPitch: Pitch(key: "F", octave: 4)))
    XCTAssertTrue(Clef.treble.isLine(forPitch: Pitch(key: "E", octave: 4)))

    XCTAssertTrue(Clef.bass.isSpace(forPitch: Pitch(key: "G", octave: 3)))
    XCTAssertFalse(Clef.bass.isSpace(forPitch: Pitch(key: "F", octave: 3)))
    XCTAssertTrue(Clef.bass.isSpace(forPitch: Pitch(key: "A", octave: 2)))
    XCTAssertTrue(Clef.bass.isSpace(forPitch: Pitch(key: "C", octave: 3)))
    XCTAssertFalse(Clef.bass.isSpace(forPitch: Pitch(key: "G", octave: 2)))
  }
}
