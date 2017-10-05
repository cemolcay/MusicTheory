//
//  MusicTheory.swift
//  MusicTheory
//
//  Created by Cem Olcay on 29/12/2016.
//  Copyright © 2016 prototapp. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - Note Value

/// Defines the types of note values.
public enum NoteValueType {
  /// Two whole notes.
  case doubleWhole
  /// Whole note.
  case whole
  /// Half note.
  case half
  /// Quarter note.
  case quarter
  /// Eighth note.
  case eighth
  /// Sixteenth note.
  case sixteenth
  /// Thirtysecond note.
  case thirtysecond
  /// Sixtyfourth note.
  case sixtyfourth

  /// Init with beat count.
  /// For example for a whole note, beats should be 1,
  /// For a eighth note, beats should be 8.
  /// Returns nil, if no beats match.
  public init?(beats: Double) {
    switch beats {
    case 0.5: self = .doubleWhole
    case 1: self = .whole
    case 2: self = .half
    case 4: self = .quarter
    case 8: self = .eighth
    case 16: self = .sixteenth
    case 32: self = .thirtysecond
    case 64: self = .sixtyfourth
    default: return nil
    }
  }

  /// Beat count
  public var beats: Double {
    switch self {
    case .doubleWhole: return 0.5
    case .whole: return 1
    case .half: return 2
    case .quarter: return 4
    case .eighth: return 8
    case .sixteenth: return 16
    case .thirtysecond: return 32
    case .sixtyfourth: return 64
    }
  }
}

/// Defines the lenght of a `NoteValue`
public enum NoteModifier {
  /// No additional lenght.
  case `default`
  /// Adds half of its own value.
  case dotted
  /// Three notes of the same value.
  case triplet

  /// Multiplier using in caluclation of note duration in seconds.
  public var durationMultiplier: Double {
    switch self {
    case .default: return 1
    case .dotted: return 1.5
    case .triplet: return 0.67
    }
  }
}

/// Defines the duration of a note beatwise.
public struct NoteValue {
  /// Type that represents the duration of note.
  public var type: NoteValueType
  /// Modifier for `NoteType` that modifies the duration.
  public var modifier: NoteModifier

  /// Initilize the NoteValue with its type and optional modifier.
  ///
  /// - Parameters:
  ///   - type: Type of note value that represents note duration.
  ///   - modifier: Modifier of note value. Defaults `default`.
  public init(type: NoteValueType, modifier: NoteModifier = .default) {
    self.type = type
    self.modifier = modifier
  }
}

// MARK: - Time Signature

/// Defines how many beats in a measure with which note value.
public struct TimeSignature {
  /// Beats per measure.
  public var beats: UInt

  /// Note value per beat.
  public var noteValue: NoteValueType

  /// Initilizes the time signature with beats per measure and the value of the notes in beat.
  ///
  /// - Parameters:
  ///   - beats: Number of beats in a measure
  ///   - noteValue: Note value of the beats.
  public init(beats: UInt, noteValue: NoteValueType) {
    self.beats = beats
    self.noteValue = noteValue
  }

  /// Initilizes the time signature with beats per measure and the value of the notes in beat. Returns nil if a division is not match a `NoteValue`.
  ///
  /// - Parameters:
  ///   - beats: Number of beats in a measure
  ///   - division: Number of the beats.
  public init?(beats: UInt, division: UInt) {
    guard let noteValue = NoteValueType(beats: Double(division)) else {
      return nil
    }

    self.beats = beats
    self.noteValue = noteValue
  }
}

// MARK: - Tempo

/// Defines the tempo of the music with beats per second and time signature.
public struct Tempo {
  /// Time signature of music.
  public var timeSignature = TimeSignature(beats: 4, noteValue: .quarter)

  /// Beats per minutes.
  public var bpm: Double = 120.0

  /// Initilizes tempo with time signature and BPM.
  ///
  /// - Parameters:
  ///   - timeSignature: Time Signature.
  ///   - bpm: Beats per minute.
  public init(timeSignature: TimeSignature, bpm: Double) {
    self.timeSignature = timeSignature
    self.bpm = bpm
  }

  /// Caluclates the duration of a note value in seconds.
  public func duration(of noteValue: NoteValue) -> TimeInterval {
    let secondsPerBeat = 60.0 / bpm
    let secondsPerNote = secondsPerBeat * (timeSignature.noteValue.beats / noteValue.type.beats) * noteValue.modifier.durationMultiplier
    return secondsPerNote
  }

  /// Calculates the LFO speed of a note vaule in hertz.
  public func hertz(of noteValue: NoteValue) -> Double {
    return 1 / duration(of: noteValue)
  }
}

// MARK: - NoteType

/// Calculates the `NoteType` above `Interval`.
///
/// - Parameters:
///   - noteType: The note type being added interval.
///   - interval: Interval above.
/// - Returns: Returns `NoteType` above interval.
public func +(noteType: NoteType, interval: Interval) -> NoteType {
  return NoteType(midiNote: noteType.rawValue + interval.halfstep)!
}

/// Calculates the `NoteType` above halfsteps.
///
/// - Parameters:
///   - noteType: The note type being added halfsteps.
///   - halfstep: Halfsteps above
/// - Returns: Returns `NoteType` above halfsteps
public func +(noteType: NoteType, halfstep: Int) -> NoteType {
  return NoteType(midiNote: noteType.rawValue + halfstep)!
}

/// Calculates the `NoteType` below `Interval`.
///
/// - Parameters:
///   - noteType: The note type being calculated.
///   - interval: Interval below.
/// - Returns: Returns `NoteType` below interval.
public func -(noteType: NoteType, interval: Interval) -> NoteType {
  return NoteType(midiNote: noteType.rawValue - interval.halfstep)!
}

