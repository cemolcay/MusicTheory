//
//  MusicTheoryTests.swift
//  MusicTheoryTests
//
//  Created by Cem Olcay on 30/12/2016.
//  Copyright © 2016 prototapp. All rights reserved.
//

@testable import MusicTheory
import XCTest

class MusicTheoryTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
}

// MARK: - Accidental Tests

extension MusicTheoryTests {
    func testAccidentals() {
        // Arithmetic
        XCTAssertEqual(Accidental.flat + Accidental.flat, Accidental.doubleFlat)
        XCTAssertEqual(Accidental.sharp + Accidental.sharp, Accidental.doubleSharp)
        XCTAssertEqual(Accidental.doubleFlat + 2, Accidental.natural)
        XCTAssertEqual(Accidental.doubleSharp - 2, Accidental.natural)

        // Comparison
        XCTAssert(Accidental.flat < Accidental.natural)
        XCTAssert(Accidental.natural < Accidental.sharp)
        XCTAssert(Accidental.doubleFlat < Accidental.flat)

        // Integer literal
        let minusTwo: Accidental = -2
        XCTAssertEqual(minusTwo, .doubleFlat)

        let plusOne: Accidental = 1
        XCTAssertEqual(plusOne, .sharp)

        // String literal
        let flat: Accidental = "b"
        XCTAssertEqual(flat, .flat)
        let sharp: Accidental = "#"
        XCTAssertEqual(sharp, .sharp)
        let natural: Accidental = ""
        XCTAssertEqual(natural, .natural)
    }
}

// MARK: - LetterName Tests

extension MusicTheoryTests {
    func testLetterNameAdvanced() {
        let d = LetterName.d
        XCTAssertEqual(d.advanced(by: -2),   .b)
        XCTAssertEqual(d.advanced(by: -19),  .f)
        XCTAssertEqual(d.advanced(by: 12),   .b)
        XCTAssertEqual(d.advanced(by: 0),    .d)
        XCTAssertEqual(d.advanced(by: 1),    .e)
        XCTAssertEqual(d.advanced(by: 2),    .f)
        XCTAssertEqual(d.advanced(by: -3),   .a)
        XCTAssertEqual(d.advanced(by: -301), .d)

        XCTAssertEqual(LetterName.f.advanced(by: -3), .c)
    }

    func testLetterNameDiatonicDistance() {
        XCTAssertEqual(LetterName.c.diatonicDistance(to: .c), 0)
        XCTAssertEqual(LetterName.c.diatonicDistance(to: .d), 1)
        XCTAssertEqual(LetterName.b.diatonicDistance(to: .c), 1)  // B→C wraps correctly
        XCTAssertEqual(LetterName.c.diatonicDistance(to: .b), 6)
    }
}

// MARK: - Interval Tests

extension MusicTheoryTests {
    func testIntervalSemitones() {
        XCTAssertEqual(Interval.P1.semitones,  0)
        XCTAssertEqual(Interval.m2.semitones,  1)
        XCTAssertEqual(Interval.M2.semitones,  2)
        XCTAssertEqual(Interval.m3.semitones,  3)
        XCTAssertEqual(Interval.M3.semitones,  4)
        XCTAssertEqual(Interval.P4.semitones,  5)
        XCTAssertEqual(Interval.A4.semitones,  6)
        XCTAssertEqual(Interval.d5.semitones,  6)
        XCTAssertEqual(Interval.P5.semitones,  7)
        XCTAssertEqual(Interval.m6.semitones,  8)
        XCTAssertEqual(Interval.M6.semitones,  9)
        XCTAssertEqual(Interval.m7.semitones, 10)
        XCTAssertEqual(Interval.M7.semitones, 11)
        XCTAssertEqual(Interval.P8.semitones, 12)
        XCTAssertEqual(Interval.M9.semitones, 14)
        XCTAssertEqual(Interval.P11.semitones, 17)
        XCTAssertEqual(Interval.M13.semitones, 21)
    }

