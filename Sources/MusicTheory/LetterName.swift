//
//  LetterName.swift
//  MusicTheory
//
//  Created by Cem Olcay on 2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

/// The seven natural note letters of the Western diatonic scale.
/// Raw values are sequential 0–6 (not semitone offsets) so that
/// array-index arithmetic is straightforward and unambiguous.
public enum LetterName: Int, CaseIterable, Comparable, Codable,
    ExpressibleByStringLiteral, CustomStringConvertible, Sendable {

    case c = 0
    case d = 1
    case e = 2
    case f = 3
    case g = 4
    case a = 5
    case b = 6

    // MARK: Semitone mapping

    /// Semitone offset from C within a single octave (C=0, D=2, E=4, F=5, G=7, A=9, B=11).
    public var semitonesFromC: Int {
        switch self {
        case .c: return 0
        case .d: return 2
        case .e: return 4
        case .f: return 5
        case .g: return 7
        case .a: return 9
        case .b: return 11
        }
    }

    // MARK: Diatonic navigation

    /// Returns the letter name `steps` diatonic steps away (wraps around).
    /// Positive values go up (C→D→E…), negative values go down (C→B→A…).
    public func advanced(by steps: Int) -> LetterName {
        let count = LetterName.allCases.count   // 7
        let normalized = ((rawValue + steps) % count + count) % count
        return LetterName(rawValue: normalized)!
    }

    /// Returns the ascending diatonic distance from `self` to `other` (0–6).
    /// C→C = 0, C→D = 1, C→B = 6, D→C = 6 (wraps up).
    public func diatonicDistance(to other: LetterName) -> Int {
        let count = LetterName.allCases.count   // 7
        return ((other.rawValue - rawValue) % count + count) % count
    }

    // MARK: Comparable

    public static func < (lhs: LetterName, rhs: LetterName) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    // MARK: ExpressibleByStringLiteral

    public typealias StringLiteralType = String

    public init(stringLiteral value: String) {
        switch value.lowercased() {
        case "a": self = .a
        case "b": self = .b
        case "c": self = .c
        case "d": self = .d
        case "e": self = .e
        case "f": self = .f
        case "g": self = .g
        default:  self = .c
        }
    }

    // MARK: CustomStringConvertible

    public var description: String {
        switch self {
        case .c: return "C"
        case .d: return "D"
        case .e: return "E"
        case .f: return "F"
        case .g: return "G"
        case .a: return "A"
        case .b: return "B"
        }
    }
}
