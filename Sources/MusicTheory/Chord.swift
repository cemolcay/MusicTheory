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

extension Interval {
  /// Returns the sum of two intervals semitones.
  ///
  /// - Parameters:
  ///   - lhs: Left hand side of the equation.
  ///   - rhs: Right hand side of the equation.
  /// - Returns: Sum of two intervals in terms of their semitones.
  fileprivate static func + (lhs: Interval, rhs: Accidental) -> Int {
    return lhs.semitones + rhs.rawValue
  }
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
  case agumented

  /// Initilize chord part with interval.
  public init?(interval: Interval) {
    switch interval {
    case ChordFifthType.perfect.interval:
      self = .perfect
    case ChordFifthType.diminished.interval:
      self = .diminished
    case ChordFifthType.agumented.interval:
      self = .agumented
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
    case .agumented:
      return .A5
    }
  }

  /// Notation of chord part.
  public var notation: String {
    switch self {
    case .perfect: return ""
    case .agumented: return "♯5"
    case .diminished: return "♭5"
    }
  }

  /// Description of chord part.
  public var description: String {
    switch self {
    case .perfect: return ""
    case .agumented: return "Agumented"
    case .diminished: return "Diminished"
    }
  }

  /// All values of `ChordFifthType`.
  public static var all: [ChordFifthType] {
    return [.perfect, .diminished, .agumented]
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
  /// Seventh note of the chord. 11 halfsteps between the root.
  case major
  /// Halfstep down of a seventh note. 10 halfsteps between the root.
  case dominant
  /// Two halfsteps down of a seventh note. 9 halfsteps between the root.
  case diminished

  /// Initilize chord part with interval.
  public init?(interval: Interval) {
    switch interval {
    case ChordSeventhType.major.interval:
      self = .major
    case ChordSeventhType.dominant.interval:
      self = .dominant
    case ChordSeventhType.diminished.interval:
      self = .diminished
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
      return Interval(quality: .diminished, degree: 7, semitones: 9)
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
    return [.major, .dominant, .diminished]
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
public struct ChordExtensionType: ChordPart {
  /// Defines type of the extended chords.
  public enum ExtensionType: Int, ChordDescription {
    /// 9th chord. Second note of the chord, one octave up from root.
    case ninth = 9
    /// 11th chord. Eleventh note of the chord, one octave up from root.
    case eleventh = 11
    /// 13th chord. Sixth note of the chord, one octave up from root.
    case thirteenth = 13

    /// Interval between root.
    public var interval: Interval {
      switch self {
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
      return [.ninth, .eleventh, .thirteenth]
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
}

// MARK - CustomChordType

/// Custom chord with the custom intervals.
public struct CustomChordType: ChordDescription {
  /// Intervals of the chord type.
  public var intervals: [Interval]

  /// Initialize the chord type with the custom intervals.
  ///
  /// - Parameter intervals: Custom intervals.
  public init(intervals: [Interval]) {
    self.intervals = intervals
  }

  /// Notation of the chord type.
  public var notation: String {
    return description
  }

  /// Description of the chord type.
  public var description: String {
    return ""
  }
}

// MARK: - ChordType

/// Checks the equability between two `ChordType`s by their intervals.
///
/// - Parameters:
///   - left: Left handside of the equation.
///   - right: Right handside of the equation.
/// - Returns: Returns Bool value of equation of two given chord types.
public func == (left: ChordType?, right: ChordType?) -> Bool {
  switch (left, right) {
  case let (.some(left), .some(right)):
    return left.intervals == right.intervals
  case (.none, .none):
    return true
  default:
    return false
  }
}

/// Defines full type of chord with all chord parts.
public struct ChordType: ChordDescription {
  /// Thirds part. Second note of the chord.
  public var third: ChordThirdType
  /// Fifths part. Third note of the chord.
  public var fifth: ChordFifthType
  /// Defines a sixth chord. Defaults nil.
  public var sixth: ChordSixthType?
  /// Defines a seventh chord. Defaults nil.
  public var seventh: ChordSeventhType?
  /// Defines a suspended chord. Defaults nil.
  public var suspended: ChordSuspendedType?
  /// Defines extended chord. Defaults nil.
  public var extensions: [ChordExtensionType]? {
    didSet {
      if extensions?.count == 1 {
        extensions![0].isAdded = seventh == nil
        // Add other extensions if needed
        if let ext = extensions?.first, ext.type == .eleventh, !ext.isAdded {
          extensions?.append(ChordExtensionType(type: .ninth))
        } else if let ext = extensions?.first, ext.type == .thirteenth, !ext.isAdded {
          extensions?.append(ChordExtensionType(type: .ninth))
          extensions?.append(ChordExtensionType(type: .eleventh))
        }
      }
    }
  }

  /// Describes a custom chord that can not represent with the current date structures. Defaults nil.
  public var custom: CustomChordType?

  /// Initilze the chord type with its parts.
  ///
  /// - Parameters:
  ///   - third: Thirds part.
  ///   - fifth: Fifths part. Defaults perfect fifth.
  ///   - sixth: Sixth part. Defaults nil.
  ///   - seventh: Seventh part. Defaults nil.
  ///   - suspended: Suspended part. Defaults nil.
  ///   - extensions: Extended chords part. Defaults nil. Could be add more than one extended chord.
  ///   - custom: Fill that with the custom intervals if it's not represented by the current data structures. Defaults nil.
  public init(
    third: ChordThirdType,
    fifth: ChordFifthType = .perfect,
    sixth: ChordSixthType? = nil,
    seventh: ChordSeventhType? = nil,
    suspended: ChordSuspendedType? = nil,
    extensions: [ChordExtensionType]? = nil,
    custom: CustomChordType? = nil) {
    self.third = third
    self.fifth = fifth
    self.sixth = sixth
    self.seventh = seventh
    self.suspended = suspended
    self.extensions = extensions

    if extensions?.count == 1 {
      self.extensions![0].isAdded = seventh == nil
      // Add other extensions if needed
      if let ext = self.extensions?.first, ext.type == .eleventh, !ext.isAdded {
        self.extensions?.append(ChordExtensionType(type: .ninth))
      } else if let ext = self.extensions?.first, ext.type == .thirteenth, !ext.isAdded {
        self.extensions?.append(ChordExtensionType(type: .ninth))
        self.extensions?.append(ChordExtensionType(type: .eleventh))
      }
    }
  }

  /// Initilze the chord type with its intervals.
  ///
  /// - Parameters:
  ///   - intervals: Intervals of chord notes distances between root note for each.
  public init?(intervals: [Interval]) {
    var third: ChordThirdType?
    var fifth: ChordFifthType?
    var sixth: ChordSixthType?
    var seventh: ChordSeventhType?
    var suspended: ChordSuspendedType?
    var extensions = [ChordExtensionType]()

    for interval in intervals {
      if let thirdPart = ChordThirdType(interval: interval) {
        third = thirdPart
      } else if let fifthPart = ChordFifthType(interval: interval) {
        fifth = fifthPart
      } else if let sixthPart = ChordSixthType(interval: interval) {
        sixth = sixthPart
      } else if let seventhPart = ChordSeventhType(interval: interval) {
        seventh = seventhPart
      } else if let suspendedPart = ChordSuspendedType(interval: interval) {
        suspended = suspendedPart
      } else if let extensionPart = ChordExtensionType(interval: interval) {
        extensions.append(extensionPart)
      }
    }

    self = ChordType(
      third: third ?? .major,
      fifth: fifth ?? .perfect,
      sixth: sixth,
      seventh: seventh,
      suspended: suspended,
      extensions: extensions,
      custom: custom
    )
  }

  /// Intervals of parts between root.
  public var intervals: [Interval] {
    var parts: [ChordPart?] = [third, suspended, fifth, sixth, seventh]
    parts += extensions?.sorted(by: { $0.type.rawValue < $1.type.rawValue }).map({ $0 as ChordPart? }) ?? []
    return [.P1] + parts.compactMap({ $0?.interval })
  }

  /// Notation of the chord type.
  public var notation: String {
    var seventhNotation = seventh?.notation ?? ""
    var sixthNotation = sixth == nil ? "" : "\(sixth!.notation)\(seventh == nil ? "" : "/")"
    let suspendedNotation = suspended?.notation ?? ""
    var extensionNotation = ""
    let ext = extensions?.sorted(by: { $0.type.rawValue < $1.type.rawValue }) ?? []

    var singleNotation = !ext.isEmpty && true
    for i in 0 ..< max(0, ext.count - 1) {
      if ext[i].accidental != .natural {
        singleNotation = false
      }
    }

    if singleNotation {
      extensionNotation = "(\(ext.last!.notation))"
    } else {
      extensionNotation = ext
        .compactMap({ $0.notation })
        .joined(separator: "/")
      extensionNotation = extensionNotation.isEmpty ? "" : "(\(extensionNotation))"
    }

    if seventh != nil {
      // Don't show major seventh note if extended is a major as well
      if seventh == .major, (extensions ?? []).count > 0 {
        seventhNotation = ""
        sixthNotation = sixth == nil ? "" : sixth!.notation
      }
      // Show fifth note after seventh in parenthesis
      if fifth == .agumented || fifth == .diminished {
        return "\(third.notation)\(sixthNotation)\(seventhNotation)(\(fifth.notation))\(suspendedNotation)\(extensionNotation)"
      }
    }

    return "\(third.notation)\(fifth.notation)\(sixthNotation)\(seventhNotation)\(suspendedNotation)\(extensionNotation)"
  }

  /// Description of the chord type.
  public var description: String {
    let seventhNotation = seventh?.description
    let sixthNotation = sixth?.description
    let suspendedNotation = suspended?.description
    let extensionsNotation = extensions?
      .sorted(by: { $0.type.rawValue < $1.type.rawValue })
      .map({ $0.description as String? }) ?? []
    let desc = [third.description, fifth.description, sixthNotation, seventhNotation, suspendedNotation] + extensionsNotation
    return desc.compactMap({ $0 }).joined(separator: " ")
  }

  /// All possible chords could be generated.
  public static var all: [ChordType] {
    func combinations(_ elements: [ChordExtensionType], taking: Int = 1) -> [[ChordExtensionType]] {
      guard elements.count >= taking else { return [] }
      guard elements.count > 0 && taking > 0 else { return [[]] }

      if taking == 1 {
        return elements.map { [$0] }
      }

      var comb = [[ChordExtensionType]]()
      for (index, element) in elements.enumerated() {
        var reducedElements = elements
        reducedElements.removeFirst(index + 1)
        comb += combinations(reducedElements, taking: taking - 1).map { [element] + $0 }
      }
      return comb
    }

    var all = [ChordType]()
    let allThird = ChordThirdType.all
    let allFifth = ChordFifthType.all
    let allSixth: [ChordSixthType?] = [ChordSixthType(), nil]
    let allSeventh: [ChordSeventhType?] = ChordSeventhType.all + [nil]
    let allSus: [ChordSuspendedType?] = ChordSuspendedType.all + [nil]
    let allExt = combinations(ChordExtensionType.all) +
      combinations(ChordExtensionType.all, taking: 2) +
      combinations(ChordExtensionType.all, taking: 3)

    for third in allThird {
      for fifth in allFifth {
        for sixth in allSixth {
          for seventh in allSeventh {
            for sus in allSus {
              for ext in allExt {
                all.append(ChordType(
                  third: third,
                  fifth: fifth,
                  sixth: sixth,
                  seventh: seventh,
                  suspended: sus,
                  extensions: ext
                ))
              }
            }
          }
        }
      }
    }
    return all
  }
}

// MARK: - Chord

/// Checks the equability between two chords by their base key and notes.
///
/// - Parameters:
///   - left: Left handside of the equation.
///   - right: Right handside of the equation.
/// - Returns: Returns Bool value of equation of two given chords.
public func == (left: Chord?, right: Chord?) -> Bool {
  switch (left, right) {
  case let (.some(left), .some(right)):
    return left.key == right.key && left.type == right.type
  case (.none, .none):
    return true
  default:
    return false
  }
}

/// Defines a chord with a root note and type.
public struct Chord: ChordDescription {
  /// Type of the chord.
  public var type: ChordType
  /// Root key of the chord.
  public var key: Key
  /// Inversion index of the chord.
  public private(set) var inversion: Int

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
    // Check if agumented
    if type.fifth == .agumented {
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

  // MARK: CustomStringConvertible

  /// Description of the chord.
  public var description: String {
    let inversionNotation = inversion > 0 ? " \(inversion). Inversion" : ""
    return "\(key) \(type)\(inversionNotation)"
  }
}

// MARK: - Extensions

extension Array {
  internal var shifted: Array {
    guard let firstElement = first else { return self }
    var arr = self
    arr.removeFirst()
    arr.append(firstElement)
    return arr
  }
}