    func testIntervalHashable() {
        // Equal intervals produce the same hash
        let a: Interval = .M3
        let b: Interval = .M3
        XCTAssertEqual(a, b)
        XCTAssertEqual(a.hashValue, b.hashValue)

        // Enharmonic intervals are not equal (different quality/degree)
        XCTAssertNotEqual(Interval.A4, Interval.d5)
        XCTAssert(Interval.A4.isEnharmonic(with: .d5))
    }

    func testIntervalInversion() {
        XCTAssertEqual(Interval.M3.inverted, .m6)
        XCTAssertEqual(Interval.P4.inverted, .P5)
        XCTAssertEqual(Interval.m2.inverted, .M7)
    }

    func testIntervalFromSemitonesDegree() {
        XCTAssertEqual(Interval(semitones: 4, degree: 3), .M3)
        XCTAssertEqual(Interval(semitones: 3, degree: 3), .m3)
        // d4 (diminished 4th) = 4 semitones, degree 4 — valid (enharmonic to M3)
        XCTAssertNotNil(Interval(semitones: 4, degree: 4))
        XCTAssertEqual(Interval(semitones: 4, degree: 4)?.degree, 4)
        // Truly invalid: minor quality on a perfect degree
        XCTAssertNil(Interval(quality: .minor, degree: 1))
        XCTAssertNil(Interval(quality: .minor, degree: 4))
    }
}

// MARK: - NoteName Tests

extension MusicTheoryTests {
    func testNoteNamePitchClass() {
        XCTAssertEqual(NoteName.c.pitchClass,  0)
        XCTAssertEqual(NoteName.cs.pitchClass, 1)
        XCTAssertEqual(NoteName.db.pitchClass, 1)
        XCTAssertEqual(NoteName.d.pitchClass,  2)
        XCTAssertEqual(NoteName.e.pitchClass,  4)
        XCTAssertEqual(NoteName.b.pitchClass,  11)
    }

    func testNoteNameStructuralEquality() {
        // C# and Db are not equal (different structure)
        XCTAssertNotEqual(NoteName.cs, NoteName.db)
        // but enharmonic
        XCTAssert(NoteName.cs.isEnharmonic(with: .db))
    }

    func testNoteNameStringLiteral() {
        let cSharp: NoteName = "C#"
        XCTAssertEqual(cSharp, .cs)

        let bFlat: NoteName = "Bb"
        XCTAssertEqual(bFlat, .bb)

        let eNatural: NoteName = "E"
        XCTAssertEqual(eNatural, .e)
    }
}

// MARK: - Pitch Tests

extension MusicTheoryTests {
    func testPitchMIDI() {
        let c0: Pitch = 12  // MIDI 12 = C0
        XCTAssertEqual(c0.octave, 0)
        XCTAssertEqual(c0.noteName, .c)

        XCTAssertEqual(c0 - 12, Pitch(midiNote: 0))  // C-1

        let pitch127 = Pitch(midiNote: 127)
        XCTAssertEqual(pitch127.noteName, .g)

        let pitch0 = Pitch(midiNote: 0)
        XCTAssertEqual(pitch0.noteName, .c)

        let pitch66 = Pitch(midiNote: 66, spelling: .flats)
        XCTAssertEqual(pitch66.noteName, .gb)
    }

    func testPitchTransposition() {
        let c1 = Pitch(noteName: .c, octave: 1)
        XCTAssertEqual(c1 + .m2, Pitch(noteName: .db, octave: 1))
        XCTAssertEqual(c1 + .M2, Pitch(noteName: .d,  octave: 1))
        XCTAssertEqual(c1 + .m3, Pitch(noteName: .eb, octave: 1))
        XCTAssertEqual(c1 + .M3, Pitch(noteName: .e,  octave: 1))
        XCTAssertEqual(c1 + .P8, Pitch(noteName: .c,  octave: 2))

        let d1 = Pitch(noteName: .d, octave: 1)
        XCTAssertEqual(d1 - .m2, Pitch(noteName: .cs, octave: 1))
        XCTAssertEqual(d1 - .M2, Pitch(noteName: .c,  octave: 1))
    }

