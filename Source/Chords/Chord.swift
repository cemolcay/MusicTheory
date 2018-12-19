//
//  Chord.swift
//  MusicTheory
//
//  Created by Cem Olcay on 22.10.2017.
//  Copyright © 2017 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - ChordPart

/// Protocol that defines a printable chord part.
public protocol ChordDescription: CustomStringConvertible, Codable {
  /// Notation of chord.
  var notation: String { get }
}

/// Protocol that defines a chord part.
public protocol ChordPart: ChordDescription {
  /// Interval between the root.
  var interval: Interval { get }
  /// Initilize chord part with interval.
  init?(interval: Interval)
}

/// Defines third part of the chord. Second note after the root.
public enum ChordThirdType: Int, ChordPart {
  /// Defines major chord. 4 halfsteps between root.
  case major
  /// Defines minor chord. 3 halfsteps between root.
  case minor

  /// Initilize chord part with interval.
  public init?(interval: Interval) {
    switch interval {
    case ChordThirdType.major.interval:
      self = .major
    case ChordThirdType.minor.interval:
      self = .minor
    default:
      return nil
    }
  }

  /// Interval between root.
  public var interval: Interval {
    switch self {
    case .major:
      return .M3
    case .minor:
      return .m3
    }
  }

  /// Notation of chord part.
  public var notation: String {
    switch self {
    case .major: return ""
    case .minor: return "m"
    }
  }

  /// Description of chord part.
  public var description: String {
    switch self {
    case .major: return "Major"
    case .minor: return "Minor"
    }
  }

  /// All values of `ChordThirdType`.
  public static var all: [ChordThirdType] {
    return [.major, .minor]
  }
}

/// Defines fifth part of the chord. Third note after root note.
public enum ChordFifthType: Int, ChordPart {
  /// Perfect fifth interval between root.
  case perfect
  /// Half step down of perfect fifth.
  case diminished
  /// Half step up of perfect fifth.
  case augmented

  /// Initilize chord part with interval.
  public init?(interval: Interval) {
    switch interval {
    case ChordFifthType.perfect.interval:
      self = .perfect
    case ChordFifthType.diminished.interval:
      self = .diminished
    case ChordFifthType.augmented.interval:
      self = .augmented
    default:
      return nil
    }
  }

  /// Interval between root.
  public var interval: Interval {
    switch self {
    case .perfect:
      return .P5
    case .diminished:
      return .d5
    case .augmented:
      return .A5
    }
  }

  /// Notation of chord part.
  public var notation: String {
    switch self {
    case .perfect: return ""
    case .augmented: return "♯5"
    case .diminished: return "♭5"
    }
  }

  /// Description of chord part.
  public var description: String {
    switch self {
    case .perfect: return ""
    case .augmented: return "Augmented"
    case .diminished: return "Diminished"
    }
  }

  /// All values of `ChordFifthType`.
  public static var all: [ChordFifthType] {
    return [.perfect, .diminished, .augmented]
  }
}

/// Defiens sixth chords. If you add the sixth note, you have sixth chord.
public struct ChordSixthType: ChordPart {
  /// Default initilizer.
  public init() {}

  /// Initilize chord part with interval.
  public init?(interval: Interval) {
    switch interval {
    case .M6:
      self.init()
    default:
      return nil
    }
  }

  /// Interval between root.
  public var interval: Interval {
    return .M6
  }

  /// Notation of chord part.
  public var notation: String {
    return "6"
  }

  /// Description of chord part.
  public var description: String {
    return "Sixth"
  }
}

/// Defiens seventh chords. If you add seventh note, you have seventh chord.
public enum ChordSeventhType: Int, ChordPart {
  /// Seventh note of the chord. 11 halfsteps between root.
  case major
  /// Halfstep down of seventh note. 10 halfsteps between root.
  case dominant
  /// Whole step down of seventh note. 9 halfsteps between root.
  case diminished

  /// Initilize chord part with interval.
  public init?(interval: Interval) {
    switch interval {
    case ChordSeventhType.major.interval:
      self = .major
    case ChordSeventhType.dominant.interval:
      self = .dominant
    default:
      return nil
    }
  }

  /// Interval between root.
  public var interval: Interval {
    switch self {
    case .major:
      return .M7
    case .dominant:
      return .m7
    case .diminished:
      return .d7
    }
  }

  /// Notation of chord part.
  public var notation: String {
    switch self {
    case .major: return "maj7"
    case .dominant: return "7"
    case .diminished: return "dim7"
    }
  }

  /// Description of chord part.
  public var description: String {
    switch self {
    case .major: return "Major 7th"
    case .dominant: return "Dominant 7th"
    case .diminished: return "Diminished 7th"
    }
  }

