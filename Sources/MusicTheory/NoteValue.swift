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
public struct NoteValueType: Codable, Hashable, CustomStringConvertible {
    /// Note value in beats.
    public var beats: Double
    /// Name of the note value.
    public var description: String
    
    /// Sixteen bar notes.
    public static let sixteenBars = NoteValueType(beats: 16.0, description: "16 Bars")
    /// Eigth bar notes.
    public static let eigthBars = NoteValueType(beats: 8.0, description: "8 Bars")
    /// Four bar notes.
    public static let fourBars = NoteValueType(beats: 4.0, description: "4 Bars")
    /// Two bar notes.
    public static let twoBars = NoteValueType(beats: 2.0, description: "2 Bars")
    /// One bar note.
    public static let oneBar = NoteValueType(beats: 1.0, description: "1 Bar")
    /// Two whole notes.
    public static let doubleWhole = NoteValueType(beats: 2.0 / 1.0, description: "2/1")
    /// Whole note.
    public static let whole = NoteValueType(beats: 1.0 / 1.0, description: "1/1")
    /// Half note.
    public static let half = NoteValueType(beats: 1.0 / 2.0, description: "1/2")
    /// Quarter note.
    public static let quarter = NoteValueType(beats: 1.0 / 4.0, description: "1/4")
    /// Eighth note.
    public static let eighth = NoteValueType(beats: 1.0 / 8.0, description: "1/8")
    /// Sixteenth note.
    public static let sixteenth = NoteValueType(beats: 1.0 / 16.0, description: "1/16")
    /// Thirtysecond note.
    public static let thirtysecond = NoteValueType(beats: 1.0 / 32.0, description: "1/32")
    /// Sixtyfourth note.
    public static let sixtyfourth = NoteValueType(beats: 1.0 / 64.0, description: "1/64")
    
    public static let all: [NoteValueType] = [
        .sixteenBars, .eigthBars, .fourBars, .twoBars, .oneBar,
        .half, .quarter, .eighth, .sixteenth, .thirtysecond, .sixtyfourth
    ]
}

// MARK: - NoteModifier

/// Defines the length of a `NoteValue`
public enum NoteModifier: Double, Codable, CaseIterable, CustomStringConvertible {
    /// No additional length.
    case `default` = 1
    /// Adds half of its own value.
    case dotted = 1.5
    /// Three notes of the same value.
    case triplet = 0.6667
    /// Five of the indicated note value total the duration normally occupied by four.
    case quintuplet = 0.8
    
    /// The string representation of the modifier.
    public var description: String {
        switch self {
        case .default: return ""
        case .dotted: return "D"
        case .triplet: return "T"
        case .quintuplet: return "Q"
        }
    }
}

// MARK: - NoteValue

/// Calculates how many notes of a single `NoteValueType` is equivalent to a given `NoteValue`.
///
/// - Parameters:
///   - noteValue: The note value to be measured.
///   - noteValueType: The note value type to measure the length of the note value.
/// - Returns: Returns how many notes of a single `NoteValueType` is equivalent to a given `NoteValue`.
public func / (noteValue: NoteValue, noteValueType: NoteValueType) -> Double {
    return (noteValue.type.beats * noteValue.modifier.rawValue) / noteValueType.beats
}

/// Defines the duration of a note beatwise.
public struct NoteValue: Codable, CustomStringConvertible {
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
    
    /// Returns the string representation of the note value.
    public var description: String {
        return "\(type)\(modifier)"
    }
}
