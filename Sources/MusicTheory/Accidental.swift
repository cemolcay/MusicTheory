//
//  Accidental.swift
//  MusicTheory
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - Operators

/// Returns a new accidental by adding two accidentals.
public func + (lhs: Accidental, rhs: Accidental) -> Accidental {
    return Accidental(semitones: lhs.semitones + rhs.semitones)
}

/// Returns a new accidental by subtracting two accidentals.
public func - (lhs: Accidental, rhs: Accidental) -> Accidental {
    return Accidental(semitones: lhs.semitones - rhs.semitones)
}

/// Returns a new accidental by adding an integer offset.
public func + (lhs: Accidental, rhs: Int) -> Accidental {
    return Accidental(semitones: lhs.semitones + rhs)
}

/// Returns a new accidental by subtracting an integer offset.
public func - (lhs: Accidental, rhs: Int) -> Accidental {
    return Accidental(semitones: lhs.semitones - rhs)
}

// MARK: - Accidental

/// Represents the accidental modification applied to a note.
/// A positive `semitones` value means sharps, negative means flats, zero means natural.
/// There is exactly one representation for every accidental — no degenerate states.
public struct Accidental: Codable, Hashable, Comparable, RawRepresentable,
    ExpressibleByIntegerLiteral, ExpressibleByStringLiteral, CustomStringConvertible, Sendable {

    // MARK: RawRepresentable

    public typealias RawValue = Int

    /// Semitone offset. Positive = sharps, negative = flats, zero = natural.
    public let semitones: Int

    public var rawValue: Int { semitones }

    public init(semitones: Int) {
        self.semitones = semitones
    }

    public init?(rawValue: Int) {
        self.semitones = rawValue
    }

    // MARK: Predefined constants

    /// Lowers pitch by two semitones (𝄫).
    public static let doubleFlat  = Accidental(semitones: -2)
    /// Lowers pitch by one semitone (♭).
    public static let flat        = Accidental(semitones: -1)
    /// No modification (♮).
    public static let natural     = Accidental(semitones: 0)
    /// Raises pitch by one semitone (♯).
    public static let sharp       = Accidental(semitones: 1)
    /// Raises pitch by two semitones (𝄪).
    public static let doubleSharp = Accidental(semitones: 2)

    // MARK: ExpressibleByIntegerLiteral

    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: Int) {
        self.semitones = value
    }

    // MARK: ExpressibleByStringLiteral

    public typealias StringLiteralType = String

    /// Parses a string of sharp/flat symbols into an accidental.
    /// Recognises `#`, `♯` as sharps and `b`, `♭` as flats.
    public init(stringLiteral value: String) {
        var sum = 0
        for ch in value {
            switch ch {
            case "#", "♯": sum += 1
            case "b", "♭": sum -= 1
            default: break
            }
        }
        self.semitones = sum
    }

    // MARK: Comparable

    public static func < (lhs: Accidental, rhs: Accidental) -> Bool {
        return lhs.semitones < rhs.semitones
    }

    // MARK: CustomStringConvertible

    /// Returns the symbolic notation for the accidental.
    /// Natural returns an empty string (use `notation` for the ♮ symbol).
    public var description: String {
        switch semitones {
        case 0:  return ""
        case -2: return "𝄫"
        case -1: return "♭"
        case  1: return "♯"
        case  2: return "𝄪"
        default:
            if semitones > 0 {
                return String(repeating: "♯", count: semitones)
            } else {
                return String(repeating: "♭", count: -semitones)
            }
        }
    }

    /// Returns the full notation symbol, including ♮ for natural.
    public var notation: String {
        return semitones == 0 ? "♮" : description
    }
}