  /// All values of `ChordSeventhType`.
  public static var all: [ChordSeventhType] {
    return [.major, .dominant]
  }
}

public enum ChordEighthType: Int, ChordPart {
  /// A perfect eighth - an octave above root.
  case perfect
  /// Halfstep down an octave above root.
  case diminished
  /// Halfstep above an octave above root.
  case augmented

  /// Initilize chord part with interval.
  public init?(interval: Interval) {
    switch interval {
    case ChordEighthType.perfect.interval:
      self = .perfect
    case ChordEighthType.diminished.interval:
      self = .diminished
    case ChordEighthType.augmented.interval:
      self = .augmented
    default:
      return nil
    }
  }

  /// Interval between root.
  public var interval: Interval {
    switch self {
    case .perfect:
      return .P8
    case .diminished:
      return .d8
    case .augmented:
      return .A8
    }
  }

  /// Notation of chord part.
  public var notation: String {
    switch self {
    case .perfect: return "d8"
    case .diminished: return "8"
    case .augmented: return "A8"
    }
  }

  /// Description of chord part.
  public var description: String {
    switch self {
    case .perfect: return ""
    case .diminished: return "Diminished 8th"
    case .augmented: return "Augmented 8th"
    }
  }

  /// All values of `ChordEighthType`.
  public static var all: [ChordEighthType] {
    return [.perfect, .diminished, .augmented]
  }
}

/// Defines suspended chords.
/// If you play second or fourth note of chord, instead of thirds, than you have suspended chords.
public enum ChordSuspendedType: Int, ChordPart {
  /// Second note of chord instead of third part. 2 halfsteps between root.
  case sus2
  /// Fourth note of chord instead of third part. 5 halfsteps between root.
  case sus4

  /// Initilize chord part with interval
  public init?(interval: Interval) {
    switch interval {
    case ChordSuspendedType.sus2.interval:
      self = .sus2
    case ChordSuspendedType.sus4.interval:
      self = .sus4
    default:
      return nil
    }
  }

  /// Interval between root.
  public var interval: Interval {
    switch self {
    case .sus2:
      return .M2
    case .sus4:
      return .P4
    }
  }

  /// Notation of chord part.
  public var notation: String {
    switch self {
    case .sus2: return "(sus2)"
    case .sus4: return "(sus4)"
    }
  }

  /// Description of chord part.
  public var description: String {
    switch self {
    case .sus2: return "Suspended 2nd"
    case .sus4: return "Suspended 4th"
    }
  }

  /// All values of `ChordSuspendedType`.
  public static var all: [ChordSuspendedType] {
    return [.sus2, .sus4]
  }
}

/// Defines extended chords.
/// If you add one octave up of second, fourth or sixth notes of the chord, you have extended chords.
/// You can combine extended chords more than one in a chord.
public struct ChordExtensionType: ChordPart, Equatable {
  /// Defines type of the extended chords.
  public enum ExtensionType: Int, ChordDescription {
    /// An octave up from the root.
    case octave = 8
    /// 9th chord. Second note of the chord, one octave up from root.
    case ninth = 9
    /// 11th chord. Eleventh note of the chord, one octave up from root.
    case eleventh = 11
    /// 13th chord. Sixth note of the chord, one octave up from root.
    case thirteenth = 13

    /// Interval between root.
    public var interval: Interval {
      switch self {
      case .octave:
        return .P8
      case .ninth:
        return .M9
      case .eleventh:
        return .P11
      case .thirteenth:
        return .M13
      }
    }

    /// Notation of the chord part.
    public var notation: String {
      switch self {
      case .octave:
        return "8"
      case .ninth:
        return "9"
      case .eleventh:
        return "11"
      case .thirteenth:
        return "13"
      }
    }

    /// Description of the chord part.
    public var description: String {
      switch self {
      case .octave:
        return ""
      case .ninth:
        return "9th"
      case .eleventh:
        return "11th"
      case .thirteenth:
        return "13th"
      }
    }

    /// All values of `ExtensionType`.
    public static var all: [ExtensionType] {
      return [.octave, .ninth, .eleventh, .thirteenth]
    }
  }

  /// Type of extended chord.
  public var type: ExtensionType
  /// Accident of extended chord.
  public var accidental: Accidental
  /// If there are no seventh note and only one extended part is this. Defaults false
  internal var isAdded: Bool

  /// Initilizes extended chord.
  ///
  /// - Parameters:
  ///   - type: Type of extended chord.
  ///   - accident: Accident of extended chord. Defaults natural.
  public init(type: ExtensionType, accidental: Accidental = .natural) {
    self.type = type
    self.accidental = accidental
    isAdded = false
  }