    func testPitchInterval() {
        let c1 = Pitch(noteName: .c, octave: 1)
        let d1 = Pitch(noteName: .d, octave: 1)
        XCTAssertEqual(d1 - c1, .M2)

        // B→C crossing: must be a minor second, not a major seventh
        let b3 = Pitch(noteName: .b, octave: 3)
        let c4 = Pitch(noteName: .c, octave: 4)
        XCTAssertEqual(c4 - b3, .m2)

        // A compound interval
        let c4pitch = Pitch(noteName: .c, octave: 4)
        let d5pitch = Pitch(noteName: .d, octave: 5)
        XCTAssertEqual(d5pitch - c4pitch, .M9)
    }

    func testPitchSemitonShift() {
        let c1 = Pitch(noteName: .c, octave: 1)
        XCTAssertEqual((c1 + 12).octave, 2)
        XCTAssertEqual((c1 + 1).noteName, .cs)
        XCTAssertEqual(c1 - 1, Pitch(noteName: .b, octave: 0))
    }

    func testPitchFrequency() {
        let a4 = Pitch(noteName: .a, octave: 4)
        XCTAssertEqual(a4.frequency(), 440.0, accuracy: 0.001)

        let nearest = Pitch.nearest(frequency: 440.0)
        XCTAssertEqual(a4, nearest)
    }

    func testPitchStringLiteral() {
        let p: Pitch = "f#-5"
        XCTAssertEqual(p.noteName, .fs)
        XCTAssertEqual(p.octave, -5)

        let p2: Pitch = "A#3"
        XCTAssertEqual(p2.noteName, .as_)
        XCTAssertEqual(p2.octave, 3)

        let p3: Pitch = "F4"
        XCTAssertEqual(p3.noteName, .f)
        XCTAssertEqual(p3.octave, 4)
    }

    func testPitchEnharmonic() {
        let cs4 = Pitch(noteName: .cs, octave: 4)
        let db4 = Pitch(noteName: .db, octave: 4)
        XCTAssertNotEqual(cs4, db4)        // structural inequality
        XCTAssert(cs4.isEnharmonic(with: db4))  // same sound
    }
}

// MARK: - NoteValue Tests

extension MusicTheoryTests {
    func testNoteValueConversions() {
        var noteValue = NoteValue(type: .half, modifier: .dotted)
        XCTAssertEqual(noteValue / NoteValueType.sixteenth, 12)
        XCTAssertEqual(noteValue / NoteValueType.whole, 0.75)
        noteValue = NoteValue(type: .half, modifier: .default)
        XCTAssertEqual(noteValue / NoteValueType.sixteenth, 8)
        XCTAssertEqual(noteValue / NoteValueType.whole, 0.5)
        XCTAssertEqual(noteValue / NoteValueType.quarter, 2)
        XCTAssertEqual(noteValue / NoteValueType.thirtysecond, 16)
    }

    func testNoteModifierMultipliers() {
        XCTAssertEqual(NoteModifier.default.multiplier,     1.0,          accuracy: 1e-10)
        XCTAssertEqual(NoteModifier.dotted.multiplier,      1.5,          accuracy: 1e-10)
        XCTAssertEqual(NoteModifier.doubleDotted.multiplier, 1.75,        accuracy: 1e-10)
        XCTAssertEqual(NoteModifier.triplet.multiplier,     2.0 / 3.0,    accuracy: 1e-10)
        XCTAssertEqual(NoteModifier.quintuplet.multiplier,  4.0 / 5.0,    accuracy: 1e-10)
        XCTAssertEqual(NoteModifier.septuplet.multiplier,   4.0 / 7.0,    accuracy: 1e-10)
    }

    func testNoteValueTypeAll() {
        // Ensure all includes doubleWhole and whole
        XCTAssert(NoteValueType.all.contains(where: { $0.rate == NoteValueType.doubleWhole.rate && $0.description == NoteValueType.doubleWhole.description }))
        XCTAssert(NoteValueType.all.contains(where: { $0.rate == NoteValueType.whole.rate && $0.description == NoteValueType.whole.description }))
    }
}

// MARK: - TimeSignature Tests