/// Calculates the `NoteType` below halfsteps.
///
/// - Parameters:
///   - noteType: The note type being calculated.
///   - halfstep: Halfsteps below.
/// - Returns: Returns `NoteType` below halfsteps.
public func -(noteType: NoteType, halfstep: Int) -> NoteType {
  return NoteType(midiNote: noteType.rawValue - halfstep)!
}

/// Defines 12 base notes in music.
/// C, D, E, F, G, A, B with their flats.
/// Raw values are included for easier calculation based on midi notes.
public enum NoteType: Int, Equatable {
  /// C note.
  case c = 0
  /// D♭ or C♯ note.
  case dFlat
  /// D note.
  case d
  /// E♭ or D♯ note.
  case eFlat
  /// E note.
  case e
  /// F note.
  case f
  /// G♭ or F♯ note.
  case gFlat
  /// G Note.
  case g
  /// A♭ or G♯ note.
  case aFlat
  /// A note.
  case a
  /// B♭ or A♯ note.
  case bFlat
  /// B note.
  case b

  /// All the notes in static array.
  public static let all: [NoteType] = [
    .c, .dFlat, .d, .eFlat, .e, .f,
    .gFlat, .g, .aFlat, .a, .bFlat, .b
  ]

  /// Initilizes the note type with midiNote.
  ///
  /// - parameters:
  ///  - midiNote: The midi note value wanted to be converted to `NoteType`.
  public init?(midiNote: Int) {
    let octave = (midiNote / 12) - (midiNote < 0 ? 1 : 0)
    let raw = octave > 0 ? midiNote - (octave * 12) : midiNote - ((octave + 1) * 12) + 12
    guard let note = NoteType(rawValue: raw) else { return nil }
    self = note
  }
}

extension NoteType: CustomStringConvertible {

  /// Converts `NoteType` to string with its name.
  public var description: String {
    switch self {
    case .c: return "C"
    case .dFlat: return "D♭"
    case .d: return "D"
    case .eFlat: return "E♭"
    case .e: return "E"
    case .f: return "F"
    case .gFlat: return "G♭"
    case .g: return "G"
    case .aFlat: return "A♭"
    case .a: return "A"
    case .bFlat: return "B♭"
    case .b: return "B"
    }
  }
}

// MARK: - Note

/// Calculates the `Note` above `Interval`.
///
/// - Parameters:
///   - note: The note being added interval.
///   - interval: Interval above.
/// - Returns: Returns `Note` above interval.
public func +(note: Note, interval: Interval) -> Note {
  return Note(midiNote: note.midiNote + interval.halfstep)
}

/// Calculates the `Note` above halfsteps.
///
/// - Parameters:
///   - note: The note being added halfsteps.
///   - halfstep: Halfsteps above.
/// - Returns: Returns `Note` above halfsteps.
public func +(note: Note, halfstep: Int) -> Note {
  return Note(midiNote: note.midiNote + halfstep)
}

/// Calculates the `Note` below `Interval`.
///
/// - Parameters:
///   - note: The note being calculated.
///   - interval: Interval below.
/// - Returns: Returns `Note` below interval.
public func -(note: Note, interval: Interval) -> Note {
  return Note(midiNote: note.midiNote - interval.halfstep)
}

/// Calculates the `Note` below halfsteps.
///
/// - Parameters:
///   - note: The note being calculated.
///   - halfstep: Halfsteps below.
/// - Returns: Returns `Note` below halfsteps.
public func -(note: Note, halfstep: Int) -> Note {
  return Note(midiNote: note.midiNote - halfstep)
}

/// Calculates the interval between two notes.
/// Doesn't matter left hand side and right hand side note places.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: `Intreval` between two notes. You can get the halfsteps from interval as well.
public func -(lhs: Note, rhs: Note) -> Interval {
	return Interval(halfstep: abs(rhs.midiNote - lhs.midiNote))
}

/// Compares the equality of two notes by their types and octaves.
///
/// - Parameters:
///   - left: Left handside `Note` to be compared.
///   - right: Right handside `Note` to be compared.
/// - Returns: Returns the bool value of comparisation of two notes. 
public func ==(left: Note, right: Note) -> Bool {
  return left.type == right.type && left.octave == right.octave
}

/// Note object with `NoteType` and octave.
/// Could be initilized with midiNote.
public struct Note: Equatable {

  /// Type of the note like C, D, A, B.
  public var type: NoteType

  /// Octave of the note.
  /// In theory this must be zero or a positive integer.
  /// But `Note` does not limit octave and calculates every possible octave including the negative ones.
  public var octave: Int

  /// Initilizes the `Note` from midi note.
  ///
  /// - Parameter midiNote: Midi note in range of [0 - 127].
  public init(midiNote: Int) {
    octave = (midiNote / 12) - (midiNote < 0 ? 1 : 0)
    type = NoteType(midiNote: midiNote)!
  }

  /// Initilizes the `Note` with `NoteType` and octave
  ///
  /// - Parameters:
  ///   - type: The type of the note in `NoteType` enum.
  ///   - octave: Octave of the note.
  public init(type: NoteType, octave: Int) {
    self.type = type
    self.octave = octave
  }

	/// Returns midi note value.
	/// In theory, this must be in range [0 - 127].
	/// But it does not limits the midi note value.
	public var midiNote: Int {
		return type.rawValue + (octave * 12)
	}
}

public extension Note {

  /// Returns the piano key number by octave based on a standard [1 - 88] key piano.
  public var pianoKey: Int {
    return midiNote + 4
  }

  /// Calculates and returns the frequency of note on octave based on its location of piano keys.
  /// Bases A4 note of 440Hz frequency standard.
  public var frequancy: Float {
    let fn = powf(2.0, Float(pianoKey - 49) / 12.0)
    return fn * 440.0
  }
}

