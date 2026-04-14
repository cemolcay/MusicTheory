//
//  Interval.swift
//  MusicTheory
//
//  Created by Cem Olcay on 22.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - Interval

/// Defines the interval between two pitches.
///
/// Intervals are constructed from `quality` and `degree` only.
/// `semitones` is always **computed** from those two fields, so it is impossible
/// to create an interval with inconsistent quality/degree/semitone values.
///
/// Equality and hashing are structural (quality + degree), so `M3 ≠ d4` even
/// though both span 4 semitones. Use `isEnharmonic(with:)` for semitone comparison.
public struct Interval: Codable, Hashable, Comparable, CustomStringConvertible, Sendable {

    // MARK: Quality

    /// The quality of the interval.
    public enum Quality: Int, Codable, Hashable, CaseIterable, CustomStringConvertible, Sendable {
        case doublyDiminished = -3
        case diminished       = -2
        case minor            = -1
        case perfect          =  0
        case major            =  1
        case augmented        =  2
        case doublyAugmented  =  3

        // MARK: CustomStringConvertible

        /// Short notation (e.g. "M", "P", "d").
        public var notation: String {
            switch self {
            case .doublyDiminished: return "dd"
            case .diminished:       return "d"
            case .minor:            return "m"
            case .perfect:          return "P"
            case .major:            return "M"
            case .augmented:        return "A"
            case .doublyAugmented:  return "AA"
            }
        }

        public var description: String {
            switch self {
            case .doublyDiminished: return "Doubly Diminished"
            case .diminished:       return "Diminished"
            case .minor:            return "Minor"
            case .perfect:          return "Perfect"
            case .major:            return "Major"
            case .augmented:        return "Augmented"
            case .doublyAugmented:  return "Doubly Augmented"
            }
        }
    }

    // MARK: Stored properties

    /// The quality of the interval.
    public let quality: Quality

    /// The degree of the interval (1-based: 1 = unison, 2 = second … 8 = octave, 9 = ninth …).
    public let degree: Int

    // MARK: Computed semitones

    /// Natural (white-key) semitone offsets from unison for degrees 1–7.
    private static let naturalSemitones: [Int] = [0, 2, 4, 5, 7, 9, 11]

    /// Semitone count computed from quality and degree. Never stored independently.
    public var semitones: Int {
        let octaves = (degree - 1) / 7
        let simpleDegree = ((degree - 1) % 7) + 1  // 1–7
        let natural = Interval.naturalSemitones[simpleDegree - 1] + octaves * 12

        // For perfect-degree intervals the quality offset is relative to "perfect".
        // For imperfect degrees the quality offset is relative to "major".
        let isPerfectDegree = Interval.isPerfect(degree: simpleDegree)
        let qualityOffset: Int
        if isPerfectDegree {
            // dd=-2, d=-1, P=0, A=+1, AA=+2
            switch quality {
            case .doublyDiminished: qualityOffset = -2
            case .diminished:       qualityOffset = -1
            case .perfect:          qualityOffset =  0
            case .augmented:        qualityOffset =  1
            case .doublyAugmented:  qualityOffset =  2
            case .minor, .major:    qualityOffset =  0  // validated away; fallback
            }
        } else {
            // dd=-3, d=-2, m=-1, M=0, A=+1, AA=+2
            switch quality {
            case .doublyDiminished: qualityOffset = -3
            case .diminished:       qualityOffset = -2
            case .minor:            qualityOffset = -1
            case .major:            qualityOffset =  0
            case .augmented:        qualityOffset =  1
            case .doublyAugmented:  qualityOffset =  2
            case .perfect:          qualityOffset =  0  // validated away; fallback
            }
        }
        return natural + qualityOffset
    }

    // MARK: Validation helpers

    /// Returns true for degrees whose natural form is a perfect interval (1, 4, 5 and their octave equivalents).
    private static func isPerfect(degree: Int) -> Bool {
        let simple = ((degree - 1) % 7) + 1
        return simple == 1 || simple == 4 || simple == 5
    }

