//
//  ScaleTests.swift
//  MusicTheoryTests
//
//  Created by Ben Lu on 12/5/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

import MusicTheory
import XCTest

class ScaleTests: XCTestCase {
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
    zip(triads, triadsExpected).forEach { arg in
      let (triad, expectedTriad) = arg
      XCTAssert(triad! == expectedTriad)
    }

    let tetrads = cmaj.harmonicField(for: .tetrad)
    let tetradsExpected = [
      Chord(type: ChordType(third: .major, seventh: .major), key: Key(type: .c)),
      Chord(type: ChordType(third: .minor, seventh: .dominant), key: Key(type: .d)),
      Chord(type: ChordType(third: .minor, seventh: .dominant), key: Key(type: .e)),
      Chord(type: ChordType(third: .major, seventh: .major), key: Key(type: .f)),
      Chord(type: ChordType(third: .major, seventh: .dominant), key: Key(type: .g)),
      Chord(type: ChordType(third: .minor, seventh: .dominant), key: Key(type: .a)),
      Chord(type: ChordType(third: .minor, fifth: .diminished, seventh: .dominant), key: Key(type: .b)),
    ]
    zip(tetrads, tetradsExpected).forEach { arg in
      let (tetrad, expectedTetrad) = arg
      XCTAssert(tetrad! == expectedTetrad)
    }

    let triadWithInversion = cmaj.harmonicField(for: .triad, inversion: 1)
    let triadsWithInversionExpected = [
      Chord(type: ChordType(third: .major), key: Key(type: .c), inversion: 1),
      Chord(type: ChordType(third: .minor), key: Key(type: .d), inversion: 1),
      Chord(type: ChordType(third: .minor), key: Key(type: .e), inversion: 1),
      Chord(type: ChordType(third: .major), key: Key(type: .f), inversion: 1),
      Chord(type: ChordType(third: .major), key: Key(type: .g), inversion: 1),
      Chord(type: ChordType(third: .minor), key: Key(type: .a), inversion: 1),
      Chord(type: ChordType(third: .minor, fifth: .diminished), key: Key(type: .b), inversion: 1),
    ]
    zip(triadWithInversion, triadsWithInversionExpected).forEach { arg in
      let (triad, expectedTriad) = arg
      XCTAssert(triad! == expectedTriad)
    }
  }

  func testHarmonicFields_pentatonic() {
    let pentatonic = Scale(type: .pentatonicMajor, key: Key(type: .c))
    let triads = pentatonic.harmonicField(for: .triad)
    let triadsExpected = [
      // Am/C
      Chord(type: ChordType(third: .minor), key: Key(type: .a), inversion: 1),
      // Csus2/D
      Chord(type: ChordType(third: nil, suspended: .sus2), key: Key(type: .c), inversion: 1),
      // Dsus2/E
      Chord(type: ChordType(third: nil, suspended: .sus2), key: Key(type: .d), inversion: 1),
      // C/G
      Chord(type: ChordType(third: .major), key: Key(type: .c), inversion: 2),
      // Gsus2/A
      Chord(type: ChordType(third: nil, suspended: .sus2), key: Key(type: .g), inversion: 1),
    ]

    zip(triads, triadsExpected).forEach { arg in
      let (triad, expectedTriad) = arg
      XCTAssert(triad! == expectedTriad)
    }
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
}