extension Note: CustomStringConvertible {

  /// Converts `Note` to string with its type and octave.
  public var description: String {
    return "\(type)\(octave)"
  }
}

// MARK: - Interval

/// Compares two `Interval` types.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns bool value of equeation.
public func ==(lhs: Interval, rhs: Interval) -> Bool {
	return lhs.halfstep == rhs.halfstep
}

/// Extends `Interval` by any given octave.
/// For example between C1 and D1, there are 2 halfsteps but between C1 and D2 there are 14 halfsteps.
//// ```.M2 * 2``` will give you D2 from a C1.
///
/// - Parameters:
///   - interval: Interval you want to extend by an octave.
///   - octave: Octave you want to extend your interval by.
/// - Returns: Returns new interval by calculating halfsteps between target interval and octave.
public func *(interval: Interval, octave: Int) -> Interval {
	return Interval(halfstep: interval.halfstep + (12 * (octave - 1)))
}

/// Defines the interval between `Note`s in halfstep tones and degrees.
public enum Interval: Equatable, ExpressibleByIntegerLiteral {
  public typealias IntegerLiteralType = Int

  /// Zero halfstep and zero degree, the note itself.
  case unison
  /// One halfstep and one degree between notes.
  case m2
  /// Two halfsteps and one degree between notes.
  case M2
  /// Three halfsteps and two degree between notes.
  case m3
  /// Four halfsteps and two degree between notes.
  case M3
  /// Five halfsteps and three degree between notes.
  case P4
  /// Six halfsteps and four degree between notes.
  case d5
  /// Seven halfsteps and four degree between notes.
  case P5
  /// Eight halfsteps and five degree between notes.
  case m6
  /// Nine halfsteps and five degree between notes.
  case M6
  /// Ten halfsteps and six degree between notes.
  case m7
  /// Eleven halfsteps and six degree between notes.
  case M7
  /// Twelve halfsteps and seven degree between notes.
  case P8
  /// Custom halfsteps and degrees by given input between notes.
  case custom(halfstep: Int)

  /// Initilizes interval with its degree and halfstep.
  ///
  /// - Parameters:
  ///   - degree: Degree of interval.
  ///   - halfstep: Halfstep of interval.
  public init(halfstep: Int) {
    switch halfstep {
    case 0: self = .unison
    case 1: self = .m2
    case 2: self = .M2
    case 3: self = .m3
    case 4: self = .M3
    case 5: self = .P4
    case 6: self = .d5
    case 7: self = .P5
    case 8: self = .m6
    case 9: self = .M6
    case 10: self = .m7
    case 11: self = .M7
    case 12: self = .P8
    default: self = .custom(halfstep: halfstep)
    }
  }

  /// ExpressibleByIntegerLiteral init function.
  /// You can convert Int value of halfsteps to Interval.
  ///
  /// -           :
  ///   - value: Halfstep value of Interval.
  public init(integerLiteral value: IntegerLiteralType) {
    self.init(halfstep: value)
  }

  /// Returns the degree of the `Interval`.
  public var degree: Int {
    switch self {
    case .m2, .M2: return 1
    case .M3, .m3: return 2
    case .P4: return 3
    case .d5, .P5: return 4
    case .m6, .M6: return 5
    case .m7, .M7: return 6
    case .P8: return 7
    default: return 0
    }
  }

  /// Returns halfstep representation of `Interval.`
  public var halfstep: Int {
    switch self {
    case .unison: return 0
    case .m2: return 1
    case .M2: return 2
    case .m3: return 3
    case .M3: return 4
    case .P4: return 5
    case .d5: return 6
    case .P5: return 7
    case .m6: return 8
    case .M6: return 9
    case .m7: return 10
    case .M7: return 11
    case .P8: return 12
    case .custom(let h): return h
    }
  }
}

extension Interval: CustomStringConvertible {

  public var description: String {
    switch self {
    case .unison: return "unison"
    case .m2: return "minor second"
    case .M2: return "major second"
    case .m3: return "minor third"
    case .M3: return "major third"
    case .P4: return "perfect forth"
    case .d5: return "diminished fifth"
    case .P5: return "perfect fifth"
    case .m6: return "minor sixth"
    case .M6: return "major sixth"
    case .m7: return "minor seventh"
    case .M7: return "major seventh"
    case .P8: return "octave"
    case .custom(let halfstep): return "\(halfstep)th"
    }
  }

  /// Roman numeric value of interval by its halfstep value.
  public var roman: String {
    switch self {
    case .unison: return "i"
    case .m2: return "ii"
    case .M2: return "II"
    case .m3: return "iii"
    case .M3: return "III"
    case .P4: return "IV"
    case .d5: return "v"
    case .P5: return "V"
    case .m6: return "vi"
    case .M6: return "VI"
    case .m7: return "vii"
    case .M7: return "VII"
    case .P8: return "VII"
    case .custom(let halfstep): return "\(halfstep)"
    }
  }
}

// MARK: - ScaleType

/// Checks the equability between two `ScaleType`s by their intervals.
///
/// - Parameters:
///   - left: Left handside of the equation.
///   - right: Right handside of the equation.
/// - Returns: Returns Bool value of equation of two given scale types.
public func ==(left: ScaleType, right: ScaleType) -> Bool {
	return left.intervals == right.intervals
}