    /// Returns true if `quality` is valid for the given `degree`.
    private static func isValid(quality: Quality, degree: Int) -> Bool {
        if isPerfect(degree: degree) {
            switch quality {
            case .doublyDiminished, .diminished, .perfect, .augmented, .doublyAugmented:
                return true
            case .minor, .major:
                return false
            }
        } else {
            switch quality {
            case .doublyDiminished, .diminished, .minor, .major, .augmented, .doublyAugmented:
                return true
            case .perfect:
                return false
            }
        }
    }

    // MARK: Initializers

    /// Creates an interval from quality and degree.
    /// Returns `nil` if the quality is not valid for the degree
    /// (e.g., `.major` on a perfect degree like a 5th).
    public init?(quality: Quality, degree: Int) {
        guard degree >= 1, Interval.isValid(quality: quality, degree: degree) else { return nil }
        self.quality = quality
        self.degree = degree
    }

    /// Creates an interval from semitone count and degree.
    /// The quality is inferred automatically. Returns `nil` if the
    /// semitone count does not correspond to any valid quality for that degree.
    public init?(semitones: Int, degree: Int) {
        guard degree >= 1 else { return nil }
        let octaves = (degree - 1) / 7
        let simpleDegree = ((degree - 1) % 7) + 1
        let natural = Interval.naturalSemitones[simpleDegree - 1] + octaves * 12
        let offset = semitones - natural

        let isPerfectDegree = Interval.isPerfect(degree: simpleDegree)
        let q: Quality?
        if isPerfectDegree {
            switch offset {
            case -2: q = .doublyDiminished
            case -1: q = .diminished
            case  0: q = .perfect
            case  1: q = .augmented
            case  2: q = .doublyAugmented
            default: q = nil
            }
        } else {
            switch offset {
            case -3: q = .doublyDiminished
            case -2: q = .diminished
            case -1: q = .minor
            case  0: q = .major
            case  1: q = .augmented
            case  2: q = .doublyAugmented
            default: q = nil
            }
        }
        guard let resolvedQuality = q else { return nil }
        self.quality = resolvedQuality
        self.degree = degree
    }

    /// Internal unchecked initializer used only for predefined constants.
    internal init(unchecked quality: Quality, degree: Int) {
        self.quality = quality
        self.degree = degree
    }

    // MARK: Derived properties

    /// Whether this is a compound interval (spans more than one octave).
    public var isCompound: Bool { degree > 8 }

    /// The simple interval equivalent (reduces compound intervals to within one octave).
    /// Unison stays as unison.
    public var simple: Interval {
        if degree <= 8 { return self }
        let simpleDegree = ((degree - 1) % 7) + 1
        return Interval(unchecked: quality, degree: simpleDegree)
    }

    /// The inversion of this interval within a single octave.
    /// Inversions satisfy: interval.semitones + interval.inverted.semitones == 12.
    /// Perfect stays perfect; major ↔ minor; diminished ↔ augmented.
    public var inverted: Interval {
        let simpleDegree = ((degree - 1) % 7) + 1
        let invertedDegree = simpleDegree == 1 ? 1 : 9 - simpleDegree
        let invertedQuality: Quality
        switch quality {
        case .doublyDiminished: invertedQuality = .doublyAugmented
        case .diminished:       invertedQuality = .augmented
        case .minor:            invertedQuality = .major
        case .perfect:          invertedQuality = .perfect
        case .major:            invertedQuality = .minor
        case .augmented:        invertedQuality = .diminished
        case .doublyAugmented:  invertedQuality = .doublyDiminished
        }
        return Interval(unchecked: invertedQuality, degree: invertedDegree)
    }

    /// True if two intervals span the same number of semitones (enharmonic equivalence).
    public func isEnharmonic(with other: Interval) -> Bool {
        return semitones == other.semitones
    }

    // MARK: Comparable

    public static func < (lhs: Interval, rhs: Interval) -> Bool {
        if lhs.semitones != rhs.semitones { return lhs.semitones < rhs.semitones }
        return lhs.degree < rhs.degree
    }

    // MARK: CustomStringConvertible

