//
//  ChordType.swift
//  MusicTheory
//
//  Created by Cem Olcay on 2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - ChordRecognitionError

/// Describes why a set of intervals could not be parsed into a known chord type.
public enum ChordRecognitionError: Error, CustomStringConvertible, Sendable {
    /// Neither a third nor a suspension was found in the intervals.
    case noThirdOrSuspension
    /// Two components would conflict (e.g., both major and minor third).
    case conflictingComponents(ChordComponent, ChordComponent)
    /// An interval could not be mapped to any `ChordComponent`.
    case unrecognizedInterval(Interval)

    public var description: String {
        switch self {
        case .noThirdOrSuspension:
            return "No third or suspension found"
        case let .conflictingComponents(a, b):
            return "Conflicting components: \(a) and \(b)"
        case let .unrecognizedInterval(i):
            return "Unrecognized interval: \(i.notation)"
        }
    }
}

// MARK: - ChordType

/// Defines the quality of a chord as an ordered set of `ChordComponent`s.
///
/// **Equality and hashing use the component set**, so chord types with the
/// same components are always equal regardless of how they were constructed.
///
/// Use `ChordType.from(intervals:)` to build a chord type from raw intervals —
/// it returns a `Result` so you know exactly why recognition failed.
public struct ChordType: Hashable, Codable, CustomStringConvertible, Sendable {

    // MARK: Stored property

    /// The set of chord components (excluding the implicit root / P1).
    public let components: Set<ChordComponent>

    // MARK: Initializers

    /// Creates a chord type from a set of components.
    /// Returns `nil` if neither a third nor a suspension is present.
    public init?(components: Set<ChordComponent>) {
        let hasThird = components.contains(.minorThird) || components.contains(.majorThird)
        let hasSus   = components.contains(.majorSecond) || components.contains(.perfectFourth)
        guard hasThird || hasSus else { return nil }
        self.components = components
    }

    /// Internal unchecked initializer for predefined chord types.
    internal init(unchecked components: Set<ChordComponent>) {
        self.components = components
    }

    // MARK: Build from intervals

    /// Attempts to build a `ChordType` from an array of intervals (relative to root).
    ///
    /// Skips P1 (root). Returns `.failure` with a descriptive error if recognition fails.
    public static func from(intervals: [Interval]) -> Result<ChordType, ChordRecognitionError> {
        var components = Set<ChordComponent>()

        for interval in intervals {
            // Skip root
            if interval == .P1 { continue }

            guard let component = ChordComponent(interval: interval) else {
                return .failure(.unrecognizedInterval(interval))
            }

            // Check for conflicts (two components at the same functional role)
            if let conflict = components.first(where: { existing in
                isConflicting(existing, component)
            }) {
                return .failure(.conflictingComponents(conflict, component))
            }

            components.insert(component)
        }

        let hasThird = components.contains(.minorThird) || components.contains(.majorThird)
        let hasSus   = components.contains(.majorSecond) || components.contains(.perfectFourth)

        guard hasThird || hasSus else {
            return .failure(.noThirdOrSuspension)
        }

        return .success(ChordType(unchecked: components))
    }

    private static func isConflicting(_ a: ChordComponent, _ b: ChordComponent) -> Bool {
        // Two components conflict if they represent the same scale degree with different qualities
        return a.interval.degree == b.interval.degree && a != b
    }

    // MARK: Computed properties

    /// Intervals from the root (includes P1), sorted ascending.
    public var intervals: [Interval] {
        let comps = components.sorted()
        return [.P1] + comps.map(\.interval)
    }

    // MARK: Classification

    public var isTriad: Bool {
        let seventh = components.filter { [.diminishedSeventh, .minorSeventh, .majorSeventh].contains($0) }
        let extensions = components.filter { $0.rawValue >= ChordComponent.flatNinth.rawValue }
        return seventh.isEmpty && extensions.isEmpty
    }

    public var isSeventh: Bool {
        let seventh = components.filter { [.diminishedSeventh, .minorSeventh, .majorSeventh].contains($0) }
        let extensions = components.filter { $0.rawValue >= ChordComponent.flatNinth.rawValue }
        return !seventh.isEmpty && extensions.isEmpty
    }

    public var isExtended: Bool {
        return components.contains(where: { $0.rawValue >= ChordComponent.flatNinth.rawValue })
    }

    public var isSuspended: Bool {
        return !components.contains(.minorThird) && !components.contains(.majorThird)
            && (components.contains(.majorSecond) || components.contains(.perfectFourth))
    }

    public var isAddChord: Bool {
        // Has extensions but no seventh
        let hasExtension = components.contains(where: { $0.rawValue >= ChordComponent.flatNinth.rawValue })
        let hasSeventh = components.contains(.minorSeventh) || components.contains(.majorSeventh) || components.contains(.diminishedSeventh)
        return hasExtension && !hasSeventh
    }

    // MARK: Symbol & name