/// Represents scale by the intervals between note sequences.
public enum ScaleType: Equatable {
  /// Major scale.
  case major
  /// Minor scale.
  case minor
  /// Harmonic minor scale.
  case harmonicMinor
  /// Melodic minor scale.
  case melodicMinor
  /// Pentatonic major scale.
  case pentatonicMajor
  /// Pentatonic minor scale.
  case pentatonicMinor
  /// Pentatonic blues scale.
  case pentatonicBlues
  /// Pentatonic neutral scale.
  case pentatonicNeutral
  /// Ionian scale.
  case ionian
  /// Aeolian scale.
  case aeolian
  /// Dorian scale.
  case dorian
  /// Mixolydian scale.
  case mixolydian
  /// Phrygian scale.
  case phrygian
  /// Lydian scale.
  case lydian
  /// Locrian scale.
  case locrian
  /// Half diminished scale.
  case dimHalf
  /// Whole diminished scale.
  case dimWhole
  /// Whole scale.
  case whole
  /// Augmented scale.
  case augmented
  /// Chromatic scale.
  case chromatic
  /// Roumanian minor scale.
  case roumanianMinor
  /// Spanish gypsy scale.
  case spanishGypsy
  /// Blues scale.
  case blues
  /// Diatonic scale.
  case diatonic
  /// Dobule harmonic scale.
  case doubleHarmonic
  /// Eight tone spanish scale.
  case eightToneSpanish
  /// Enigmatic scale.
  case enigmatic
  /// Leading whole tone scale.
  case leadingWholeTone
  /// Lydian augmented scale.
  case lydianAugmented
  /// Neopolitan major scale.
  case neopolitanMajor
  /// Neopolitan minor scale.
  case neopolitanMinor
  /// Pelog scale.
  case pelog
  /// Prometheus scale.
  case prometheus
  /// Prometheus neopolitan scale.
  case prometheusNeopolitan
  /// Six tone symmetrical scale.
  case sixToneSymmetrical
  /// Super locrian scale.
  case superLocrian
  /// Lydian minor scale.
  case lydianMinor
  /// Lydian diminished scale.
  case lydianDiminished
  /// Nine tone scale.
  case nineToneScale
  /// Auxiliary diminished scale.
  case auxiliaryDiminished
  /// Auxiliary augmaneted scale.
  case auxiliaryAugmented
  /// Auxiliary diminished blues scale.
  case auxiliaryDimBlues
  /// Major locrian scale.
  case majorLocrian
  /// Overtone scale.
  case overtone
  /// Diminished whole tone scale.
  case diminishedWholeTone
  /// Pure minor scale.
  case pureMinor
  /// Dominant seventh scale.
  case dominant7th
  /// Custom scale with given interval set.
	case custom(intervals: [Interval], description: String)

	/// Tries to initilize scale with a matching interval series.
	///
	/// - Parameters:
	///   - intervals: Intervals of the chord.
	public init?(intervals: [Interval]) {
		guard let scale = ScaleType.all.filter({ $0.intervals == intervals }).first
			else { return nil }
		self = scale
	}

  /// Intervals of the scale.
  public var intervals: [Interval] {
    switch self {
    case .major: return [.unison, .M2, .M3, .P4, .P5, .M6, .M7]
    case .minor: return [.unison, .M2, .m3, .P4, .P5, .m6, .m7]
    case .harmonicMinor: return [.unison, .M2, .m3, .P4, .P5, .m6, .M7]
    case .dorian: return [.unison, .M2, .m3, .P4, .P5, .M6, .m7]
    case .phrygian: return [.unison, .m2, .m3, .P4, .P5, .m6, .m7]
    case .lydian: return [.unison, .M2, .M3, .d5, .P5, .M6, .M7]
    case .mixolydian: return [.unison, .M2, .M3, .P4, .P5, .M6, .m7]
    case .locrian: return [.unison, .m2, .m3, .P4, .d5, .m6, .m7]
    case .melodicMinor: return [.unison, .M2, .m3, .P4, .P5, .M6, .M7]
    case .pentatonicMajor: return [.unison, .M2, .M3, .P5, .M6]
    case .pentatonicMinor: return [.unison, .m3, .P4, .P5, .m7]
    case .pentatonicBlues: return [.unison, .m3, .P4, .d5, .P5, .m7]
    case .pentatonicNeutral: return [.unison, .M2, .P4, .P5, .m7]
    case .ionian: return [.unison, .M2, .M3, .P4, .P5, .M6, .M7]
    case .aeolian: return [.unison, .M2, .m3, .P4, .P5, .m6, .m7]
    case .dimHalf: return [.unison, .m2, .m3, .M3, .d5, .P5, .M6, .m7]
    case .dimWhole: return [.unison, .M2, .m3, .P4, .d5, .m6, .M6, .M7]
    case .whole: return [.unison, .M2, .M3, .d5, .m6, .m7]
    case .augmented: return [.m3, .M3, .P5, .m6, .M7]
    case .chromatic: return [.unison, .m2, .M2, .m3, .M3, .P4, .d5, .P5, .m6, .M6, .m7, .M7]
    case .roumanianMinor: return [.unison, .M2, .m3, .d5, .P5, .M6, .m7]
    case .spanishGypsy: return [.unison, .m2, .M3, .P4, .P5, .m6, .m7]
    case .blues: return [.unison, .m3, .P4, .d5, .P5, .m7]
    case .diatonic: return [.unison, .M2, .M3, .P5, .M6]
    case .doubleHarmonic: return [.unison, .m2, .M3, .P4, .P5, .m6, .M7]
    case .eightToneSpanish: return [.unison, .m2, .m3, .M3, .P4, .d5, .m6, .m7]
    case .enigmatic: return [.unison, .m2, .M3, .d5, .m6, .m7, .M7]
    case .leadingWholeTone: return [.unison, .M2, .M3, .d5, .m6, .M6, .m7]
    case .lydianAugmented: return [.unison, .M2, .M3, .d5, .m6, .M6, .M7]
    case .neopolitanMajor: return [.unison, .m2, .m3, .P4, .P5, .M6, .M7]
    case .neopolitanMinor: return [.unison, .m2, .m3, .P4, .P5, .m6, .m7]
    case .pelog: return [.unison, .m2, .m3, .d5, .m7, .M7]
    case .prometheus: return [.unison, .M2, .M3, .d5, .M6, .m7]
    case .prometheusNeopolitan: return [.unison, .m2, .M3, .d5, .M6, .m7]
    case .sixToneSymmetrical: return [.unison, .m2, .M3, .P4, .m6, .M6]
    case .superLocrian: return [.unison, .m2, .m3, .M3, .d5, .m6, .m7]
    case .lydianMinor: return [.unison, .M2, .M3, .d5, .P5, .m6, .m7]
    case .lydianDiminished: return [.unison, .M2, .m3, .d5, .P5, .m6, .m7]
    case .nineToneScale: return [.unison, .M2, .m3, .M3, .d5, .P5, .m6, .M6, .M7]
    case .auxiliaryDiminished: return [.unison, .M2, .m3, .P4, .d5, .m6, .M6, .M7]
    case .auxiliaryAugmented: return [.unison, .M2, .M3, .d5, .m6, .m7]
    case .auxiliaryDimBlues: return [.unison, .m2, .m3, .M3, .d5, .P5, .M6, .m7]
    case .majorLocrian: return [.unison, .M2, .M3, .P4, .d5, .m6, .m7]
    case .overtone: return [.unison, .M2, .M3, .d5, .P5, .M6, .m7]
    case .diminishedWholeTone: return [.unison, .m2, .m3, .M3, .d5, .m6, .m7]
    case .pureMinor: return [.unison, .M2, .m3, .P4, .P5, .m6, .m7]
    case .dominant7th: return [.unison, .M2, .M3, .P4, .P5, .M6, .m7]
    case .custom(let intervals, _): return intervals
    }
  }

