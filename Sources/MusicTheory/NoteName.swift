//
//  NoteName.swift
//  MusicTheory
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - SpellingPreference

/// Controls how a pitch class is converted to a spelled note name when only semitones are known.
public enum SpellingPreference: Sendable {
    /// Prefer sharps (C# over Db).
    case sharps
    /// Prefer flats (Db over C#).
    case flats
    /// Prefer the natural spelling with the fewest accidentals.
    case natural
}

// MARK: - NoteName

/// A spelled note name: a letter (A–G) combined with an accidental.
///
/// `NoteName` uses **structural equality** — C# and Db are *not* equal.
/// Use `isEnharmonic(with:)` to compare by sound (pitch class).
public struct NoteName: Hashable, Codable, Comparable,
    ExpressibleByStringLiteral, CustomStringConvertible, Sendable {

    // MARK: Stored properties

    /// The letter component (A–G).
    public let letter: LetterName

    /// The accidental modification.
    public let accidental: Accidental

    // MARK: Initializers

    public init(letter: LetterName, accidental: Accidental = .natural) {
        self.letter = letter
        self.accidental = accidental
    }

    // MARK: Computed properties

    /// Semitone offset from C within one octave (0 = C natural, 11 = B natural), mod 12.
    public var pitchClass: Int {
        let raw = (letter.semitonesFromC + accidental.semitones) % 12
        return raw < 0 ? raw + 12 : raw
    }

    // MARK: Enharmonic helpers

    /// Returns true if both note names sound the same (same pitch class).
    public func isEnharmonic(with other: NoteName) -> Bool {
        return pitchClass == other.pitchClass
    }

    /// The enharmonic spelling with the fewest accidentals.
    /// Prefers naturals, then flats (e.g., Db over C#).
    public var simplestEnharmonic: NoteName {
        let pc = pitchClass
        // Natural wins if one exists
        for letter in LetterName.allCases {
            let candidate = NoteName(letter: letter, accidental: .natural)
            if candidate.pitchClass == pc { return candidate }
        }
        // Otherwise prefer the flat spelling from the chromatic flat scale
        return NoteName.chromaticWithFlats.first(where: { $0.pitchClass == pc }) ?? self
    }

    /// All common enharmonic spellings (accidentals in range −2…+2).
    public var enharmonicEquivalents: [NoteName] {
        let pc = pitchClass
        var result: [NoteName] = []
        for letter in LetterName.allCases {
            for acc in stride(from: -2, through: 2, by: 1) {
                let candidate = NoteName(letter: letter, accidental: Accidental(semitones: acc))
                if candidate.pitchClass == pc {
                    result.append(candidate)
                }
            }
        }
        return result
    }

    // MARK: Chromatic scales

    /// The 12 chromatic note names using sharp spellings.
    public static let chromaticWithSharps: [NoteName] = [
        NoteName(letter: .c, accidental: .natural),
        NoteName(letter: .c, accidental: .sharp),
        NoteName(letter: .d, accidental: .natural),
        NoteName(letter: .d, accidental: .sharp),
        NoteName(letter: .e, accidental: .natural),
        NoteName(letter: .f, accidental: .natural),
        NoteName(letter: .f, accidental: .sharp),
        NoteName(letter: .g, accidental: .natural),
        NoteName(letter: .g, accidental: .sharp),
        NoteName(letter: .a, accidental: .natural),
        NoteName(letter: .a, accidental: .sharp),
        NoteName(letter: .b, accidental: .natural),
    ]

    /// The 12 chromatic note names using flat spellings.
    public static let chromaticWithFlats: [NoteName] = [
        NoteName(letter: .c, accidental: .natural),
        NoteName(letter: .d, accidental: .flat),
        NoteName(letter: .d, accidental: .natural),
        NoteName(letter: .e, accidental: .flat),
        NoteName(letter: .e, accidental: .natural),
        NoteName(letter: .f, accidental: .natural),
        NoteName(letter: .g, accidental: .flat),
        NoteName(letter: .g, accidental: .natural),
        NoteName(letter: .a, accidental: .flat),
        NoteName(letter: .a, accidental: .natural),
        NoteName(letter: .b, accidental: .flat),
        NoteName(letter: .b, accidental: .natural),
    ]

    /// Returns the 12 chromatic note names using the given spelling preference.
    public static func chromatic(preferring spelling: SpellingPreference) -> [NoteName] {
        switch spelling {
        case .sharps:  return chromaticWithSharps
        case .flats:   return chromaticWithFlats
        case .natural: return chromaticWithFlats  // flats are generally the "natural" default
        }
    }

    // MARK: Convenience constants

    public static let c  = NoteName(letter: .c, accidental: .natural)
    public static let cs = NoteName(letter: .c, accidental: .sharp)
    public static let db = NoteName(letter: .d, accidental: .flat)
    public static let d  = NoteName(letter: .d, accidental: .natural)
    public static let ds = NoteName(letter: .d, accidental: .sharp)
    public static let eb = NoteName(letter: .e, accidental: .flat)
    public static let e  = NoteName(letter: .e, accidental: .natural)
    public static let f  = NoteName(letter: .f, accidental: .natural)
    public static let fs = NoteName(letter: .f, accidental: .sharp)
    public static let gb = NoteName(letter: .g, accidental: .flat)
    public static let g  = NoteName(letter: .g, accidental: .natural)
    public static let gs = NoteName(letter: .g, accidental: .sharp)
    public static let ab = NoteName(letter: .a, accidental: .flat)
    public static let a  = NoteName(letter: .a, accidental: .natural)
    public static let as_ = NoteName(letter: .a, accidental: .sharp)  // `as` is a keyword
    public static let bb = NoteName(letter: .b, accidental: .flat)
    public static let b  = NoteName(letter: .b, accidental: .natural)

    // MARK: Comparable

    /// Orders by pitch class first, then by letter name (for deterministic sorting).
    public static func < (lhs: NoteName, rhs: NoteName) -> Bool {
        if lhs.pitchClass != rhs.pitchClass { return lhs.pitchClass < rhs.pitchClass }
        return lhs.letter < rhs.letter
    }

    // MARK: ExpressibleByStringLiteral

    public typealias StringLiteralType = String

    /// Creates a note name from a string like `"C#"`, `"Bb"`, `"F♯"`, `"A♭"`.
    public init(stringLiteral value: String) {
        var letter: LetterName = .c
        var accidental: Accidental = .natural
        let pattern = "([A-Ga-g])([#♯♭b]*)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        if let regex,
           let match = regex.firstMatch(in: value, options: [], range: NSRange(0..<value.count)),
           let letterRange = Range(match.range(at: 1), in: value),
           let accRange = Range(match.range(at: 2), in: value),
           match.numberOfRanges == 3 {
            letter = LetterName(stringLiteral: String(value[letterRange]))
            accidental = Accidental(stringLiteral: String(value[accRange]))
        }
        self.letter = letter
        self.accidental = accidental
    }

    // MARK: CustomStringConvertible

    public var description: String {
        return "\(letter)\(accidental)"
    }
}
