//
//  ScaleType.swift
//  
//
//  Created by Cem Olcay on 1/16/22.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

/// Represents scale by the intervals between note sequences.
public struct ScaleType: Codable, Hashable, CustomStringConvertible {
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

  // MARK: Hashable

  public func hash(into hasher: inout Hasher) {
    hasher.combine(intervals)
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

  // MARK: Codable

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

extension ScaleType {
  /// Major scale.
  public static let major = ScaleType(intervals: ScaleType.ionian.intervals, description: "Major")

  /// Minor scale.
  public static let minor = ScaleType(intervals: ScaleType.aeolian.intervals, description: "Minor")

  /// Harmonic minor scale.
  public static let harmonicMinor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .m6, .M7], description: "Harmonic Minor")

  /// Melodic minor scale.
  public static let melodicMinor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .M6, .M7], description: "Melodic Minor")

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
  public static let lydian = ScaleType(intervals: [.P1, .M2, .M3, .A4, .P5, .M6, .M7], description: "Lydian")

  /// Locrian scale.
  public static let locrian = ScaleType(intervals: [.P1, .m2, .m3, .P4, .d5, .m6, .m7], description: "Locrian")

  /// Half diminished scale.
  public static let halfDiminished = ScaleType(intervals: [.P1, .m2, .m3, .M3, .d5, .P5, .M6, .m7], description: "Half Diminished")

  /// Whole diminished scale.
  public static let wholeDiminished = ScaleType(intervals: [.P1, .M2, .m3, .P4, .d5, .m6, .M6, .M7], description: "Whole Diminished")

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

  /// Diatonic scale.
  public static let diatonic = ScaleType(intervals: [.P1, .M2, .M3, .P5, .M6], description: "Diatonic")

  /// Dobule harmonic scale.
  public static let doubleHarmonic = ScaleType(intervals: [.P1, .m2, .M3, .P4, .P5, .m6, .M7], description: "Double Harmonic")

  /// Eight tone spanish scale.
  public static let eightToneSpanish = ScaleType(intervals: [.P1, .m2, .m3, .M3, .P4, .d5, .m6, .m7], description: "Eight Tone Spanish")

  /// Enigmatic scale.
  public static let enigmatic = ScaleType(intervals: [.P1, .m2, .M3, .A4, .A5, .A6, .M7], description: "Enigmatic")

  /// Leading whole tone scale.
  public static let leadingWholeTone = ScaleType(intervals: [.P1, .M2, .M3, .d5, .m6, .M6, .m7], description: "Leading Whole Tone")

  /// Lydian augmented scale.
  public static let lydianAugmented = ScaleType(intervals: [.P1, .M2, .M3, .A4, .A5, .M6, .M7], description: "Lydian Augmented")

  /// Neopolitan major scale.
  public static let neopolitanMajor = ScaleType(intervals: [.P1, .m2, .m3, .P4, .P5, .M6, .M7], description: "Neopolitan Major")

  /// Neopolitan minor scale.
  public static let neopolitanMinor = ScaleType(intervals: [.P1, .m2, .m3, .P4, .P5, .m6, .m7], description: "Neopolitan Minor")

  /// Pelog scale.
  public static let pelog = ScaleType(intervals: [.P1, .m2, .m3, .d5, .m7, .M7], description: "Pelog")

  /// Prometheus scale.
  public static let prometheus = ScaleType(intervals: [.P1, .M2, .M3, .A4, .M6, .m7], description: "Prometheus")

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
  public static let nineTone = ScaleType(intervals: [.P1, .M2, .m3, .M3, .d5, .P5, .m6, .M6, .M7], description: "Nine Tone")

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

  /// Dominant seventh scale.
  public static let dominant7th = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .M6, .m7], description: "Dominant 7th")

  /// Altered scale
  public static let altered = ScaleType(intervals: [.P1, .m2, .m3, .M3, .d5, .m6, .m7], description: "Altered")

  /// Arabian scale
  public static let arabian = ScaleType(intervals: [.P1, .M2, .M3, .P4, .d5, .m6, .m7], description: "Arabian")

  /// Ionian augmented scale
  public static let ionianAugmented = ScaleType(intervals: [.P1, .M2, .M3, .P4, .m6, .M6, .M7], description: "Ionian Augmented")

  /// Balinese scale
  public static let balinese = ScaleType(intervals: [.P1, .m2, .m3, .P5, .m6], description: "Balinese")

  /// Byzantine scale
  public static let byzantine = ScaleType(intervals: [.P1, .m2, .M3, .P4, .P5, .m6, .M7], description: "Byzantine")

  /// Chinese scale
  public static let chinese = ScaleType(intervals: [.P1, .M3, .d5, .P5, .M7], description: "Chinese")

  /// Dorian #4 scale
  public static let dorianSharp4 = ScaleType(intervals: [.P1, .M2, .m3, .d5, .P5, .M6, .m7], description: "Dorian #4")

  /// Dorian b2 scale
  public static let dorianFlat2 = ScaleType(intervals: [.P1, .m2, .m3, .P4, .P5, .M6, .m7], description: "Dorian b2")

  /// Hindu scale
  public static let hindu = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .m6, .m7], description: "Hindu")

  /// Hirajoshi scale
  public static let hirajoshi = ScaleType(intervals: [.P1, .M2, .m3, .P5, .m6], description: "Hirajoshi")

  /// Hungarian major scale
  public static let hungarianMajor = ScaleType(intervals: [.P1, .m3, .M3, .d5, .P5, .M6, .m7], description: "Hungarian Major")

  /// Hungarian minor scale
  public static let hungarianMinor = ScaleType(intervals: [.P1, .M2, .m3, .A4, .P5, .m6, .M7], description: "Hungarian Minor")

  /// Ichikosucho scale
  public static let ichikosucho = ScaleType(intervals: [.P1, .M2, .M3, .P4, .d5, .P5, .M6, .M7], description: "Ichikosucho")

  /// Kumoi scale
  public static let kumoi = ScaleType(intervals: [.P1, .M2, .m3, .P5, .M6], description: "Kumoi")

  /// Locrian 2 scale
  public static let locrian2 = ScaleType(intervals: [.P1, .M2, .m3, .P4, .d5, .m6, .m7], description: "Locrian 2")

  /// Locrian 3 scale
  public static let locrian3 = ScaleType(intervals: [.P1, .m2, .M3, .P4, .d5, .m6, .m7], description: "Locrian 3")

  /// Locrian 6 scale
  public static let locrian6 = ScaleType(intervals: [.P1, .m2, .m3, .P4, .d5, .M6, .m7], description: "Locrian 6")

  /// Lydian #2 scale
  public static let lydianSharp2 = ScaleType(intervals: [.P1, .m3, .M3, .d5, .P5, .M6, .M7], description: "Lydian #2")

  /// Lydian b7 scale
  public static let lydianFlat7 = ScaleType(intervals: [.P1, .M2, .M3, .d5, .P5, .M6, .m7], description: "Lydian b7")

  /// Phrygian Major scale
  public static let phrygianMajor = ScaleType(intervals: [.P1, .m2, .M3, .P4, .P5, .m6, .m7], description: "Phrygian Major")

  /// Mixolydian b6 scale
  public static let mixolydianFlat6 = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .m6, .m7], description: "Mixolydian b6")

  /// Mohammedan scale
  public static let mohammedan = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .m6, .M7], description: "Mohammedan")

  /// Mongolian scale
  public static let mongolian = ScaleType(intervals: [.P1, .M2, .M3, .P5, .M6], description: "Mongolian")

  /// Natural minor scale
  public static let naturalMinor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .m6, .m7], description: "Natural Minor")

  /// Neopolitan scale
  public static let neopolitan = ScaleType(intervals: [.P1, .m2, .m3, .P4, .P5, .m6, .M7], description: "Neopolitan")

  /// Persian scale
  public static let persian = ScaleType(intervals: [.P1, .m2, .M3, .P4, .d5, .m6, .M7], description: "Persian")

  /// Purvi theta scale
  public static let purviTheta = ScaleType(intervals: [.P1, .m2, .M3, .d5, .P5, .m6, .M7], description: "Purvi Theta")

  /// Todi theta scale
  public static let todiTheta = ScaleType(intervals: [.P1, .m2, .m3, .d5, .P5, .m6, .M7], description: "Todi Theta")

  /// Major bebop scale
  public static let majorBebop = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .m6, .M6, .M7], description: "Major Bebop")

  /// Minor bebop scale
  public static let minorBebop = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .M6, .m7, .M7], description: "Minor Bebop")

  /// Bebop dominant scale
  public static let bebopDominant = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .M6, .m7, .M7], description: "Bebop Dominant")

  /// Tritone scale
  public static let tritone = ScaleType(intervals: [.P1, .m2, .M3, .d5, .P5, .m7], description: "Tritone")

  /// Insen scale
  public static let insen = ScaleType(intervals: [.P1, .m2, .P4, .P5, .m7], description: "Insen")

  /// Istrian scale
  public static let istrian = ScaleType(intervals: [.P1, .m2, .m3, .d4, .d5, .P5], description: "Istrian")

  /// Gypsy scale
  public static let gypsy = ScaleType(intervals: [.P1, .M2, .m3, .A4, .P5, .m6, .m7], description: "Gypsy")

  /// Iwato scale
  public static let iwato = ScaleType(intervals: [.P1, .m2, .P4, .d5, .m7], description: "Iwato")

  /// Pfluke scale
  public static let pfluke = ScaleType(intervals: [.P1, .M2, .m3, .A4, .P5, .M6, .M7], description: "Pfluke")

  /// Ukrainian dorian scale
  public static let ukrainianDorian = ScaleType(intervals: [.P1, .M2, .m3, .A4, .P5, .M6, .m7], description: "Ukrainian Dorian")

  /// Yo scale
  public static let yo = ScaleType(intervals: [.P1, .m3, .P4, .P5, .m7], description: "Yo")

  /// Algerian scale
  public static let algerian = ScaleType(intervals: [.P1, .M2, .m3, .A4, .P5, .m6, .M7], description: "Algerian")

  /// Flamenco scale
  public static let flamenco = ScaleType(intervals: [.P1, .m2, .M3, .P4, .P5, .m6, .M7], description: "Flamenco")

  /// Hawaiian scale
  public static let hawaiian = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .M6, .M7], description: "Hawaiian")

  /// Maqam scale
  public static let maqam = ScaleType(intervals: [.P1, .m2, .M3, .P4, .P5, .m6, .M7], description: "Maqam")

  /// Oriental scale
  public static let oriental = ScaleType(intervals: [.P1, .m2, .M3, .P4, .d5, .M6, .m7], description: "Oriental")

  /// Jazz melodic minor scale
  public static let jazzMelodicMinor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .M6, .M7], description: "Jazz Melodic Minor")

  /// Lydian augmented #6 scale
  public static let lydianAugmentedSharp6 = ScaleType(intervals: [.P1, .M2, .M3, .d5, .m6, .m7, .M7], description: "Lydian Augmented #6")

  /// Lydian augmented #2 scale
  public static let lydianAugmentedSharp2 = ScaleType(intervals: [.P1, .m3, .M3, .d5, .m6, .M6, .M7], description: "Lydian Augmented #2")

  /// Dorian b5 scale
  public static let dorianFlat5 = ScaleType(intervals: [.P1, .M2, .m3, .P4, .d5, .M6, .m7], description: "Dorian b5")

  /// Phrygian b4 scale
  public static let phrygianFlat4 = ScaleType(intervals: [.P1, .m2, .m3, .M3, .P5, .m6, .m7], description: "Phrygian b4")

  /// Lydian b3 scale
  public static let lydianFlat3 = ScaleType(intervals: [.P1, .M2, .m3, .d5, .P5, .M6, .M7], description: "Lydian b3")

  /// Lydian b6 scale
  public static let lydianFlat6 = ScaleType(intervals: [.P1, .M2, .M3, .d5, .P5, .m6, .m7], description: "Lydian b6")

  /// Lydian #6 scale
  public static let lydianSharp6 = ScaleType(intervals: [.P1, .M2, .M3, .d5, .P5, .m7, .M7], description: "Lydian #6")

  /// Lydian #2 #6 scale
  public static let lydianSharp2Sharp6 = ScaleType(intervals: [.P1, .m3, .M3, .d5, .P5, .m7, .M7], description: "Lydian #2 #6")

  /// Mixolydian b2 scale
  public static let mixolydianFlat2 = ScaleType(intervals: [.P1, .m2, .M3, .P4, .P5, .M6, .m7], description: "Mixolydian b2")

  /// Mixolydian augmented scale
  public static let mixolydianAugmented = ScaleType(intervals: [.P1, .M2, .M3, .P4, .m6, .M6, .m7], description: "Mixolydian Augmented")

  /// Locrian diminished scale
  public static let locrianDiminished = ScaleType(intervals: [.P1, .m2, .m3, .P4, .d5, .m6, .M6], description: "Locrian Diminished")

  /// Locrian diminished bb3 scale
  public static let locrianDiminishedFlatFlat3 = ScaleType(intervals: [.P1, .m2, .P4, .d5, .m6, .M6], description: "Locrian Diminished bb3")

  /// Ionian #2 scale
  public static let ionianSharp2 = ScaleType(intervals: [.P1, .m3, .M3, .P4, .P5, .M6, .M7], description: "Ionian #2")

  /// Super locrian Diminished bb3 scale
  public static let superLocrianDiminshedFlatFlat3 = ScaleType(intervals: [.P1, .m2, .M2, .M3, .d5, .m6, .M6], description: "Super Locrian Diminished bb3")

  /// Ultraphrygian scale
  public static let ultraphrygian = ScaleType(intervals: [.P1, .m2, .m3, .M3, .P5, .m6, .M6], description: "Ultraphrygian")

  /// Ionian Augmented #2 scale
  public static let ionianAugmentedSharp2 = ScaleType(intervals: [.P1, .m3, .M3, .P4, .m6, .M6, .M7], description: "Ionian Augmented #2")

  /// Major blues hexatonic scale
  public static let majorBluesHexatonic = ScaleType(intervals: [.P1, .M2, .m3, .M3, .P5, .M6], description: "Major Blues Hexatonic")

  /// Minor blues hexatonic scale
  public static let minorBluesHexatonic = ScaleType(intervals: [.P1, .m3, .P4, .d5, .P5, .m7], description: "Minor Blues Hexatonic")

  /// Man gong scale
  public static let manGong = ScaleType(intervals: [.P1, .m3, .P4, .m6, .m7], description: "Man Gong")

  /// Ritsusen scale
  public static let ritsusen = ScaleType(intervals: [.P1, .M2, .P4, .P5, .M6], description: "Ritsusen")

  /// An array of all `ScaleType` values.
  public static var all: [ScaleType] {
    return [
      .major,
      .minor,
      .harmonicMinor,
      .melodicMinor,
      .naturalMinor,
      .ionian,
      .ionianSharp2,
      .ionianAugmented,
      .ionianAugmentedSharp2,
      .aeolian,
      .dorian,
      .dorianSharp4,
      .dorianFlat2,
      .dorianFlat5,
      .mixolydian,
      .mixolydianAugmented,
      .mixolydianFlat2,
      .mixolydianFlat6,
      .phrygian,
      .phrygianMajor,
      .phrygianFlat4,
      .ultraphrygian,
      .lydian,
      .lydianMinor,
      .lydianDiminished,
      .lydianSharp2,
      .lydianSharp6,
      .lydianSharp2Sharp6,
      .lydianFlat3,
      .lydianFlat6,
      .lydianFlat7,
      .lydianAugmented,
      .lydianAugmentedSharp2,
      .lydianAugmentedSharp6,
      .locrian,
      .locrian2,
      .locrian3,
      .locrian6,
      .majorLocrian,
      .locrianDiminished,
      .locrianDiminishedFlatFlat3,
      .superLocrian,
      .superLocrianDiminshedFlatFlat3,
      .chromatic,
      .whole,
      .altered,
      .augmented,
      .dominant7th,
      .halfDiminished,
      .wholeDiminished,
      .leadingWholeTone,
      .diminishedWholeTone,
      .overtone,
      .nineTone,
      .diatonic,
      .enigmatic,
      .doubleHarmonic,
      .auxiliaryDiminished,
      .auxiliaryAugmented,
      .auxiliaryDimBlues,
      .sixToneSymmetrical,
      .neopolitan,
      .neopolitanMajor,
      .neopolitanMinor,
      .prometheus,
      .prometheusNeopolitan,
      .pelog,
      .pentatonicMajor,
      .pentatonicMinor,
      .pentatonicBlues,
      .pentatonicNeutral,
      .majorBluesHexatonic,
      .minorBluesHexatonic,
      .jazzMelodicMinor,
      .spanishGypsy,
      .eightToneSpanish,
      .hungarianMajor,
      .hungarianMinor,
      .romanianMinor,
      .flamenco,
      .gypsy,
      .majorBebop,
      .minorBebop,
      .bebopDominant,
      .chinese,
      .oriental,
      .hirajoshi,
      .ichikosucho,
      .kumoi,
      .yo,
      .iwato,
      .mongolian,
      .hindu,
      .byzantine,
      .arabian,
      .persian,
      .mohammedan,
      .maqam,
      .algerian,
      .balinese,
      .purviTheta,
      .todiTheta,
      .tritone,
      .insen,
      .istrian,
      .pfluke,
      .ukrainianDorian,
      .hawaiian,
      .manGong,
      .ritsusen
    ]
  }
}