  /// Initilize chord part with interval
  public init?(interval: Interval) {
    switch interval.semitones {
    case ExtensionType.ninth.interval + Accidental.natural:
      self = ChordExtensionType(type: .ninth, accidental: .natural)
    case ExtensionType.ninth.interval + Accidental.flat:
      self = ChordExtensionType(type: .ninth, accidental: .flat)
    case ExtensionType.ninth.interval + Accidental.sharp:
      self = ChordExtensionType(type: .ninth, accidental: .sharp)
    case ExtensionType.eleventh.interval + Accidental.natural:
      self = ChordExtensionType(type: .eleventh, accidental: .natural)
    case ExtensionType.eleventh.interval + Accidental.flat:
      self = ChordExtensionType(type: .eleventh, accidental: .flat)
    case ExtensionType.eleventh.interval + Accidental.sharp:
      self = ChordExtensionType(type: .eleventh, accidental: .sharp)
    case ExtensionType.thirteenth.interval + Accidental.natural:
      self = ChordExtensionType(type: .thirteenth, accidental: .natural)
    case ExtensionType.thirteenth.interval + Accidental.flat:
      self = ChordExtensionType(type: .thirteenth, accidental: .flat)
    case ExtensionType.thirteenth.interval + Accidental.sharp:
      self = ChordExtensionType(type: .thirteenth, accidental: .sharp)
    default:
      return nil
    }
  }

  /// Interval between root.
  public var interval: Interval {
    switch (type, accidental) {
    case (.octave, .natural): return .P8
    case (.octave, .flat): return .d8
    case (.octave, .sharp): return .A8

    case (.ninth, .natural): return .M9
    case (.ninth, .flat): return .m9
    case (.ninth, .sharp): return .A9

    case (.eleventh, .natural): return .P11
    case (.eleventh, .flat): return .P11
    case (.eleventh, .sharp): return .A11

    case (.thirteenth, .natural): return .M13
    case (.thirteenth, .flat): return .m13
    case (.thirteenth, .sharp): return .A13

    case (.ninth, _): return .M9
    case (.eleventh, _): return .P11
    case (.thirteenth, _): return .M13
    case (.octave, _): return .P8
    }
  }

  /// Notation of chord part.
  public var notation: String {
    return "\(accidental.notation)\(type.notation)"
  }

  /// Description of chord part.
  public var description: String {
    return "\(isAdded ? "Added " : "")\(accidental.description) \(type.description)"
  }

  /// All values of `ChordExtensionType`
  public static var all: [ChordExtensionType] {
    var all = [ChordExtensionType]()
    for type in ExtensionType.all {
      for accident in [Accidental.natural, Accidental.flat, Accidental.sharp] {
        all.append(ChordExtensionType(type: type, accidental: accident))
      }
    }
    return all
  }

  public static func == (lhs: ChordExtensionType, rhs: ChordExtensionType) -> Bool {
    return lhs.type == rhs.type && lhs.accidental == rhs.accidental
}
}

// MARK: - Chord

/// Defines a chord with a root note and type.
public struct Chord: ChordDescription, Equatable {
  /// Type of the chord.
  public var type: ChordType
  /// Root key of the chord.
  public var key: Key
  /// Inversion index of the chord.
  public private(set) var inversion: Int = 0

  /// Initilizes chord with root note and type.
  ///
  /// - Parameters:
  ///   - key: Root key of the chord.
  ///   - type: Tyoe of the chord.
  public init(type: ChordType, key: Key, inversion: Int = 0) {
    self.type = type
    self.key = key
    self.inversion = inversion
  }

  /// Types of notes in chord.
  public var keys: [Key] {
    return pitches(octave: 1).map({ $0.key })
  }

  /// Checks if the chord can be inverted with the inversion number
  ///
  /// - Parameter inversion: Inversion number
  /// - Returns: Whether the chord has the inversion
  public func hasInversion(_ inversion: Int) -> Bool {
    return inversion >= 0 && inversion < keys.count
  }

  /// Possible inversions of the chord.
  public var inversions: [Chord] {
    return [Int](0 ..< keys.count).map({ Chord(type: type, key: key, inversion: $0) })
  }

  /// Notation of the chord.
  public var notation: String {
    let inversionNotation = inversion > 0 && inversion < keys.count ? "/\(keys[0])" : ""
    return "\(key)\(type.notation)\(inversionNotation)"
  }

  /// Generates notes of the chord for octave.
  ///
  /// - Parameter octave: Octave of the root note for the build chord from.
  /// - Returns: Generates notes of the chord.
  public func pitches(octave: Int) -> [Pitch] {
    var intervals = type.intervals
    for _ in 0 ..< inversion {
      intervals = intervals.shifted
    }

    let root = Pitch(key: key, octave: octave)
    let invertedPitches = intervals.map({ root + $0 })
    return invertedPitches
      .enumerated()
      .map({ index, item in
        index < type.intervals.count - inversion ? item : Pitch(key: item.key, octave: item.octave + 1)
      })
  }

