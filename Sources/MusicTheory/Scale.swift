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

/// Represents scale by the intervals between note sequences.
public struct ScaleType: Equatable, CustomStringConvertible {
  /// Major scale.
  public static let major = ScaleType(intervals: ScaleType.ionian.intervals, description: "Major")
  /// Minor scale.
  public static let minor = ScaleType(intervals: ScaleType.aeolian.intervals, description: "Minor")
  /// Harmonic minor scale.
  public static let harmonicMinor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .m6, .M7], description: "Harmonic Minor")
  /// Melodic minor scale.
  public static let melodicMinor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .M6, .m7], description: "Melodic Minor")
  /// Pentatonic major scale.
  public static let pentatonicMajor = ScaleType(intervals: [.P1, .M2, .M3, .P5, .M6], description: "Pentatonic Major")
  /// Pentatonic minor scale.
  public static let pentatonicMinor = ScaleType(intervals: [.P1, .m3, .P4, .P5, .m7], description: "Pentatonic Minor")
  /// Pentatonic blues scale.
  public static let pentatonicBlues = ScaleType(intervals: [.P1, .m3, .P4, .d5, .P5, .m7], description: "Pentatonic Blues")
  /// Pentatonic neutral scale.
  public static let pentatonicNeutral = ScaleType(intervals: [.P1, .M2, .P4, .P5, .m7], description: "Pentatonic Neutral")
  /// Ionian scale.
  public static let ionian = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .M6, .M7], description: "Ionian")
  /// Aeolian scale.
  public static let aeolian = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .m6, .m7], description: "Aeolian")
  /// Dorian scale.
  public static let dorian = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .M6, .m7], description: "Dorian")
  /// Mixolydian scale.
  public static let mixolydian = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .M6, .m7], description: "Mixolydian")
  /// Phrygian scale.
  public static let phrygian = ScaleType(intervals: [.P1, .m2, .m3, .P4, .P5, .m6, .m7], description: "Phrygian")
  /// Lydian scale.
  public static let lydian = ScaleType(intervals: [.P1, .M2, .M3, .d5, .P5, .M6, .M7], description: "Lydian")
  /// Locrian scale.
  public static let locrian = ScaleType(intervals: [.P1, .m2, .m3, .P4, .d5, .m6, .m7], description: "Locrian")
  /// Half diminished scale.
  public static let dimHalf = ScaleType(intervals: [.P1, .m2, .m3, .M3, .d5, .P5, .M6, .m7], description: "Half Diminished")
  /// Whole diminished scale.
  public static let dimWhole = ScaleType(intervals: [.P1, .M2, .m3, .P4, .d5, .m6, .M6, .M7], description: "Whole Diminished")
  /// Whole scale.
  public static let whole = ScaleType(intervals: [.P1, .M2, .M3, .d5, .m6, .m7], description: "Whole")
  /// Augmented scale.
  public static let augmented = ScaleType(intervals: [.m3, .M3, .P5, .m6, .M7], description: "Augmented")
  /// Chromatic scale.
  public static let chromatic = ScaleType(intervals: [.P1, .m2, .M2, .m3, .M3, .P4, .d5, .P5, .m6, .M6, .m7, .M7], description: "Chromatic")
  /// Roumanian minor scale.
  public static let romanianMinor = ScaleType(intervals: [.P1, .M2, .m3, .d5, .P5, .M6, .m7], description: "Romanian Minor")
  /// Spanish gypsy scale.
  public static let spanishGypsy = ScaleType(intervals: [.P1, .m2, .M3, .P4, .P5, .m6, .m7], description: "Spanish Gypsy")
  /// Blues scale.
  public static let blues = ScaleType(intervals: [.P1, .m3, .P4, .d5, .P5, .m7], description: "Blues")
  /// Diatonic scale.
  public static let diatonic = ScaleType(intervals: [.P1, .M2, .M3, .P5, .M6], description: "Diatonic")
  /// Dobule harmonic scale.
  public static let doubleHarmonic = ScaleType(intervals: [.P1, .m2, .M3, .P4, .P5, .m6, .M7], description: "Double Harmonic")
  /// Eight tone spanish scale.
  public static let eightToneSpanish = ScaleType(intervals: [.P1, .m2, .m3, .M3, .P4, .d5, .m6, .m7], description: "Eight Tone Spanish")
  /// Enigmatic scale.
  public static let enigmatic = ScaleType(intervals: [.P1, .m2, .M3, .d5, .m6, .m7, .M7], description: "Enigmatic")
  /// Leading whole tone scale.
  public static let leadingWholeTone = ScaleType(intervals: [.P1, .M2, .M3, .d5, .m6, .M6, .m7], description: "Leading Whole Tone")
  /// Lydian augmented scale.
  public static let lydianAugmented = ScaleType(intervals: [.P1, .M2, .M3, .d5, .m6, .M6, .M7], description: "Lydian Augmented")
  /// Neopolitan major scale.
  public static let neopolitanMajor = ScaleType(intervals: [.P1, .m2, .m3, .P4, .P5, .M6, .M7], description: "Neopolitan Major")
  /// Neopolitan minor scale.
  public static let neopolitanMinor = ScaleType(intervals: [.P1, .m2, .m3, .P4, .P5, .m6, .m7], description: "Neopolitan Minor")
  /// Pelog scale.
  public static let pelog = ScaleType(intervals: [.P1, .m2, .m3, .d5, .m7, .M7], description: "Pelog")
  /// Prometheus scale.
  public static let prometheus = ScaleType(intervals: [.P1, .M2, .M3, .d5, .M6, .m7], description: "Prometheus")
  /// Prometheus neopolitan scale.
  public static let prometheusNeopolitan = ScaleType(intervals: [.P1, .m2, .M3, .d5, .M6, .m7], description: "Prometheus Neopolitan")
  /// Six tone symmetrical scale.
  public static let sixToneSymmetrical = ScaleType(intervals: [.P1, .m2, .M3, .P4, .m6, .M6], description: "Six Tone Symmetrical")
  /// Super locrian scale.
  public static let superLocrian = ScaleType(intervals: [.P1, .m2, .m3, .M3, .d5, .m6, .m7], description: "Super Locrian")
  /// Lydian minor scale.
  public static let lydianMinor = ScaleType(intervals: [.P1, .M2, .M3, .d5, .P5, .m6, .m7], description: "Lydian Minor")
  /// Lydian diminished scale.
  public static let lydianDiminished = ScaleType(intervals: [.P1, .M2, .m3, .d5, .P5, .m6, .m7], description: "Lydian Diminished")
  /// Nine tone scale.
  public static let nineToneScale = ScaleType(intervals: [.P1, .M2, .m3, .M3, .d5, .P5, .m6, .M6, .M7], description: "Nine Tone Scale")
  /// Auxiliary diminished scale.
  public static let auxiliaryDiminished = ScaleType(intervals: [.P1, .M2, .m3, .P4, .d5, .m6, .M6, .M7], description: "Auxiliary Diminished")
  /// Auxiliary augmaneted scale.
  public static let auxiliaryAugmented = ScaleType(intervals: [.P1, .M2, .M3, .d5, .m6, .m7], description: "Auxiliary Augmented")
  /// Auxiliary diminished blues scale.
  public static let auxiliaryDimBlues = ScaleType(intervals: [.P1, .m2, .m3, .M3, .d5, .P5, .M6, .m7], description: "Auxiliary Diminished Blues")
  /// Major locrian scale.
  public static let majorLocrian = ScaleType(intervals: [.P1, .M2, .M3, .P4, .d5, .m6, .m7], description: "Major Locrian")
  /// Overtone scale.
  public static let overtone = ScaleType(intervals: [.P1, .M2, .M3, .d5, .P5, .M6, .m7], description: "Overtone")
  /// Diminished whole tone scale.
  public static let diminishedWholeTone = ScaleType(intervals: [.P1, .m2, .m3, .M3, .d5, .m6, .m7], description: "Diminished Whole Tone")
  /// Pure minor scale.
  public static let pureMinor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .m6, .m7], description: "Pure Minor")
  /// Dominant seventh scale.
  public static let dominant7th = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .M6, .m7], description: "Dominant 7th")

  /// Intervals of the scale.
  public let intervals: [Interval]
  /// Description of the scale.
  public let description: String

  /// Initilize the scale with series of its intervals.
  ///
  /// - Parameters:
  ///   - intervals: Intervals of the scale.
  ///   - description: Description of the scale.
  public init(intervals: [Interval], description: String) {
    self.intervals = intervals
    self.description = description
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
      .romanianMinor,
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

  // MARK: Equatable

  /// Checks the equability between two `ScaleType`s by their intervals.
  ///
  /// - Parameters:
  ///   - left: Left handside of the equation.
  ///   - right: Right handside of the equation.
  /// - Returns: Returns Bool value of equation of two given scale types.
  public static func == (left: ScaleType, right: ScaleType) -> Bool {
    return left.intervals == right.intervals && left.description == right.description
  }
}

extension ScaleType: Codable {
  /// Keys that conforms CodingKeys protocol to map properties.
  private enum CodingKeys: String, CodingKey {
    /// Halfstep property of `Interval`.
    case intervals
    /// Name of the scale.
    case description
  }

  /// Decodes struct with a decoder.
  ///
  /// - Parameter decoder: Decodes encoded struct.
  /// - Throws: Tries to initlize struct with a decoder.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let intervals = try values.decode([Interval].self, forKey: .intervals)
    let description = try values.decode(String.self, forKey: .description)
    self = ScaleType(intervals: intervals, description: description)
  }

  /// Encodes struct with an ecoder.
  ///
  /// - Parameter encoder: Encodes struct.
  /// - Throws: Tries to encode struct.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(intervals, forKey: .intervals)
    try container.encode(description, forKey: .description)
  }
}

// MARK: - Scale

/// Checks the equability between two `Scale`s by their base key and notes.
///
/// - Parameters:
///   - left: Left handside of the equation.
///   - right: Right handside of the equation.
/// - Returns: Returns Bool value of equation of two given scales.
public func == (left: Scale, right: Scale) -> Bool {
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
    for i in 0 ..< scalePitches.count / octaves.count {
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
