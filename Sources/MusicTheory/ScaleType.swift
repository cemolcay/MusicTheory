//
//  ScaleType.swift
//  MusicTheory
//
//  Created by Cem Olcay on 1/16/22.
//  Copyright © 2022 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - ScaleType

/// A lightweight named interval preset for building scales.
///
/// `ScaleType` is intentionally small: it stores a display name and the
/// intervals used to build a scale. Equality compares intervals only, so
/// different names for the same interval pattern are treated as equal.
public struct ScaleType: Codable, Hashable, CustomStringConvertible, Sendable {

    /// Intervals from the root, in ascending order.
    public let intervals: [Interval]

    /// Display name of the scale type.
    public let description: String

    public init(intervals: [Interval], description: String) {
        self.intervals = intervals
        self.description = description
    }

    public static func == (lhs: ScaleType, rhs: ScaleType) -> Bool {
        return lhs.intervals == rhs.intervals
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(intervals)
    }
}

// MARK: - Built-In Scale Types

extension ScaleType {

    // MARK: Core

    /// Major / Ionian scale.
    public static let major = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .M6, .M7], description: "Major")
    /// Dorian mode.
    public static let dorian = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .M6, .m7], description: "Dorian")
    /// Phrygian mode.
    public static let phrygian = ScaleType(intervals: [.P1, .m2, .m3, .P4, .P5, .m6, .m7], description: "Phrygian")
    /// Lydian mode.
    public static let lydian = ScaleType(intervals: [.P1, .M2, .M3, .A4, .P5, .M6, .M7], description: "Lydian")
    /// Mixolydian mode.
    public static let mixolydian = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .M6, .m7], description: "Mixolydian")
    /// Natural minor / Aeolian mode.
    public static let minor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .m6, .m7], description: "Minor")
    /// Locrian mode.
    public static let locrian = ScaleType(intervals: [.P1, .m2, .m3, .P4, .d5, .m6, .m7], description: "Locrian")

    /// Harmonic minor scale.
    public static let harmonicMinor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .m6, .M7], description: "Harmonic Minor")
    /// Melodic minor scale.
    public static let melodicMinor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .M6, .M7], description: "Melodic Minor")
    /// Harmonic major scale.
    public static let harmonicMajor = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .m6, .M7], description: "Harmonic Major")

    /// Lydian dominant / Lydian b7.
    public static let lydianDominant = ScaleType(intervals: [.P1, .M2, .M3, .A4, .P5, .M6, .m7], description: "Lydian Dominant")
    /// Altered / Super Locrian scale.
    public static let altered = ScaleType(intervals: [.P1, .m2, .m3, .d4, .d5, .m6, .m7], description: "Altered")
    /// Phrygian dominant / Phrygian major scale.
    public static let phrygianDominant = ScaleType(intervals: [.P1, .m2, .M3, .P4, .P5, .m6, .m7], description: "Phrygian Dominant")

    /// Major pentatonic scale.
    public static let pentatonicMajor = ScaleType(intervals: [.P1, .M2, .M3, .P5, .M6], description: "Pentatonic Major")
    /// Minor pentatonic scale.
    public static let pentatonicMinor = ScaleType(intervals: [.P1, .m3, .P4, .P5, .m7], description: "Pentatonic Minor")
    /// Blues pentatonic scale.
    public static let pentatonicBlues = ScaleType(intervals: [.P1, .m3, .P4, .A4, .P5, .m7], description: "Pentatonic Blues")

    /// Whole-tone scale.
    public static let wholeTone = ScaleType(intervals: [.P1, .M2, .M3, .A4, .m6, .m7], description: "Whole Tone")
    /// Whole-half diminished scale.
    public static let diminished = ScaleType(intervals: [.P1, .M2, .m3, .P4, .d5, .m6, .M6, .M7], description: "Diminished")
    /// Chromatic scale.
    public static let chromatic = ScaleType(intervals: [.P1, .m2, .M2, .m3, .M3, .P4, .d5, .P5, .m6, .M6, .m7, .M7], description: "Chromatic")

    // MARK: Japanese / East-Asian

    /// Hirajoshi scale, a Japanese pentatonic scale built on a minor third and minor sixth.
    public static let hirajoshi = ScaleType(intervals: [.P1, .M2, .m3, .P5, .m6], description: "Hirajoshi")
    /// Sakura (In) scale, the Japanese miyako-bushi pentatonic scale.
    public static let sakura = ScaleType(intervals: [.P1, .m2, .P4, .P5, .m6], description: "Sakura")
    /// Insen scale, a Japanese pentatonic scale used in shakuhachi and koto music.
    public static let insen = ScaleType(intervals: [.P1, .m2, .P4, .P5, .m7], description: "Insen")
    /// Iwato scale, a Japanese pentatonic scale with a tritone above the root.
    public static let iwato = ScaleType(intervals: [.P1, .m2, .P4, .d5, .m7], description: "Iwato")
    /// Kumoi scale, a Japanese pentatonic scale close to the minor pentatonic.
    public static let kumoi = ScaleType(intervals: [.P1, .M2, .m3, .P5, .M6], description: "Kumoi")
    /// Yo scale, a Japanese pentatonic scale close to the major pentatonic.
    /// Older editions of this library defined `yo` as a rotation equal to `pentatonicMinor`;
    /// this is the standard anhemitonic Yo scale.
    public static let yo = ScaleType(intervals: [.P1, .M2, .P4, .P5, .M6], description: "Yo")
    /// Ryukyu scale, a Japanese/Okinawan pentatonic scale with no half-step below the root.
    public static let ryukyu = ScaleType(intervals: [.P1, .M3, .P4, .P5, .M7], description: "Ryukyu")
    /// Ichikosucho scale, a Japanese gagaku scale close to the major scale with an added #4.
    public static let ichikosucho = ScaleType(intervals: [.P1, .M2, .M3, .P4, .A4, .P5, .M6, .M7], description: "Ichikosucho")
    /// Taishikicho scale, a Japanese gagaku scale close to Mixolydian with an added #4.
    public static let taishikicho = ScaleType(intervals: [.P1, .M2, .M3, .P4, .A4, .P5, .M6, .m7, .M7], description: "Taishikicho")

    /// Convenience alias for `kumoi`.
    public static var akebono: ScaleType { .kumoi }
    /// Convenience alias for `sakura` (Hon Kumoi Joshi).
    public static var honKumoiJoshi: ScaleType { .sakura }
    /// Convenience alias for `insen` (Kokin Joshi).
    public static var kokinJoshi: ScaleType { .insen }
    /// Convenience alias for `yo` (Ritsu scale).
    public static var ritsu: ScaleType { .yo }
    /// Convenience alias for `ryukyu` (Okinawan scale).
    public static var okinawan: ScaleType { .ryukyu }

    // MARK: World / Exotic

    /// Pelog scale, an Indonesian gamelan scale.
    public static let pelog = ScaleType(intervals: [.P1, .m2, .m3, .P5, .m6], description: "Pelog")
    /// Chinese scale, a pentatonic scale with a raised fourth.
    public static let chinese = ScaleType(intervals: [.P1, .M3, .A4, .P5, .M7], description: "Chinese")
    /// Double harmonic scale, a scale with two augmented seconds.
    public static let doubleHarmonic = ScaleType(intervals: [.P1, .m2, .M3, .P4, .P5, .m6, .M7], description: "Double Harmonic")
    /// Hungarian minor scale, harmonic minor with a raised fourth.
    public static let hungarianMinor = ScaleType(intervals: [.P1, .M2, .m3, .A4, .P5, .m6, .M7], description: "Hungarian Minor")
    /// Hungarian major scale, built from alternating whole and half steps with a raised second and fourth.
    public static let hungarianMajor = ScaleType(intervals: [.P1, .A2, .M3, .A4, .P5, .M6, .m7], description: "Hungarian Major")
    /// Neapolitan major scale, major scale with a lowered second and third.
    public static let neapolitanMajor = ScaleType(intervals: [.P1, .m2, .m3, .P4, .P5, .M6, .M7], description: "Neapolitan Major")
    /// Neapolitan minor scale, harmonic minor with a lowered second.
    public static let neapolitanMinor = ScaleType(intervals: [.P1, .m2, .m3, .P4, .P5, .m6, .M7], description: "Neapolitan Minor")
    /// Persian scale, a scale with two augmented seconds and a lowered fifth.
    public static let persian = ScaleType(intervals: [.P1, .m2, .M3, .P4, .d5, .m6, .M7], description: "Persian")
    /// Enigmatic scale, an unusual scale mixing augmented and half-step motion.
    public static let enigmatic = ScaleType(intervals: [.P1, .m2, .M3, .A4, .A5, .A6, .M7], description: "Enigmatic")
    /// Ukrainian Dorian scale, Dorian with a raised fourth (also known as Romanian minor).
    public static let ukrainianDorian = ScaleType(intervals: [.P1, .M2, .m3, .A4, .P5, .M6, .m7], description: "Ukrainian Dorian")
    /// Istrian scale, a six-note folk scale from the Istrian peninsula.
    public static let istrian = ScaleType(intervals: [.P1, .m2, .m3, .d4, .d5, .P5], description: "Istrian")

    /// Convenience alias for `pelog`.
    public static var balinese: ScaleType { .pelog }
    /// Convenience alias for `doubleHarmonic` (Byzantine scale).
    public static var byzantine: ScaleType { .doubleHarmonic }
    /// Convenience alias for `doubleHarmonic` (Flamenco scale).
    public static var flamenco: ScaleType { .doubleHarmonic }
    /// Convenience alias for `hungarianMinor` (Gypsy minor scale).
    public static var gypsyMinor: ScaleType { .hungarianMinor }
    /// Convenience alias for `hungarianMinor` (Algerian scale).
    public static var algerian: ScaleType { .hungarianMinor }
    /// Convenience alias for `ukrainianDorian` (Romanian minor scale).
    public static var romanianMinor: ScaleType { .ukrainianDorian }
    /// Convenience alias for `ukrainianDorian` (Dorian #4).
    public static var dorianSharp4: ScaleType { .ukrainianDorian }

    // MARK: Jazz / Symmetric

    /// Half-whole diminished scale (octatonic, starting with a half step).
    public static let halfWholeDiminished = ScaleType(intervals: [.P1, .m2, .m3, .M3, .A4, .P5, .M6, .m7], description: "Half-Whole Diminished")
    /// Augmented scale, built from alternating minor thirds and half steps.
    public static let augmented = ScaleType(intervals: [.P1, .m3, .M3, .P5, .m6, .M7], description: "Augmented")
    /// Bebop dominant scale, Mixolydian with an added passing major seventh.
    public static let bebopDominant = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .M6, .m7, .M7], description: "Bebop Dominant")
    /// Bebop major scale, major scale with an added passing minor sixth.
    public static let bebopMajor = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .m6, .M6, .M7], description: "Bebop Major")
    /// Bebop Dorian scale, Dorian with an added passing major third.
    public static let bebopDorian = ScaleType(intervals: [.P1, .M2, .m3, .M3, .P4, .P5, .M6, .m7], description: "Bebop Dorian")
    /// Bebop melodic minor scale, melodic minor with an added passing minor sixth.
    public static let bebopMelodicMinor = ScaleType(intervals: [.P1, .M2, .m3, .P4, .P5, .m6, .M6, .M7], description: "Bebop Melodic Minor")
    /// Major blues scale, major pentatonic with an added minor third blue note.
    public static let bluesMajor = ScaleType(intervals: [.P1, .M2, .m3, .M3, .P5, .M6], description: "Blues Major")
    /// Pentatonic neutral scale, a pentatonic scale with no major or minor third.
    public static let pentatonicNeutral = ScaleType(intervals: [.P1, .M2, .P4, .P5, .m7], description: "Pentatonic Neutral")
    /// Prometheus scale, a whole-tone-derived scale used by Scriabin.
    public static let prometheus = ScaleType(intervals: [.P1, .M2, .M3, .A4, .M6, .m7], description: "Prometheus")
    /// Tritone scale, built from two major thirds a tritone apart.
    public static let tritoneScale = ScaleType(intervals: [.P1, .m2, .M3, .d5, .P5, .m7], description: "Tritone")
    /// Six-tone symmetrical scale, alternating half steps and minor thirds.
    public static let sixToneSymmetrical = ScaleType(intervals: [.P1, .m2, .M3, .P4, .m6, .M6], description: "Six Tone Symmetrical")

    /// Convenience alias for `halfWholeDiminished` (Dominant diminished scale).
    public static var dominantDiminished: ScaleType { .halfWholeDiminished }
    /// Convenience alias for `diminished`, clarifying it is the whole-half octatonic scale.
    public static var wholeHalfDiminished: ScaleType { .diminished }
    /// Convenience alias for `pentatonicNeutral` (Egyptian scale).
    public static var egyptian: ScaleType { .pentatonicNeutral }

    // MARK: Melodic Minor Modes

    /// Dorian b2 scale, the second mode of melodic minor.
    public static let dorianFlat2 = ScaleType(intervals: [.P1, .m2, .m3, .P4, .P5, .M6, .m7], description: "Dorian b2")
    /// Lydian augmented scale, the third mode of melodic minor.
    public static let lydianAugmented = ScaleType(intervals: [.P1, .M2, .M3, .A4, .A5, .M6, .M7], description: "Lydian Augmented")
    /// Mixolydian b6 scale, the fifth mode of melodic minor.
    public static let mixolydianFlat6 = ScaleType(intervals: [.P1, .M2, .M3, .P4, .P5, .m6, .m7], description: "Mixolydian b6")
    /// Locrian natural 2 scale, the sixth mode of melodic minor (half-diminished scale).
    public static let locrianNatural2 = ScaleType(intervals: [.P1, .M2, .m3, .P4, .d5, .m6, .m7], description: "Locrian Natural 2")

    /// Convenience alias for `mixolydianFlat6` (Hindu scale).
    public static var hindu: ScaleType { .mixolydianFlat6 }
    /// Convenience alias for `locrianNatural2` (Half-diminished scale).
    public static var halfDiminishedScale: ScaleType { .locrianNatural2 }

    // MARK: Harmonic Minor Modes

    /// Locrian natural 6 scale, the second mode of harmonic minor.
    public static let locrianNatural6 = ScaleType(intervals: [.P1, .m2, .m3, .P4, .d5, .M6, .m7], description: "Locrian Natural 6")
    /// Ionian augmented scale, the third mode of harmonic minor.
    public static let ionianAugmented = ScaleType(intervals: [.P1, .M2, .M3, .P4, .A5, .M6, .M7], description: "Ionian Augmented")
    /// Lydian #2 scale, the fourth mode of harmonic minor.
    public static let lydianSharp2 = ScaleType(intervals: [.P1, .A2, .M3, .A4, .P5, .M6, .M7], description: "Lydian #2")
    /// Altered diminished scale, the seventh mode of harmonic minor.
    public static let alteredDiminished = ScaleType(intervals: [.P1, .m2, .m3, .d4, .d5, .m6, .d7], description: "Altered Diminished")

    // MARK: Harmonic Major Modes

    /// Dorian b5 scale, the second mode of harmonic major.
    public static let dorianFlat5 = ScaleType(intervals: [.P1, .M2, .m3, .P4, .d5, .M6, .m7], description: "Dorian b5")
    /// Lydian b3 scale, the fourth mode of harmonic major.
    public static let lydianFlat3 = ScaleType(intervals: [.P1, .M2, .m3, .A4, .P5, .M6, .M7], description: "Lydian b3")
    /// Mixolydian b2 scale, the fifth mode of harmonic major.
    public static let mixolydianFlat2 = ScaleType(intervals: [.P1, .m2, .M3, .P4, .P5, .M6, .m7], description: "Mixolydian b2")

    // MARK: Convenience aliases

    public static var ionian: ScaleType { .major }
    public static var aeolian: ScaleType { .minor }
    public static var naturalMinor: ScaleType { .minor }
    public static var lydianFlat7: ScaleType { .lydianDominant }
    public static var phrygianMajor: ScaleType { .phrygianDominant }
    public static var whole: ScaleType { .wholeTone }
    public static var wholeDiminished: ScaleType { .diminished }

    /// All predefined scale types, grouped in declaration order.
    public static var allScales: [ScaleType] {
        [
            // Core
            major, minor, dorian, phrygian, lydian, mixolydian, locrian,
            harmonicMinor, melodicMinor, harmonicMajor, lydianDominant, altered, phrygianDominant,
            pentatonicMajor, pentatonicMinor, pentatonicBlues, wholeTone, diminished, chromatic,
            // Japanese / East-Asian
            hirajoshi, sakura, insen, iwato, kumoi, yo, ryukyu, ichikosucho, taishikicho,
            // World / Exotic
            pelog, chinese, doubleHarmonic, hungarianMinor, hungarianMajor, neapolitanMajor,
            neapolitanMinor, persian, enigmatic, ukrainianDorian, istrian,
            // Jazz / Symmetric
            halfWholeDiminished, augmented, bebopDominant, bebopMajor, bebopDorian,
            bebopMelodicMinor, bluesMajor, pentatonicNeutral, prometheus, tritoneScale,
            sixToneSymmetrical,
            // Melodic Minor Modes
            dorianFlat2, lydianAugmented, mixolydianFlat6, locrianNatural2,
            // Harmonic Minor Modes
            locrianNatural6, ionianAugmented, lydianSharp2, alteredDiminished,
            // Harmonic Major Modes
            dorianFlat5, lydianFlat3, mixolydianFlat2,
        ]
    }
}