    /// Standard chord symbol (e.g. "m7", "dim", "Maj7#11", "sus4").
    public var symbol: String {
        let hasMinThird = components.contains(.minorThird)
        let hasSus2 = components.contains(.majorSecond)
        let hasSus4 = components.contains(.perfectFourth)
        let hasDimFifth = components.contains(.diminishedFifth)
        let hasAugFifth = components.contains(.augmentedFifth)
        let hasSixth = components.contains(.majorSixth)
        let hasDimSeventh = components.contains(.diminishedSeventh)
        let hasMinSeventh = components.contains(.minorSeventh)
        let hasMajSeventh = components.contains(.majorSeventh)
        let extensionComps = components.filter { $0.rawValue >= ChordComponent.flatNinth.rawValue }.sorted()
        let highestNaturalExtension: Int? =
            components.contains(.thirteenth) ? 13 :
            components.contains(.eleventh) ? 11 :
            components.contains(.ninth) ? 9 : nil

        let impliedExtensions: Set<ChordComponent>
        switch highestNaturalExtension {
        case 13: impliedExtensions = [.ninth, .eleventh, .thirteenth]
        case 11: impliedExtensions = [.ninth, .eleventh]
        case 9:  impliedExtensions = [.ninth]
        default: impliedExtensions = []
        }
        let alteredExtensions = extensionComps.filter { !impliedExtensions.contains($0) }

        if hasMinThird && hasDimFifth && hasDimSeventh && extensionComps.isEmpty {
            return "dim7"
        }

        var prefix: String
        if hasSus2 {
            prefix = "sus2"
        } else if hasSus4 {
            prefix = "sus4"
        } else if hasMinThird && hasDimFifth && hasMinSeventh {
            prefix = "ø"
        } else if hasMinThird && hasDimFifth {
            prefix = "dim"
        } else if hasMinThird {
            prefix = "m"
        } else if hasAugFifth {
            prefix = "+"
        } else if hasDimFifth {
            prefix = "b5"
        } else {
            prefix = ""
        }

        var suffix = ""
        if let highestNaturalExtension {
            if hasMajSeventh {
                suffix = "Maj\(highestNaturalExtension)"
            } else if hasMinSeventh {
                suffix = "\(highestNaturalExtension)"
            } else {
                suffix = "add\(highestNaturalExtension)"
            }
        } else if hasMajSeventh {
            suffix = "Maj7"
        } else if hasMinSeventh {
            suffix = "7"
        } else if hasDimSeventh {
            return "dim7"
        } else if hasSixth {
            suffix = "6"
        }

        let tensionSuffix = alteredExtensions.isEmpty ? "" : "(\(alteredExtensions.map(\.symbol).joined()))"
        let result = prefix + suffix + tensionSuffix
        return result.isEmpty ? "M" : result
    }

    /// Full descriptive name (e.g. "Minor Seventh", "Diminished").
    public var fullName: String {
        let hasMajThird = components.contains(.majorThird)
        let hasMinThird = components.contains(.minorThird)
        let hasDimFifth = components.contains(.diminishedFifth)
        let hasAugFifth = components.contains(.augmentedFifth)
        let hasDimSeventh = components.contains(.diminishedSeventh)
        let hasMinSeventh = components.contains(.minorSeventh)
        let hasMajSeventh = components.contains(.majorSeventh)
        let hasSus2 = components.contains(.majorSecond)
        let hasSus4 = components.contains(.perfectFourth)
        let hasSixth = components.contains(.majorSixth)
        let extensionComps = components.filter { $0.rawValue >= ChordComponent.flatNinth.rawValue }.sorted()
        let highestNaturalExtension: Int? =
            components.contains(.thirteenth) ? 13 :
            components.contains(.eleventh) ? 11 :
            components.contains(.ninth) ? 9 : nil

        let impliedExtensions: Set<ChordComponent>
        switch highestNaturalExtension {
        case 13: impliedExtensions = [.ninth, .eleventh, .thirteenth]
        case 11: impliedExtensions = [.ninth, .eleventh]
        case 9:  impliedExtensions = [.ninth]
        default: impliedExtensions = []
        }
        let alteredExtensions = extensionComps.filter { !impliedExtensions.contains($0) }

        if hasMinThird && hasDimFifth && hasDimSeventh && extensionComps.isEmpty {
            return "Diminished 7th"
        }
        if hasMinThird && hasDimFifth && hasMinSeventh && extensionComps.isEmpty {
            return "Half-Diminished 7th"
        }

        let baseName: String
        if hasSus2 {
            baseName = "Suspended 2nd"
        } else if hasSus4 {
            baseName = "Suspended 4th"
        } else if hasMinThird && hasDimFifth && hasMinSeventh {
            baseName = "Half-Diminished"
        } else if hasMinThird && hasDimFifth {
            baseName = "Diminished"
        } else if hasMinThird {
            baseName = "Minor"
        } else if hasAugFifth {
            baseName = "Augmented"
        } else if hasMajThird || hasSixth || hasMajSeventh || hasMinSeventh || highestNaturalExtension != nil {
            baseName = "Major"
        } else {
            baseName = "Major"
        }

        let coreName: String
        if let highestNaturalExtension {
            if hasMajSeventh {
                coreName = baseName == "Minor" ? "Minor Major \(highestNaturalExtension)th" : "\(baseName) \(highestNaturalExtension)th"
            } else if hasMinSeventh {
                switch baseName {
                case "Minor": coreName = "Minor \(highestNaturalExtension)th"
                case "Half-Diminished": coreName = "Half-Diminished \(highestNaturalExtension)th"
                case "Augmented": coreName = "Augmented \(highestNaturalExtension)th"
                case "Suspended 2nd", "Suspended 4th": coreName = "\(baseName) \(highestNaturalExtension)th"
                default: coreName = "Dominant \(highestNaturalExtension)th"
                }
            } else {
                coreName = "\(baseName) Add \(highestNaturalExtension)"
            }
        } else if hasMajSeventh {
            coreName = baseName == "Minor" ? "Minor Major 7th" : "\(baseName) Major 7th"
        } else if hasMinSeventh {
            switch baseName {
            case "Minor": coreName = "Minor 7th"
            case "Half-Diminished": coreName = "Half-Diminished 7th"
            case "Augmented": coreName = "Augmented 7th"
            case "Suspended 2nd", "Suspended 4th": coreName = "\(baseName) 7th"
            default: coreName = "Dominant 7th"
            }
        } else if hasSixth {
            coreName = "\(baseName) 6th"
        } else {
            coreName = baseName
        }

        if alteredExtensions.isEmpty {
            return coreName
        }
        return "\(coreName) (\(alteredExtensions.map(\.description).joined(separator: ", ")))"
    }

