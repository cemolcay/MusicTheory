//
//  TempoTests.swift
//  MusicTheoryTests
//
//  Created by Ben Lu on 12/5/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

import MusicTheory
import XCTest

class TempoTests: XCTestCase {
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