extension MusicTheoryTests {
    func testTimeSignatureDescription() {
        let fourFour = TimeSignature(beats: 4, beatUnit: 4)
        XCTAssertEqual(fourFour.description, "4/4")

        let threeFour = TimeSignature(beats: 3, beatUnit: 4)
        XCTAssertEqual(threeFour.description, "3/4")

        let sixEight = TimeSignature(beats: 6, beatUnit: 8)
        XCTAssertEqual(sixEight.description, "6/8")
    }

    func testTimeSignatureFromNoteValue() {
        let ts = TimeSignature(beats: 4, noteValue: .quarter)
        XCTAssertEqual(ts.description, "4/4")
        XCTAssertEqual(ts.beatUnit, 4)
    }

    func testTimeSignatureCompound() {
        XCTAssertFalse(TimeSignature(beats: 4, beatUnit: 4).isCompound)
        XCTAssertFalse(TimeSignature(beats: 3, beatUnit: 4).isCompound)
        XCTAssert(TimeSignature(beats: 6, beatUnit: 8).isCompound)
        XCTAssert(TimeSignature(beats: 9, beatUnit: 8).isCompound)
        XCTAssert(TimeSignature(beats: 12, beatUnit: 8).isCompound)
    }
}

// MARK: - Tempo Tests

extension MusicTheoryTests {
    func testDurations() {
        let tempo = Tempo(timeSignature: TimeSignature(beats: 4, beatUnit: 4), bpm: 120)

        var noteValue = NoteValue(type: .quarter)
        XCTAssertEqual(tempo.duration(of: noteValue), 0.5, accuracy: 1e-10)

        noteValue.modifier = .dotted
        XCTAssertEqual(tempo.duration(of: noteValue), 0.75, accuracy: 1e-10)

        let whole = NoteValue(type: .whole)
        XCTAssertEqual(tempo.duration(of: whole), 2.0, accuracy: 1e-10)
    }

    func testSampleLengths() {
        let tempo = Tempo()  // 120 BPM, 4/4
        let rates: [NoteValue] = [
            NoteValue(type: .whole,         modifier: .default),
            NoteValue(type: .half,          modifier: .default),
            NoteValue(type: .half,          modifier: .dotted),
            NoteValue(type: .half,          modifier: .triplet),
            NoteValue(type: .quarter,       modifier: .default),
            NoteValue(type: .quarter,       modifier: .dotted),
            NoteValue(type: .quarter,       modifier: .triplet),
            NoteValue(type: .eighth,        modifier: .default),
            NoteValue(type: .eighth,        modifier: .dotted),
            NoteValue(type: .sixteenth,     modifier: .default),
            NoteValue(type: .sixteenth,     modifier: .dotted),
            NoteValue(type: .thirtysecond,  modifier: .default),
            NoteValue(type: .sixtyfourth,   modifier: .default),
        ]

        let sampleLengths = rates.map { round(100 * tempo.sampleLength(of: $0)) / 100 }

        let expected: [Double] = [
            88200.0,
            44100.0,
            66150.0,
            29400.0,   // exact 2/3 — was 29401.47 with the old imprecise 0.6667
            22050.0,
            33075.0,
            14700.0,   // exact 2/3 — was 14700.73 with the old imprecise 0.6667
            11025.0,
            16537.5,
            5512.5,
            8268.75,
            2756.25,
            1378.13,
        ]

        XCTAssertEqual(sampleLengths, expected)
    }

    func testTempoEquality() {
        let t1 = Tempo(timeSignature: TimeSignature(beats: 4, beatUnit: 4), bpm: 120)
        let t2 = Tempo(timeSignature: TimeSignature(beats: 4, beatUnit: 4), bpm: 120)
        XCTAssertEqual(t1, t2)

        let t3 = Tempo(timeSignature: TimeSignature(beats: 3, beatUnit: 4), bpm: 120)
        XCTAssertNotEqual(t1, t3)

        let t4 = Tempo(timeSignature: TimeSignature(beats: 4, beatUnit: 4), bpm: 90)
        XCTAssertNotEqual(t1, t4)
    }