    // MARK: CustomStringConvertible

    public var description: String { fullName }

    // MARK: Predefined chord types

    /// Major triad.
    public static let major        = ChordType(unchecked: [.majorThird, .perfectFifth])
    /// Minor triad.
    public static let minor        = ChordType(unchecked: [.minorThird, .perfectFifth])
    /// Diminished triad.
    public static let diminished   = ChordType(unchecked: [.minorThird, .diminishedFifth])
    /// Augmented triad.
    public static let augmented    = ChordType(unchecked: [.majorThird, .augmentedFifth])
    /// Suspended 2nd triad.
    public static let sus2         = ChordType(unchecked: [.majorSecond, .perfectFifth])
    /// Suspended 4th triad.
    public static let sus4         = ChordType(unchecked: [.perfectFourth, .perfectFifth])
    /// Major 6th chord.
    public static let major6       = ChordType(unchecked: [.majorThird, .perfectFifth, .majorSixth])
    /// Minor 6th chord.
    public static let minor6       = ChordType(unchecked: [.minorThird, .perfectFifth, .majorSixth])
    /// Dominant 7th chord.
    public static let dominant7    = ChordType(unchecked: [.majorThird, .perfectFifth, .minorSeventh])
    /// Major 7th chord.
    public static let major7       = ChordType(unchecked: [.majorThird, .perfectFifth, .majorSeventh])
    /// Minor 7th chord.
    public static let minor7       = ChordType(unchecked: [.minorThird, .perfectFifth, .minorSeventh])
    /// Minor-Major 7th chord.
    public static let minorMajor7  = ChordType(unchecked: [.minorThird, .perfectFifth, .majorSeventh])
    /// Diminished 7th chord.
    public static let diminished7  = ChordType(unchecked: [.minorThird, .diminishedFifth, .diminishedSeventh])
    /// Half-diminished 7th (ø7) chord.
    public static let halfDiminished7 = ChordType(unchecked: [.minorThird, .diminishedFifth, .minorSeventh])
    /// Augmented 7th chord.
    public static let augmented7   = ChordType(unchecked: [.majorThird, .augmentedFifth, .minorSeventh])
    /// Augmented Major 7th chord.
    public static let augmentedMajor7 = ChordType(unchecked: [.majorThird, .augmentedFifth, .majorSeventh])
    /// Dominant 9th chord.
    public static let dominant9    = ChordType(unchecked: [.majorThird, .perfectFifth, .minorSeventh, .ninth])
    /// Major 9th chord.
    public static let major9       = ChordType(unchecked: [.majorThird, .perfectFifth, .majorSeventh, .ninth])
    /// Minor 9th chord.
    public static let minor9       = ChordType(unchecked: [.minorThird, .perfectFifth, .minorSeventh, .ninth])
    /// Dominant 11th chord.
    public static let dominant11   = ChordType(unchecked: [.majorThird, .perfectFifth, .minorSeventh, .ninth, .eleventh])
    /// Dominant 13th chord.
    public static let dominant13   = ChordType(unchecked: [.majorThird, .perfectFifth, .minorSeventh, .ninth, .eleventh, .thirteenth])
    /// Major 13th chord.
    public static let major13      = ChordType(unchecked: [.majorThird, .perfectFifth, .majorSeventh, .ninth, .eleventh, .thirteenth])
    /// Minor 11th chord.
    public static let minor11      = ChordType(unchecked: [.minorThird, .perfectFifth, .minorSeventh, .ninth, .eleventh])
    /// Minor 13th chord.
    public static let minor13      = ChordType(unchecked: [.minorThird, .perfectFifth, .minorSeventh, .ninth, .eleventh, .thirteenth])
}
