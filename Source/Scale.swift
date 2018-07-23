//
//  Scale.swift
//  MusicTheory
//
//  Created by Cem Olcay on 24.10.2017.
//  Copyright © 2017 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

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

  /// Tries to initilize scale with a matching interval series. If no scale matched with intervals, than initlizes custom scale.
  ///
  /// - Parameters:
  ///   - intervals: Intervals of the chord.
  ///   - description: In case of .custom type scale, you probably need description.
  public init(intervals: [Interval], description: String = "") {
    if let scale = ScaleType.all.filter({ $0.intervals == intervals }).first {
      self = scale
    } else {
      self = .custom(intervals: intervals, description: description)
    }
  }

  /// Intervals of the scale.
  public var intervals: [Interval] {
    switch self {
    case .major: return [.P1, .M2, .M3, .P4, .P5, .M6, .M7]
    case .minor: return [.P1, .M2, .m3, .P4, .P5, .m6, .m7]
    case .harmonicMinor: return [.P1, .M2, .m3, .P4, .P5, .m6, .M7]
    case .dorian: return [.P1, .M2, .m3, .P4, .P5, .M6, .m7]
    case .phrygian: return [.P1, .m2, .m3, .P4, .P5, .m6, .m7]
    case .lydian: return [.P1, .M2, .M3, .d5, .P5, .M6, .M7]
    case .mixolydian: return [.P1, .M2, .M3, .P4, .P5, .M6, .m7]
    case .locrian: return [.P1, .m2, .m3, .P4, .d5, .m6, .m7]
    case .melodicMinor: return [.P1, .M2, .m3, .P4, .P5, .M6, .M7]
    case .pentatonicMajor: return [.P1, .M2, .M3, .P5, .M6]
    case .pentatonicMinor: return [.P1, .m3, .P4, .P5, .m7]
    case .pentatonicBlues: return [.P1, .m3, .P4, .d5, .P5, .m7]
    case .pentatonicNeutral: return [.P1, .M2, .P4, .P5, .m7]
    case .ionian: return [.P1, .M2, .M3, .P4, .P5, .M6, .M7]
    case .aeolian: return [.P1, .M2, .m3, .P4, .P5, .m6, .m7]
    case .dimHalf: return [.P1, .m2, .m3, .M3, .d5, .P5, .M6, .m7]
    case .dimWhole: return [.P1, .M2, .m3, .P4, .d5, .m6, .M6, .M7]
    case .whole: return [.P1, .M2, .M3, .d5, .m6, .m7]
    case .augmented: return [.m3, .M3, .P5, .m6, .M7]
    case .chromatic: return [.P1, .m2, .M2, .m3, .M3, .P4, .d5, .P5, .m6, .M6, .m7, .M7]
    case .roumanianMinor: return [.P1, .M2, .m3, .d5, .P5, .M6, .m7]
    case .spanishGypsy: return [.P1, .m2, .M3, .P4, .P5, .m6, .m7]
    case .blues: return [.P1, .m3, .P4, .d5, .P5, .m7]
    case .diatonic: return [.P1, .M2, .M3, .P5, .M6]
    case .doubleHarmonic: return [.P1, .m2, .M3, .P4, .P5, .m6, .M7]
    case .eightToneSpanish: return [.P1, .m2, .m3, .M3, .P4, .d5, .m6, .m7]
    case .enigmatic: return [.P1, .m2, .M3, .d5, .m6, .m7, .M7]
    case .leadingWholeTone: return [.P1, .M2, .M3, .d5, .m6, .M6, .m7]
    case .lydianAugmented: return [.P1, .M2, .M3, .d5, .m6, .M6, .M7]
    case .neopolitanMajor: return [.P1, .m2, .m3, .P4, .P5, .M6, .M7]
    case .neopolitanMinor: return [.P1, .m2, .m3, .P4, .P5, .m6, .m7]
    case .pelog: return [.P1, .m2, .m3, .d5, .m7, .M7]
    case .prometheus: return [.P1, .M2, .M3, .d5, .M6, .m7]
    case .prometheusNeopolitan: return [.P1, .m2, .M3, .d5, .M6, .m7]
    case .sixToneSymmetrical: return [.P1, .m2, .M3, .P4, .m6, .M6]
    case .superLocrian: return [.P1, .m2, .m3, .M3, .d5, .m6, .m7]
    case .lydianMinor: return [.P1, .M2, .M3, .d5, .P5, .m6, .m7]
    case .lydianDiminished: return [.P1, .M2, .m3, .d5, .P5, .m6, .m7]
    case .nineToneScale: return [.P1, .M2, .m3, .M3, .d5, .P5, .m6, .M6, .M7]
    case .auxiliaryDiminished: return [.P1, .M2, .m3, .P4, .d5, .m6, .M6, .M7]
    case .auxiliaryAugmented: return [.P1, .M2, .M3, .d5, .m6, .m7]
    case .auxiliaryDimBlues: return [.P1, .m2, .m3, .M3, .d5, .P5, .M6, .m7]
    case .majorLocrian: return [.P1, .M2, .M3, .P4, .d5, .m6, .m7]
    case .overtone: return [.P1, .M2, .M3, .d5, .P5, .M6, .m7]
    case .diminishedWholeTone: return [.P1, .m2, .m3, .M3, .d5, .m6, .m7]
    case .pureMinor: return [.P1, .M2, .m3, .P4, .P5, .m6, .m7]
    case .dominant7th: return [.P1, .M2, .M3, .P4, .P5, .M6, .m7]
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

extension ScaleType: Codable {

  /// Keys that conforms CodingKeys protocol to map properties.
  private enum CodingKeys: String, CodingKey {
    /// Halfstep property of `Interval`.
    case intervals
  }

  /// Decodes struct with a decoder.
  ///
  /// - Parameter decoder: Decodes encoded struct.
  /// - Throws: Tries to initlize struct with a decoder.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let intervals = try values.decode([Interval].self, forKey: .intervals)
    self = ScaleType(intervals: intervals)
  }

  /// Encodes struct with an ecoder.
  ///
  /// - Parameter encoder: Encodes struct.
  /// - Throws: Tries to encode struct.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(intervals, forKey: .intervals)
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
    case .auxiliaryDimBlues: return "Auxiliary Diminished Blues"
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
  return left.key == right.key && left.type == right.type
}

/// Scale object with `ScaleType` and scale's key of `NoteType`.
/// Could calculate note sequences in [Note] format.
public struct Scale: Equatable, Codable {
  /// Type of the scale that has `interval` info.
  public var type: ScaleType
  /// Root key of the scale that will built onto.
  public var key: Key

  /// Initilizes the scale with its type and key.
  ///
  /// - Parameters:
  ///   - type: Type of scale being initilized.
  ///   - key: Key of scale being initilized.
  public init(type: ScaleType, key: Key) {
    self.type = type
    self.key = key
  }

  /// Keys generated by the intervals of the scale.
  public var keys: [Key] {
    return pitches(octave: 1).map({ $0.key })
  }

  /// Generates `Pitch` array of scale in given octave.
  ///
  /// - Parameter octave: Octave value of notes in scale.
  /// - Returns: Returns `Pitch` array of the scale in given octave.
  public func pitches(octave: Int) -> [Pitch] {
    return pitches(octaves: octave)
  }

  /// Generates `Pitch` array of scale in given octaves.
  ///
  /// - Parameter octaves: Variadic value of octaves to generate pitches in scale.
  /// - Returns: Returns `Pitch` array of the scale in given octaves.
  public func pitches(octaves: Int...) -> [Pitch] {
    return pitches(octaves: octaves)
  }

  /// Generates `Pitch` array of scale in given octaves.
  ///
  /// - Parameter octaves: Array value of octaves to generate pitches in scale.
  /// - Returns: Returns `Pitch` array of the scale in given octaves.
  public func pitches(octaves: [Int]) -> [Pitch] {
    var pitches = [Pitch]()
    octaves.forEach({ octave in
      let root = Pitch(key: key, octave: octave)
      pitches += type.intervals.map({ root + $0 })
    })
    return pitches
  }
}

extension Scale {

  /// Stack of notes to generate chords for each note in the scale.
  public enum HarmonicField: Int, Codable {
    /// First, third and fifth degree notes builds a triad chord.
    case triad
    /// First, third, fifth and seventh notes builds a tetrad chord.
    case tetrad
    /// First, third, fifth, seventh and ninth notes builds a 9th chord.
    case ninth
    /// First, third, fifth, seventh, ninth and eleventh notes builds a 11th chord.
    case eleventh
    /// First, third, fifth, seventh, ninth, eleventh and thirteenth notes builds a 13th chord.
    case thirteenth

    /// All possible harmonic fields constructed from.
    public static let all: [HarmonicField] = [.triad, .tetrad, .ninth, .eleventh, .thirteenth]
  }

  /// Generates chords for harmonic field of scale.
  ///
  /// - Parameter field: Type of chords you want to generate.
  /// - Parameter inversion: Inversion degree of the chords. Defaults 0.
  /// - Returns: Returns triads or tetrads of chord for each note in scale.
  public func harmonicField(for field: HarmonicField, inversion: Int = 0) -> [Chord?] {
    var chords = [Chord?]()

    // Extended notes for picking notes.
    let octaves = [0, 1, 2, 3, 4]
    let scalePitches = pitches(octaves: octaves)

    // Build chords for each note in scale.
    for i in 0..<scalePitches.count/octaves.count {
      var chordPitches = [Pitch]()
      switch field {
      case .triad:
        chordPitches = [scalePitches[i], scalePitches[i + 2], scalePitches[i + 4]]
      case .tetrad:
        chordPitches = [scalePitches[i], scalePitches[i + 2], scalePitches[i + 4], scalePitches[i + 6]]
      case .ninth:
        chordPitches = [scalePitches[i], scalePitches[i + 2], scalePitches[i + 4], scalePitches[i + 6], scalePitches[i + 8]]
      case .eleventh:
        chordPitches = [scalePitches[i], scalePitches[i + 2], scalePitches[i + 4], scalePitches[i + 6], scalePitches[i + 8], scalePitches[i + 10]]
      case .thirteenth:
        chordPitches = [scalePitches[i], scalePitches[i + 2], scalePitches[i + 4], scalePitches[i + 6], scalePitches[i + 8], scalePitches[i + 10], scalePitches[i + 12]]
      }

      // Build intervals
      let root = chordPitches[0]
      let intervals = chordPitches.map({ $0 - root })

      // Build chord
      if let chordType = ChordType(intervals: intervals) {
        let chord = Chord(type: chordType, key: root.key, inversion: inversion)
        chords.append(chord)
      } else {
        chords.append(nil)
      }
    }

    return chords
  }
}

extension Scale: CustomStringConvertible {

  /// Converts `Scale` to string with its key and type.
  public var description: String {
    return "\(key) \(type): " + keys.map({ "\($0)" }).joined(separator: ", ")
  }
}