    func testTempoHashable() {
        let t1 = Tempo(timeSignature: TimeSignature(beats: 1, noteValue: .whole), bpm: 1)
        var t2 = Tempo(timeSignature: TimeSignature(beats: 2, noteValue: .half), bpm: 2)
        XCTAssertNotEqual(t1.timeSignature, t2.timeSignature)
        XCTAssertNotEqual(t1, t2)

        t2.timeSignature = TimeSignature(beats: 1, noteValue: .whole)
        t2.bpm = 1
        XCTAssertEqual(t1.timeSignature, t2.timeSignature)
        XCTAssertEqual(t1, t2)
    }
}

// MARK: - Scale Tests

extension MusicTheoryTests {
    func testScaleNoteNames() {
        let cMaj = Scale(type: .major, root: .c)
        let expected: [NoteName] = [.c, .d, .e, .f, .g, .a, .b]
        XCTAssertEqual(cMaj.noteNames, expected)

        let cMin = Scale(type: .minor, root: .c)
        let expectedMin: [NoteName] = [.c, .d, .eb, .f, .g, .ab, .bb]
        XCTAssertEqual(cMin.noteNames, expectedMin)
    }

    func testScaleSpelling() {
        // D major must use sharps, not flats
        let dMaj = Scale(type: .major, root: .d)
        XCTAssertEqual(dMaj.noteNames, [.d, .e, .fs, .g, .a, .b, .cs])

        // Bb major must use flats
        let bbMaj = Scale(type: .major, root: .bb)
        let notes = bbMaj.noteNames
        // Should be Bb C D Eb F G A
        XCTAssertEqual(notes[0], .bb)
        XCTAssertEqual(notes[2], .d)
        XCTAssertEqual(notes[3], .eb)
    }

    func testCustomScaleConstruction() {
        let custom = Scale(intervals: [.P1, .m2, .P4, .P5], root: .d, description: "Custom Tetrachord")
        XCTAssertEqual(custom.noteNames, [.d, .eb, .g, .a])
        XCTAssertEqual(custom.type, ScaleType(intervals: [.P1, .m2, .P4, .P5], description: "Custom Tetrachord"))
    }

}

// MARK: - Chord Tests

extension MusicTheoryTests {
    func testChordNoteNames() {
        let cMaj = Chord(type: .major, root: .c)
        XCTAssertEqual(cMaj.noteNames, [.c, .e, .g])

        let cMin = Chord(type: .minor, root: .c)
        XCTAssertEqual(cMin.noteNames, [.c, .eb, .g])
    }

    func testChordPitches() {
        let c13 = Chord(type: .dominant13, root: .c)
        let expected: [Pitch] = [
            Pitch(noteName: .c,  octave: 1),
            Pitch(noteName: .e,  octave: 1),
            Pitch(noteName: .g,  octave: 1),
            Pitch(noteName: .bb, octave: 1),
            Pitch(noteName: .d,  octave: 2),
            Pitch(noteName: .f,  octave: 2),
            Pitch(noteName: .a,  octave: 2),
        ]
        XCTAssertEqual(c13.pitches(octave: 1), expected)
    }

    func testChordFromIntervals() {
        let minorResult = ChordType.from(intervals: [.P1, .m3, .P5])
        guard case .success(let minorChord) = minorResult else {
            return XCTFail("Minor chord recognition failed")
        }
        XCTAssertEqual(minorChord, .minor)

        let majorResult = ChordType.from(intervals: [.P1, .M3, .P5])
        guard case .success(let majorChord) = majorResult else {
            return XCTFail("Major chord recognition failed")
        }
        XCTAssertEqual(majorChord, .major)
    }

    func testChordInversions() {
        let c7 = Chord(type: .dominant7, root: .c)
        let inversions = c7.inversions
        let expected: [[Pitch]] = [
            [
                Pitch(noteName: .c,  octave: 1),
                Pitch(noteName: .e,  octave: 1),
                Pitch(noteName: .g,  octave: 1),
                Pitch(noteName: .bb, octave: 1),
            ],
            [
                Pitch(noteName: .e,  octave: 1),
                Pitch(noteName: .g,  octave: 1),
                Pitch(noteName: .bb, octave: 1),
                Pitch(noteName: .c,  octave: 2),
            ],
            [
                Pitch(noteName: .g,  octave: 1),
                Pitch(noteName: .bb, octave: 1),
                Pitch(noteName: .c,  octave: 2),
                Pitch(noteName: .e,  octave: 2),
            ],
            [
                Pitch(noteName: .bb, octave: 1),
                Pitch(noteName: .c,  octave: 2),
                Pitch(noteName: .e,  octave: 2),
                Pitch(noteName: .g,  octave: 2),
            ],
        ]
        for (index, chord) in inversions.enumerated() {
            XCTAssertEqual(chord.pitches(octave: 1), expected[index],
                           "Inversion \(index) mismatch")
        }
    }