    /// Short notation: e.g. "M3", "P5", "d7".
    public var notation: String { "\(quality.notation)\(degree)" }

    public var description: String {
        var formattedDegree = "\(degree)"
        if #available(macOS 10.11, iOS 9.0, tvOS 9.0, watchOS 2.0, *) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .ordinal
            formattedDegree = formatter.string(from: NSNumber(integerLiteral: degree)) ?? formattedDegree
        }
        return "\(quality) \(formattedDegree)"
    }

    // MARK: - Predefined constants
    //
    // All values use the internal unchecked initializer since quality/degree
    // combinations have been manually verified.

    // Perfect intervals
    /// Unison (P1, 0 semitones).
    public static let P1  = Interval(unchecked: .perfect, degree: 1)
    /// Perfect fourth (P4, 5 semitones).
    public static let P4  = Interval(unchecked: .perfect, degree: 4)
    /// Perfect fifth (P5, 7 semitones).
    public static let P5  = Interval(unchecked: .perfect, degree: 5)
    /// Perfect octave (P8, 12 semitones).
    public static let P8  = Interval(unchecked: .perfect, degree: 8)
    /// Perfect eleventh (P11, 17 semitones).
    public static let P11 = Interval(unchecked: .perfect, degree: 11)
    /// Perfect twelfth (P12, 19 semitones).
    public static let P12 = Interval(unchecked: .perfect, degree: 12)
    /// Perfect fifteenth / double octave (P15, 24 semitones).
    public static let P15 = Interval(unchecked: .perfect, degree: 15)

    // Minor intervals
    /// Minor second (m2, 1 semitone).
    public static let m2  = Interval(unchecked: .minor, degree: 2)
    /// Minor third (m3, 3 semitones).
    public static let m3  = Interval(unchecked: .minor, degree: 3)
    /// Minor sixth (m6, 8 semitones).
    public static let m6  = Interval(unchecked: .minor, degree: 6)
    /// Minor seventh (m7, 10 semitones).
    public static let m7  = Interval(unchecked: .minor, degree: 7)
    /// Minor ninth (m9, 13 semitones).
    public static let m9  = Interval(unchecked: .minor, degree: 9)
    /// Minor tenth (m10, 15 semitones).
    public static let m10 = Interval(unchecked: .minor, degree: 10)
    /// Minor thirteenth (m13, 20 semitones).
    public static let m13 = Interval(unchecked: .minor, degree: 13)
    /// Minor fourteenth (m14, 22 semitones).
    public static let m14 = Interval(unchecked: .minor, degree: 14)

    // Major intervals
    /// Major second (M2, 2 semitones).
    public static let M2  = Interval(unchecked: .major, degree: 2)
    /// Major third (M3, 4 semitones).
    public static let M3  = Interval(unchecked: .major, degree: 3)
    /// Major sixth (M6, 9 semitones).
    public static let M6  = Interval(unchecked: .major, degree: 6)
    /// Major seventh (M7, 11 semitones).
    public static let M7  = Interval(unchecked: .major, degree: 7)
    /// Major ninth (M9, 14 semitones).
    public static let M9  = Interval(unchecked: .major, degree: 9)
    /// Major tenth (M10, 16 semitones).
    public static let M10 = Interval(unchecked: .major, degree: 10)
    /// Major thirteenth (M13, 21 semitones).
    public static let M13 = Interval(unchecked: .major, degree: 13)
    /// Major fourteenth (M14, 23 semitones).
    public static let M14 = Interval(unchecked: .major, degree: 14)

    // Diminished intervals
    /// Diminished unison (d1, -1 semitone).
    public static let d1  = Interval(unchecked: .diminished, degree: 1)
    /// Diminished second (d2, 0 semitones).
    public static let d2  = Interval(unchecked: .diminished, degree: 2)
    /// Diminished third (d3, 2 semitones).
    public static let d3  = Interval(unchecked: .diminished, degree: 3)
    /// Diminished fourth (d4, 4 semitones).
    public static let d4  = Interval(unchecked: .diminished, degree: 4)
    /// Diminished fifth / tritone (d5, 6 semitones).
    public static let d5  = Interval(unchecked: .diminished, degree: 5)
    /// Diminished sixth (d6, 7 semitones).
    public static let d6  = Interval(unchecked: .diminished, degree: 6)
    /// Diminished seventh (d7, 9 semitones).
    public static let d7  = Interval(unchecked: .diminished, degree: 7)
    /// Diminished octave (d8, 11 semitones).
    public static let d8  = Interval(unchecked: .diminished, degree: 8)
    /// Diminished ninth (d9, 12 semitones).
    public static let d9  = Interval(unchecked: .diminished, degree: 9)
    /// Diminished tenth (d10, 14 semitones).
    public static let d10 = Interval(unchecked: .diminished, degree: 10)
    /// Diminished eleventh (d11, 16 semitones).
    public static let d11 = Interval(unchecked: .diminished, degree: 11)
    /// Diminished twelfth (d12, 18 semitones).
    public static let d12 = Interval(unchecked: .diminished, degree: 12)
    /// Diminished thirteenth (d13, 19 semitones).
    public static let d13 = Interval(unchecked: .diminished, degree: 13)
    /// Diminished fourteenth (d14, 21 semitones).
    public static let d14 = Interval(unchecked: .diminished, degree: 14)
    /// Diminished fifteenth (d15, 23 semitones).
    public static let d15 = Interval(unchecked: .diminished, degree: 15)

    // Augmented intervals
    /// Augmented unison (A1, 1 semitone).
    public static let A1  = Interval(unchecked: .augmented, degree: 1)
    /// Augmented second (A2, 3 semitones).
    public static let A2  = Interval(unchecked: .augmented, degree: 2)
    /// Augmented third (A3, 5 semitones).
    public static let A3  = Interval(unchecked: .augmented, degree: 3)
    /// Augmented fourth / tritone (A4, 6 semitones).
    public static let A4  = Interval(unchecked: .augmented, degree: 4)
    /// Augmented fifth (A5, 8 semitones).
    public static let A5  = Interval(unchecked: .augmented, degree: 5)
    /// Augmented sixth (A6, 10 semitones).
    public static let A6  = Interval(unchecked: .augmented, degree: 6)
    /// Augmented seventh (A7, 12 semitones).
    public static let A7  = Interval(unchecked: .augmented, degree: 7)
    /// Augmented octave (A8, 13 semitones).
    public static let A8  = Interval(unchecked: .augmented, degree: 8)
    /// Augmented ninth (A9, 15 semitones).
    public static let A9  = Interval(unchecked: .augmented, degree: 9)
    /// Augmented tenth (A10, 17 semitones).
    public static let A10 = Interval(unchecked: .augmented, degree: 10)
    /// Augmented eleventh (A11, 18 semitones).
    public static let A11 = Interval(unchecked: .augmented, degree: 11)
    /// Augmented twelfth (A12, 20 semitones).
    public static let A12 = Interval(unchecked: .augmented, degree: 12)
    /// Augmented thirteenth (A13, 22 semitones).
    public static let A13 = Interval(unchecked: .augmented, degree: 13)
    /// Augmented fourteenth (A14, 24 semitones).
    public static let A14 = Interval(unchecked: .augmented, degree: 14)
    /// Augmented fifteenth (A15, 25 semitones).
    public static let A15 = Interval(unchecked: .augmented, degree: 15)

    /// All predefined intervals. Filter by quality, degree, or semitones as needed.
    public static let all: [Interval] = [
        .P1, .P4, .P5, .P8, .P11, .P12, .P15,
        .m2, .m3, .m6, .m7, .m9, .m10, .m13, .m14,
        .M2, .M3, .M6, .M7, .M9, .M10, .M13, .M14,
        .d1, .d2, .d3, .d4, .d5, .d6, .d7, .d8, .d9, .d10, .d11, .d12, .d13, .d14, .d15,
        .A1, .A2, .A3, .A4, .A5, .A6, .A7, .A8, .A9, .A10, .A11, .A12, .A13, .A14, .A15,
    ]
}