  /// An array of all `ScaleType` values.
  public static var all: [ScaleType] {
    return [
      .major,
      .minor,
      .harmonicMinor,
      .melodicMinor,
      .pentatonicMajor,
      .pentatonicMinor,
      .pentatonicBlues,
      .pentatonicNeutral,
      .ionian,
      .aeolian,
      .dorian,
      .mixolydian,
      .phrygian,
      .lydian,
      .locrian,
      .dimHalf,
      .dimWhole,
      .whole,
      .augmented,
      .chromatic,
      .roumanianMinor,
      .spanishGypsy,
      .blues,
      .diatonic,
      .doubleHarmonic,
      .eightToneSpanish,
      .enigmatic,
      .leadingWholeTone,
      .lydianAugmented,
      .neopolitanMajor,
      .neopolitanMinor,
      .pelog,
      .prometheus,
      .prometheusNeopolitan,
      .sixToneSymmetrical,
      .superLocrian,
      .lydianMinor,
      .lydianDiminished,
      .nineToneScale,
      .auxiliaryDiminished,
      .auxiliaryAugmented,
      .auxiliaryDimBlues,
      .majorLocrian,
      .overtone,
      .diminishedWholeTone,
      .pureMinor,
      .dominant7th,
    ]
  }
}

extension ScaleType: CustomStringConvertible {

  /// Converts `ScaleType` to string with its name.
  public var description: String {
    switch self {
    case .major: return "Major"
    case .minor: return "Minor"
    case .harmonicMinor: return "Harmonic Minor"
    case .melodicMinor: return "Melodic Minor"
    case .pentatonicMajor: return "Pentatonic Major"
    case .pentatonicMinor: return "Pentatonic Minor"
    case .pentatonicBlues: return "Pentatonic Blues"
    case .pentatonicNeutral: return "Pentatonic Neutral"
    case .ionian: return "Ionian"
    case .aeolian: return "Aeolian"
    case .dorian: return "Dorian"
    case .mixolydian: return "Mixolydian"
    case .phrygian: return "Phrygian"
    case .lydian: return "Lydian"
    case .locrian: return "Locrian"
    case .dimHalf: return "Half Diminished"
    case .dimWhole: return "Whole Diminished"
    case .whole: return "Whole"
    case .augmented: return "Augmented"
    case .chromatic: return "Chromatic"
    case .roumanianMinor: return "Roumanian Minor"
    case .spanishGypsy: return "Spanish Gypsy"
    case .blues: return "Blues"
    case .diatonic: return "Diatonic"
    case .doubleHarmonic: return "Double Harmonic"
    case .eightToneSpanish: return "Eight Tone Spanish"
    case .enigmatic: return "Enigmatic"
    case .leadingWholeTone: return "Leading Whole Tone"
    case .lydianAugmented: return "Lydian Augmented"
    case .neopolitanMajor: return "Neopolitan Major"
    case .neopolitanMinor: return "Neopolitan Minor"
    case .pelog: return "Pelog"
    case .prometheus: return "Prometheus"
    case .prometheusNeopolitan: return "Prometheus Neopolitan"
    case .sixToneSymmetrical: return "Six Tone Symmetrical"
    case .superLocrian: return "Super Locrian"
    case .lydianMinor: return "Lydian Minor"
    case .lydianDiminished: return "Lydian Diminished"
    case .nineToneScale: return "Nine Tone Scale"
    case .auxiliaryDiminished: return "Auxiliary Diminished"
    case .auxiliaryAugmented: return "Auxiliary Augmented"
    case .auxiliaryDimBlues: return "Auxiliary Dim Blues"
    case .majorLocrian: return "Major Locrian"
    case .overtone: return "Overtone"
    case .diminishedWholeTone: return "Diminished Whole Tone"
    case .pureMinor: return "Pure Minor"
    case .dominant7th: return "Dominant 7th"
    case .custom(_, let description): return description
    }
  }
}

// MARK: - Scale