    func testSlashChord() {
        // C/E — C major with E in the bass
        let cOverE = Chord(type: .major, root: .c, bass: .e)
        XCTAssertEqual(cOverE.notation, "C/E")
    }

    func testInversionNotationUsesActualBassNote() {
        var chord = Chord(type: .major, root: .c)
        chord.inversion = 1
        XCTAssertEqual(chord.notation, "C/E")

        chord.inversion = 2
        XCTAssertEqual(chord.notation, "C/G")
    }

    func testChordSymbols() {
        XCTAssertEqual(ChordType.major.symbol,         "M")
        XCTAssertEqual(ChordType.minor.symbol,         "m")
        XCTAssertEqual(ChordType.diminished.symbol,    "dim")
        XCTAssertEqual(ChordType.augmented.symbol,     "+")
        XCTAssertEqual(ChordType.dominant7.symbol,     "7")
        XCTAssertEqual(ChordType.major7.symbol,        "Maj7")
        XCTAssertEqual(ChordType.minor7.symbol,        "m7")
        XCTAssertEqual(ChordType.halfDiminished7.symbol, "ø7")
        XCTAssertEqual(ChordType.diminished7.symbol,   "dim7")
        XCTAssertEqual(ChordType.dominant9.symbol,     "9")
        XCTAssertEqual(ChordType.major9.symbol,        "Maj9")
        XCTAssertEqual(ChordType.minor9.symbol,        "m9")
        XCTAssertEqual(ChordType.dominant11.symbol,    "11")
        XCTAssertEqual(ChordType.dominant13.symbol,    "13")
        XCTAssertEqual(ChordType.major13.symbol,       "Maj13")
        XCTAssertEqual(ChordType.minor13.symbol,       "m13")
    }

    func testChordFullNames() {
        XCTAssertEqual(ChordType.minor7.fullName, "Minor 7th")
        XCTAssertEqual(ChordType.dominant7.fullName, "Dominant 7th")
        XCTAssertEqual(ChordType.major9.fullName, "Major 9th")
        XCTAssertEqual(ChordType.minor9.fullName, "Minor 9th")
        XCTAssertEqual(ChordType.dominant13.fullName, "Dominant 13th")
    }
}

// MARK: - ScaleType Tests

extension MusicTheoryTests {
    func testScaleTypeEquality() {
        // Ionian and major are the same scale by intervals
        XCTAssertEqual(ScaleType.ionian, ScaleType.major)
    }

    func testScaleTypeBuiltins() {
        XCTAssertEqual(ScaleType.major.intervals, [.P1, .M2, .M3, .P4, .P5, .M6, .M7])
        XCTAssertEqual(ScaleType.minor.intervals, [.P1, .M2, .m3, .P4, .P5, .m6, .m7])
        XCTAssertEqual(ScaleType.altered.intervals, [.P1, .m2, .m3, .d4, .d5, .m6, .m7])
        XCTAssertEqual(ScaleType.lydianDominant.intervals, [.P1, .M2, .M3, .A4, .P5, .M6, .m7])
        XCTAssertEqual(ScaleType.pentatonicMajor.intervals, [.P1, .M2, .M3, .P5, .M6])
        XCTAssertEqual(ScaleType.chromatic.intervals.count, 12)
    }

    func testScaleTypeCustomInitialization() {
        let custom = ScaleType(intervals: [.P1, .m2, .P4, .P5], description: "Custom Tetrachord")
        XCTAssertEqual(custom.description, "Custom Tetrachord")
        XCTAssertEqual(custom.intervals, [.P1, .m2, .P4, .P5])
    }
}
