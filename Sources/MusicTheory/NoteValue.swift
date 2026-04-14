//
//  NoteValue.swift
//  MusicTheory iOS
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - NoteValueType

/// Defines the types of note values.
public struct NoteValueType: Codable, Hashable, CustomStringConvertible, Sendable {
    /// The note value's duration relative to a whole note (1.0 = whole, 0.25 = quarter, etc.).
    public var rate: Double
    /// Name of the note value.
    public var description: String

    /// Creates a note value type.
    ///
    /// - Parameters:
    ///   - rate: The rate of the note value as a fraction of a whole note.
    ///   - description: The name of the note value.
    public init(rate: Double, description: String) {
        self.rate = rate
        self.description = description
    }

    /// Sixteen bar notes.
    public static let sixteenBars  = NoteValueType(rate: 16.0,        description: "16 Bars")
    /// Eight bar notes.
    public static let eightBars    = NoteValueType(rate: 8.0,         description: "8 Bars")
    /// Four bar notes.
    public static let fourBars     = NoteValueType(rate: 4.0,         description: "4 Bars")
    /// Two bar notes.
    public static let twoBars      = NoteValueType(rate: 2.0,         description: "2 Bars")
    /// One bar note.
    public static let oneBar       = NoteValueType(rate: 1.0,         description: "1 Bar")
    /// Double whole note (breve).
    public static let doubleWhole  = NoteValueType(rate: 2.0,         description: "2/1")
    /// Whole note.
    public static let whole        = NoteValueType(rate: 1.0,         description: "1/1")
    /// Half note.
    public static let half         = NoteValueType(rate: 1.0 / 2.0,   description: "1/2")
    /// Quarter note.
    public static let quarter      = NoteValueType(rate: 1.0 / 4.0,   description: "1/4")
    /// Eighth note.
    public static let eighth       = NoteValueType(rate: 1.0 / 8.0,   description: "1/8")
    /// Sixteenth note.
    public static let sixteenth    = NoteValueType(rate: 1.0 / 16.0,  description: "1/16")
    /// Thirty-second note.
    public static let thirtysecond = NoteValueType(rate: 1.0 / 32.0,  description: "1/32")
    /// Sixty-fourth note.
    public static let sixtyfourth  = NoteValueType(rate: 1.0 / 64.0,  description: "1/64")

    /// All predefined note value types in descending order of duration.
    public static let all: [NoteValueType] = [
        .sixteenBars, .eightBars, .fourBars, .twoBars, .oneBar,
        .doubleWhole, .whole, .half, .quarter, .eighth,
        .sixteenth, .thirtysecond, .sixtyfourth,
    ]
}

// MARK: - NoteModifier

/// Modifies the duration of a `NoteValue`.
public enum NoteModifier: Codable, CaseIterable, Hashable, CustomStringConvertible, Sendable {
    /// No modification; duration is 1× the base note value.
    case `default`
    /// Dotted: duration is 1.5× the base note value.
    case dotted
    /// Double-dotted: duration is 1.75× the base note value.
    case doubleDotted
    /// Triplet: three notes in the space of two (duration = 2/3).
    case triplet
    /// Quintuplet: five notes in the space of four (duration = 4/5).
    case quintuplet
    /// Septuplet: seven notes in the space of four (duration = 4/7).
    case septuplet

    /// The duration multiplier applied to the base note value.
    public var multiplier: Double {
        switch self {
        case .default:     return 1.0
        case .dotted:      return 3.0 / 2.0
        case .doubleDotted: return 7.0 / 4.0
        case .triplet:     return 2.0 / 3.0
        case .quintuplet:  return 4.0 / 5.0
        case .septuplet:   return 4.0 / 7.0
        }
    }

    public var description: String {
        switch self {
        case .default:     return ""
        case .dotted:      return "D"
        case .doubleDotted: return "DD"
        case .triplet:     return "T"
        case .quintuplet:  return "Q"
        case .septuplet:   return "S"
        }
    }
}

// MARK: - NoteValue

/// Defines the duration of a note, combining a `NoteValueType` with a `NoteModifier`.
public struct NoteValue: Codable, Hashable, Equatable, CustomStringConvertible, Sendable {
    /// Base note value type.
    public var type: NoteValueType
    /// Duration modifier.
    public var modifier: NoteModifier

    /// Initialises the NoteValue with its type and optional modifier.
    ///
    /// - Parameters:
    ///   - type: Type of note value that represents note duration.
    ///   - modifier: Modifier of note value. Defaults `.default`.
    public init(type: NoteValueType, modifier: NoteModifier = .default) {
        self.type = type
        self.modifier = modifier
    }

    /// Duration in beats (relative to a whole note = 1.0).
    public var rate: Double {
        return type.rate * modifier.multiplier
    }

    public var description: String {
        return "\(type)\(modifier)"
    }
}

// MARK: - Operators

/// How many times `noteValueType` fits into `noteValue`.
public func / (noteValue: NoteValue, noteValueType: NoteValueType) -> Double {
    return noteValue.rate / noteValueType.rate
}