  /// Generates notes of the chord for octave range.
  ///
  /// - Parameter octaves: Octaves of the root note to build chord from.
  /// - Returns: Generates notes of the chord.
  public func pitches(octaves: [Int]) -> [Pitch] {
    return octaves.flatMap({ pitches(octave: $0) }).sorted(by: { $0.rawValue < $1.rawValue })
  }

  /// Returns the roman numeric string for a chord.
  ///
  /// - Parameter scale: The scale that the chord in.
  /// - Returns: Roman numeric string for the chord in a scale.
  public func romanNumeric(for scale: Scale) -> String? {
    guard let chordIndex = scale.keys.firstIndex(of: key)
    else { return nil }

    var roman = ""
    switch chordIndex {
    case 0: roman = "I"
    case 1: roman = "II"
    case 2: roman = "III"
    case 3: roman = "IV"
    case 4: roman = "V"
    case 5: roman = "VI"
    case 6: roman = "VII"
    default: return nil
    }

    // Check if minor
    if type.third == .minor {
      roman = roman.lowercased()
    }
    // Check if sixth
    if type.sixth != nil {
      roman = "\(roman)6"
    }
    // Check if augmented
    if type.fifth == .augmented {
      roman = "\(roman)+"
    }
    // Check if diminished
    if type.fifth == .diminished {
      roman = "\(roman)°"
    }
    // Check if sevent
    if type.seventh != nil, (type.extensions == nil || type.extensions?.isEmpty == true) {
      roman = "\(roman)7"
    }
    // Check if extended
    if let extensions = type.extensions,
      let last = extensions.sorted(by: { $0.type.rawValue < $1.type.rawValue }).last {
      roman = "\(roman)\(last.type.rawValue)"
    }
    // Check if inverted
    if inversion > 0 {
      roman = "\(roman)/\(inversion)"
    }

    return roman
  }

  /// Invert the chord by a specified inversion number
  ///
  /// - Parameter inversion: Inversion number
  /// - Returns: Chord with new inversion number
  public func chord(withInversion inversion: Int) -> Chord {
    assert(hasInversion(inversion), "Chord does not have the specified inversion")
    return Chord(type: type, key: key, inversion: inversion)
  }

  // MARK: CustomStringConvertible

  /// Description of the chord.
  public var description: String {
    let inversionNotation = inversion > 0 ? " \(inversion). Inversion" : ""
    return "\(key) \(type)\(inversionNotation)"
  }

  /// Checks the equability between two chords based on whether they are composed of the same notes
  /// disregarding inversions. For example, a C/G chord ~= C chord is true.
  ///
  /// - Parameters:
  ///   - left: Left handside of the equation.
  ///   - right: Right handside of the equation.
  /// - Returns: Returns Bool value of equation of two given chords.
  public static func ~= (left: Chord, right: Chord) -> Bool {
    return left.type.intervals == right.type.intervals
  }

  /// Checks the equability between two chords based on whether they are composed of the same notes.
  /// For example, an C/G chord == Gsus4(no5)(add6) chord is true, but C/G != C chord.
  ///
  /// - Parameters:
  ///   - left: Left handside of the equation.
  ///   - right: Right handside of the equation.
  /// - Returns: Returns Bool value of equation of two given chords.
  public static func == (left: Chord, right: Chord) -> Bool {
    // Compare the absolute pitches both on 4th octave with tolerance of one octave shift due to inversion
    return [3, 4, 5].map { right.pitches(octave: $0) }.contains(left.pitches(octave: 4))
  }

  /// Checks the equability between two chords by their base key, notes and inversion.
  ///
  /// - Parameters:
  ///   - left: Left handside of the equation.
  ///   - right: Right handside of the equation.
  /// - Returns: Returns Bool value of equation of two given chords.
  public static func === (left: Chord, right: Chord) -> Bool {
    return left.key == right.key && left.type == right.type && left.inversion == right.inversion
  }
}

public extension Chord {
  public class Builder {
    public typealias BuilderBlock = (Builder) -> Void

    public var type: ChordType?
    public var key: Key?
    public var inversion: Int?

    public init(builderBlock: BuilderBlock) {
      builderBlock(self)
    }
  }

  public init?(builder: Builder) {
    guard let type = builder.type, let key = builder.key else {
      return nil
    }
    self.type = type
    self.key = key
    if let inversion = builder.inversion {
      self.inversion = inversion
    }
  }
}