/// Checks the equability between two `Scale`s by their base key and notes.
///
/// - Parameters:
///   - left: Left handside of the equation.
///   - right: Right handside of the equation.
/// - Returns: Returns Bool value of equation of two given scales.
public func ==(left: Scale, right: Scale) -> Bool {
	return left.type == right.type && left.key == right.key
}

/// Scale object with `ScaleType` and scale's key of `NoteType`.
/// Could calculate note sequences in [Note] format.
public struct Scale: Equatable {
  /// Type of the scale that has `interval` info.
  public var type: ScaleType
  /// Root key of the scale that will built onto.
  public var key: NoteType

  /// Initilizes the scale with its type and key.
  ///
  /// - Parameters:
  ///   - type: Type of scale being initilized.
  ///   - key: Key of scale being initilized.
  public init(type: ScaleType, key: NoteType) {
    self.type = type
    self.key = key
  }

	/// Notes generated by the intervals of the scale.
	public var noteTypes: [NoteType] {
		return type.intervals.map({ key + $0 })
	}

  /// Generates `Note` array of scale in given octave.
  ///
  /// - Parameter octave: Octave value of notes in scale.
  /// - Returns: Returns `Note` array of the scale in given octave.
  public func notes(octave: Int) -> [Note] {
    return notes(octaves: octave)
  }

  /// Generates `Note` array of scale in given octaves.
  ///
  /// - Parameter octaves: Variadic value of octaves to generate notes in scale.
  /// - Returns: Returns `Note` array of the scale in given octaves.
  public func notes(octaves: Int...) -> [Note] {
    return notes(octaves: octaves)
  }

  /// Generates `Note` array of scale in given octaves.
  ///
  /// - Parameter octaves: Array value of octaves to generate notes in scale.
  /// - Returns: Returns `Note` array of the scale in given octaves.
  public func notes(octaves: [Int]) -> [Note] {
    var notes = [Note]()
    octaves.forEach({ octave in
      let note = Note(type: key, octave: octave)
      notes += type.intervals.map({ note + $0 })
    })
    return notes
  }
}

extension Scale {

	/// Stack of notes to generate chords for each note in the scale.
	public enum HarmonicField {
		/// First, third and fifth degree notes builds a triad chord.
		case triad
		/// First, third, fifth and seventh notes builds a tetrad chord.
		case tetrad
	}

	/// Generates chords for harmonic field of scale.
	///
	/// - Parameter field: Type of chords you want to generate.
	/// - Returns: Returns triads or tetrads of chord for each note in scale.
	public func harmonicField(for field: HarmonicField) -> [Chord] {
		var chords = [ChordType]()
		// Generate notes for octave range of 2, they are going to use in extended chords.
		let scaleNotes = notes(octaves: [1, 2])
		// Build chords for each note in the scale.
		for i in 0..<scaleNotes.count/2 { // Iterate each note in scale (one octave).
			// Get notes for chord.
			var chordNotes = [scaleNotes[i], scaleNotes[i + 2], scaleNotes[i + 4]]
			if field == .tetrad {
				chordNotes.append(scaleNotes[i + 6])
			}
			// Calculate intervals between notes in chord.
			let chordIntervals = chordNotes.map({ $0 - chordNotes[0] })
			if let chord = ChordType(intervals: chordIntervals) { // Determine chord type.
				chords.append(chord)
			}
		}
		// Generate chords for each key in scale.
		return chords.enumerated().map({ Chord(type: $1, key: noteTypes[$0]) })
	}
}

extension Scale: CustomStringConvertible {

  /// Converts `Scale` to string with its key and type.
  public var description: String {
    return "\(key) \(type): " + noteTypes.map({ "\($0)" }).joined(separator: ", ")
  }
}

// MARK: - ChordType

/// Checks the equability between two `ChordType`s by their intervals.
///
/// - Parameters:
///   - left: Left handside of the equation.
///   - right: Right handside of the equation.
/// - Returns: Returns Bool value of equation of two given chord types.
public func ==(left: ChordType, right: ChordType) -> Bool {
	return left.intervals == right.intervals
}

/// Defines chords by note sequences initilized by their intervals.
public enum ChordType: Equatable {
  /// Major chord.
  case maj
  /// Minor chord.
  case min
  /// Agumented chord.
  case aug
	/// 5th chord.
	case M5
  /// Power chord.
  case b5
  /// Diminished chord.
  case dim
  /// Suspended chord
  case sus
  /// Suspended 2 chord.
  case sus2
  /// Dominant 6th chord.
  case dom6
  /// Minor 6th chord.
  case m6
  /// Dominant 7th chord.
  case dom7
  /// Major 7th chord.
  case M7
  /// Minor 7th chord.
  case m7
  /// Agumented 7th chord.
  case aug7
  /// Diminished 7th chord.
  case dim7
  /// Major 7th power chord.
  case M7b5
  /// Minor 7th power chord.
  case m7b5
  /// Dominant 9th chord.
  case dom9
  /// Major 9th chord.
  case M9
  /// Minor 9th chord.
  case m9
  /// Dominant 11th chord.
  case dom11
  /// Major 11th chord.
  case M11
  /// Minor 11th chord.
  case m11
  /// Dominant 13th chord.
  case dom13
  /// Major 13th chord.
  case M13
  /// Minor 13th chord.
  case m13
  /// Added 9th chord.
  case add9
  /// Minor added 9th chord.
  case madd9
  /// Major 7th flat 9th chord.
  case M7b9
  /// Minor 7th flat 9th chord.
  case m7b9
  /// Major 6th added 9th chord.
  case M6add9
  /// Minor 6th added 9th chord.
  case m6add9
  /// Dominant 7th added 11th chord.
  case dom7add11
  /// Major 7th added 11th chord.
  case M7add11
  /// Minor 7th added 11th chord.
  case m7add11
  /// Dominant 7th added 13th chord.
  case dom7add13
  /// Major 7th added 13th chord.
  case M7add13
  /// Minor 7th added 13th chord.
  case m7add13
  /// Major 7th half diminished chord.
  case M7a5
  /// Minor 7th half diminished chord.
  case m7a5
  /// Major 7th shard 9th chord.
  case M7a9
  /// Major 7th half diminished flat 9th chord.
  case M7a5b9
  /// Major 9th sharp 11th chord.
  case M9a11
  /// Major 9th flat 13th chord.
  case M9b13
  /// Major 6th suspended 4 chord.
  case M6sus4
  /// Major 7th suspended 4 chord.
  case maj7sus4
  /// Dominant 7th suspended 4 chord.
  case M7sus4
  /// Dominant 9th suspended 4 chord.
  case M9sus4
  /// Major 9th suspended 4 chord.
  case maj9sus4
  /// Minor major 7th chord.
  case mM7
  /// Minor major 9th chord.
  case mM9
  /// Minor major 11th chord.
  case mM11
  /// Minor major 13th chord.
  case mM13
  /// Minor major 7th added 11th chord.
  case mM7add11
  /// Minor major added 13th chord.
  case mM7add13
  /// Custom chord with given interval series and description.
  case custom(intervals: [Interval], description: String)

  /// Tries to initilize chord with a matching interval series.
  ///
  /// - Parameters:
  ///   - intervals: Intervals of the chord.
	public init?(intervals: [Interval]) {
		guard let chord = ChordType.all.filter({ $0.intervals == intervals }).first
			else { return nil }
		self = chord
	}

  /// Intervals of the chord based on the chord's key.
  public var intervals: [Interval] {
    switch self {
    case .maj: return [.unison, .M3, .P5]
    case .min: return [.unison, .m3, .P5]
    case .aug: return [.unison, .M3, .m6]
		case .M5: return [.unison, .P5]
    case .b5: return [.unison, .M3, .d5]
    case .dim: return [.unison, .m3, .d5]
    case .sus: return [.unison, .P4, .P5]
    case .sus2: return [.unison, .M2, .P5]
    case .dom6: return [.unison, .M3, .P5, .M6]
    case .m6: return [.unison, .m3, .P5, .M6]
    case .dom7: return [.unison, .M3, .P5, .m7]
    case .M7: return [.unison, .M3, .P5, .M7]
    case .m7: return [.unison, .m3, .P5, .m7]
    case .aug7: return [.unison, .M3, .m6, .m7]
    case .dim7: return [.unison, .m3, .d5, .M6]
    case .M7b5: return [.unison, .M3, .m6, .M7]
    case .m7b5: return [.unison, .M3, .d5, .M7]
    case .dom9: return [.unison, .M3, .P5, .m7, .M2 * 2]
    case .M9: return [.unison, .M3, .d5, .P5, .M7, .M2 * 2]
    case .m9: return [.unison, .m3, .P5, .m7, .M2 * 2]
    case .dom11: return [.unison, .M3, .P5, .m7, .M2 * 2, .P4 * 2]
    case .M11: return [.unison, .M3, .P5, .M7, .M2 * 2, .P4 * 2]
    case .m11: return [.unison, .m3, .P5, .m7, .M2 * 2, .P4 * 2]
    case .dom13: return [.unison, .M3, .P5, .m7, .M2 * 2, .P4 * 2, .M6 * 2]
    case .M13: return [.unison, .M3, .P5, .M7, .M2 * 2, .P4 * 2, .M6 * 2]
    case .m13: return [.unison, .m3, .P5, .m7, .M2 * 2, .P4 * 2, .M6 * 2]
    case .add9: return [.unison, .M3, .P5, .M2 * 2]
    case .madd9: return [.unison, .m3, .P5, .M2 * 2]
    case .M7b9: return [.unison, .M3, .P5, .m7, .m2 * 2]
    case .m7b9: return [.unison, .m3, .P5, .m7, .m2 * 2]
    case .M6add9: return [.unison, .M3, .P5, .M6, .M2 * 2]
    case .m6add9: return [.unison, .m3, .P5, .M6, .M2 * 2]
    case .dom7add11: return [.unison, .M3, .P5, .m7, .P4 * 2]
    case .M7add11: return [.unison, .M3, .P5, .M7, .P4 * 2]
    case .m7add11: return [.unison, .m3, .P5, .m7, .P4 * 2]
    case .dom7add13: return [.unison, .M3, .P5, .m7, .M6 * 2]
    case .M7add13: return [.unison, .M3, .P5, .M7, .M6 * 2]
    case .m7add13: return [.unison, .m3, .P5, .m7, .M6 * 2]
    case .M7a5: return [.unison, .M3, .m6, .m7]
    case .m7a5: return [.unison, .m3, .m6, .m7]
    case .M7a9: return [.unison, .M3, .P5, .m7, .m3 * 2]
    case .M7a5b9: return [.unison, .M3, .m6, .m7, .m2 * 2]
    case .M9a11: return [.unison, .M3, .P5, .m7, .M2 * 2, .d5 * 2]
    case .M9b13: return [.unison, .M3, .P5, .m7, .M2 * 2, .m6 * 2]
    case .M6sus4: return [.unison, .P4, .P5, .M6]
    case .maj7sus4: return [.unison, .P4, .P5, .M7]
    case .M7sus4: return [.unison, .P4, .P5, .m7]
    case .M9sus4: return [.unison, .P4, .P5, .m7, .M2 * 2]
    case .maj9sus4: return [.unison, .P4, .P5, .M7, .M2 * 2]
    case .mM7: return [.unison, .m3, .P5, .M7]
    case .mM9: return [.unison, .m3, .P5, .M7, .M2 * 2]
    case .mM11: return [.unison, .m3, .P5, .M7, .M2 * 2, .P4 * 2]
    case .mM13: return [.unison, .m3, .P5, .M7, .M2 * 2, .M6 * 2]
    case .mM7add11: return [.unison, .m3, .P5, .M7, .P4 * 2]
    case .mM7add13: return [.unison, .m3, .P5, .M7, .M6 * 2]
    case .custom(let intervals, _): return intervals
    }
  }

  /// An array of all `ChordType` values.
  public static var all: [ChordType] {
    return [
      .maj, .min, .aug, .b5, .M5, .dim,
      .dom6, .m6, .M6add9, .m6add9,
      .dom7, .M7, .m7, .mM7, .aug7, .dim7,
      .M7b5, .m7b5, .M7a5, .m7a5, .M7b9, .m7b9, .M7a9, .M7a5b9,
      .sus, .sus2, .M6sus4, .maj7sus4, .M7sus4, .M9sus4, .maj9sus4,
      .dom9, .M9, .m9, .mM9, .add9, .madd9, .M9a11, .M9b13,
      .dom11, .M11, .m11, .mM11,
      .dom7add11, .M7add11, .m7add11, .mM7add11,
      .dom13, .M13, .m13, .mM13, .mM7add13,
    ]
  }
}

extension ChordType: CustomStringConvertible {

  /// Converts `ChordType` to string with its name.
  public var description: String {
    switch self {
    case .maj: return "maj"
    case .min: return "min"
    case .aug: return "aug"
		case .M5: return "5"
    case .b5: return "b5"
    case .dim: return "dim"
    case .sus: return "sus4"
    case .sus2: return "sus2"
    case .dom6: return "6"
    case .m6: return "m6"
    case .dom7: return "7"
    case .M7: return "maj7"
    case .m7: return "m7"
    case .aug7: return "aug7"
    case .dim7: return "dim7"
    case .M7b5: return "7b5"
    case .m7b5: return "m7b5"
    case .dom9: return "9"
    case .M9: return "maj9"
    case .m9: return "m9"
    case .dom11: return "11"
    case .M11: return "maj11"
    case .m11: return "m11"
    case .dom13: return "13"
    case .M13: return "maj13"
    case .m13: return "m13"
    case .add9: return "(add9)"
    case .madd9: return "m(add9)"
    case .M7b9: return "7b9"
    case .m7b9: return "m7b9"
    case .M6add9: return "6(add9)"
    case .m6add9: return "m6(add9)"
    case .dom7add11: return "7(add11)"
    case .M7add11: return "maj7(add11)"
    case .m7add11: return "m7(add11)"
    case .dom7add13: return "7(add13)"
    case .M7add13: return "maj7(add13)"
    case .m7add13: return "m7(add13)"
    case .M7a5: return "7#5"
    case .m7a5: return "m7#5"
    case .M7a9: return "7#9"
    case .M7a5b9: return "7#5b9"
    case .M9a11: return "9#11"
    case .M9b13: return "9b13"
    case .M6sus4: return "6sus4"
    case .maj7sus4: return "maj7sus4"
    case .M7sus4: return "7sus4"
    case .M9sus4: return "9sus4"
    case .maj9sus4: return "maj9sus4"
    case .mM7: return "mMaj7"
    case .mM9: return "mMaj9"
    case .mM11: return "mMaj11"
    case .mM13: return "mMaj13"
    case .mM7add11: return "mMaj7(add11)"
    case .mM7add13: return "mMaj7(add13)"
    case .custom(_, let description): return "\(description)"
    }
  }
}

// MARK: - Chord

/// Checks the equability between two chords by their base key and notes.
///
/// - Parameters:
///   - left: Left handside of the equation.
///   - right: Right handside of the equation.
/// - Returns: Returns Bool value of equation of two given chords.
public func ==(left: Chord, right: Chord) -> Bool {
	return left.type == right.type && left.key == right.key
}

/// Chord object with its type and key.
public struct Chord: Equatable {
  /// Type of the chord that has `interval` info.
  public var type: ChordType
  /// Root key of the chord that will built onto.
  public var key: NoteType

  /// Initilizes the chord with type and key.
  ///
  /// - Parameters:
  ///   - type: `ChordType` of the chord.
  ///   - key: Key note of the chord.
  public init(type: ChordType, key: NoteType) {
    self.type = type
    self.key = key
  }

  /// Generates chord `Note`s for given octave.
  ///
  /// - Parameter octave: Octave of the chord.
  /// - Returns: Returns `Note` array with chord's notes in given octave.
  public func notes(octave: Int) -> [Note] {
    return notes(octaves: octave)
  }

  /// Generates chord `Note`s for given octaves.
  ///
  /// - Parameter octaves: Variadic value of octaves.
  /// - Returns: Returns `Note` array with chord's notes in given octaves.
  public func notes(octaves: Int...) -> [Note] {
    return notes(octaves: octaves)
  }

  /// Generates chord `Note`s for given octaves.
  ///
  /// - Parameter octaves: Array value of octaves.
  /// - Returns: Returns `Note` array with chord's notes in given octaves.
  public func notes(octaves: [Int]) -> [Note] {
    var notes = [Note]()
    octaves.forEach({ octave in
      let note = Note(type: key, octave: octave)
      notes += type.intervals.map({ note + $0 })
    })
    return notes
  }

  /// Notes generated by the intervals of the chord.
  public var noteTypes: [NoteType] {
    return type.intervals.map({ key + $0 })
  }
}

extension Chord: CustomStringConvertible {

  /// Converts `Chord` to string with its key and type.
  public var description: String {
    return "\(key)\(type)"
  }
}
