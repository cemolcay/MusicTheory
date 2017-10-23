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

/// Protocol that defines a printable chord part.
public protocol ChordDescription: CustomStringConvertible {
  /// Notation of chord.
  var notation: String { get }
}

/// Protocol that defines a chord part.
public protocol ChordPart: ChordDescription {
  /// Interval between the root.
  var interval: Interval { get }
}

/// Defines third part of the chord. Second note after the root.
public enum ChordThirdType: ChordPart {
  /// Defines major chord. 4 halfsteps between root.
  case major
  /// Defines minor chord. 3 halfsteps between root.
  case minor

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
public enum ChordFifthType: ChordPart {
  /// Perfect fifth interval between root.
  case perfect
  /// Half step down of perfect fifth.
  case diminished
  /// Half step up of perfect fifth.
  case agumented

  /// Interval between root.
  public var interval: Interval {
    switch self {
    case .perfect:
      return .P5
    case .diminished:
      return .d5
    case .agumented:
      return .m6
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
    case .agumented: return "aug"
    case .diminished: return "dim"
    }
  }

  /// All values of `ChordFifthType`.
  public static var all: [ChordFifthType] {
    return [.perfect, .diminished, .agumented]
  }
}

/// Defiens sixth chords. If you add the sixth note, you have sixth chord.
public struct ChordSixthType: ChordPart {
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
public enum ChordSeventhType: ChordPart {
  /// Seventh note of the chord. 11 halfsteps between root.
  case major
  /// Halfstep down of seventh note. 10 halfsteps between root.
  case dominant

  /// Interval between root.
  public var interval: Interval {
    switch self {
    case .major:
      return .M7
    case .dominant:
      return .m7
    }
  }

  /// Notation of chord part.
  public var notation: String {
    switch self {
    case .major: return "maj7"
    case .dominant: return "7"
    }
  }

  /// Description of chord part.
  public var description: String {
    switch self {
    case .major: return "Major 7th"
    case .dominant: return "Dominant 7th"
    }
  }

  /// All values of `ChordSeventhType`.
  public static var all: [ChordSeventhType] {
    return [.major, .dominant]
  }
}

/// Defines suspended chords.
/// If you play second or fourth note of chord, instead of thirds, than you have suspended chords.
public enum ChordSuspendedType: ChordPart {
  /// Second note of chord instead of third part. 2 halfsteps between root.
  case sus2
  /// Fourth note of chord instead of third part. 5 halfsteps between root.
  case sus4

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

  /// Defines accident of extended chord.
  public enum Accident {
    /// No accidents, natural note.
    case natural
    /// Halfstep down, bemol.
    case flat
    /// Halfstep up, sharp.
    case sharp

    /// All values of `Accident`.
    public static var all: [Accident] {
      return [.natural, .flat, .sharp]
    }
  }

  /// Defines type of the extended chords.
  public enum ExtensionType: Int {
    /// 9th chord. Second note of the chord, one octave up from root.
    case ninth = 9
    /// 11th chord. Eleventh note of the chord, one octave up from root.
    case eleventh = 11
    /// 13th chord. Sixth note of the chord, one octave up from root.
    case thirteenth = 13

    /// All values of `ExtensionType`.
    public static var all: [ExtensionType] {
      return [.ninth, .eleventh, .thirteenth]
    }
  }

  /// Type of extended chord.
  public var type: ExtensionType
  /// Accident of extended chord.
  public var accident: Accident
  /// True if seventh note is exists and is major 7th. Defaults false.
  internal var isMajor: Bool
  /// If there are no seventh note and only one extended part is this. Defaults false
  internal var isAdded: Bool

  /// Initilizes extended chord.
  ///
  /// - Parameters:
  ///   - type: Type of extended chord.
  ///   - accident: Accident of extended chord. Defaults natural.
  public init(type: ExtensionType, accident: Accident = .natural) {
    self.type = type
    self.accident = accident
    self.isMajor = false
    self.isAdded = false
  }

  /// Initilizes extended chord.
  ///
  /// - Parameters:
  ///   - type: Type of extended chord.
  ///   - accident: Accident of extended chord.
  ///   - isMajor: Is seventh is major.
  ///   - isAdded: Is added chord or not.
  internal init(type: ExtensionType, accident: Accident = .natural, isMajor: Bool = false, isAdded: Bool = false) {
    self.type = type
    self.accident = accident
    self.isMajor = isMajor
    self.isAdded = isAdded
  }

  /// Interval between root.
  public var interval: Interval {
    var typeInterval = 0
    switch type {
    case .ninth: typeInterval = (.M2 * 2).halfstep
    case .eleventh: typeInterval = (.P4 * 2).halfstep
    case .thirteenth: typeInterval = (.M6 * 2).halfstep
    }

    var accidentInterval = 0
    switch accident {
    case .natural: accidentInterval = 0
    case .flat: accidentInterval = -1
    case .sharp: accidentInterval = 1
    }

    return Interval(halfstep: typeInterval + accidentInterval)
  }

  /// Notation of chord part.
  public var notation: String {
    var typeNotation = ""
    switch type {
    case .ninth: typeNotation = "9"
    case .eleventh: typeNotation = "11"
    case .thirteenth: typeNotation = "13"
    }

    var accidentNotation = ""
    switch accident {
    case .natural: accidentNotation = ""
    case .flat: accidentNotation = "♭"
    case .sharp: accidentNotation = "♯"
    }

    if isMajor {
      return "maj\(accidentNotation)\(typeNotation)"
    } else if isAdded {
      return "add\(accidentNotation)\(typeNotation)"
    } else {
      return "\(accidentNotation)\(typeNotation)"
    }
  }

  /// Description of chord part.
  public var description: String {
    var typeDescription = ""
    switch type {
    case .ninth: typeDescription = "9th"
    case .eleventh: typeDescription = "11th"
    case .thirteenth: typeDescription = "13th"
    }

    var accidentDescription = ""
    switch accident {
    case .natural: accidentDescription = "Natural"
    case .flat: accidentDescription = "Flat"
    case .sharp: accidentDescription = "Sharp"
    }

    return "\(isAdded ? "Added " : "")\(accidentDescription) \(typeDescription)"
  }

  /// All values of `ChordExtensionType`
  public static var all: [ChordExtensionType] {
    var all = [ChordExtensionType]()
    for type in ExtensionType.all {
      for accident in Accident.all {
        all.append(ChordExtensionType(type: type, accident: accident))
      }
    }
    return all
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
        extensions?[0].isMajor = seventh == .major
        extensions?[0].isAdded = seventh == nil
      }
    }
  }

  /// Initilze the chord type with its parts.
  ///
  /// - Parameters:
  ///   - third: Thirds part.
  ///   - fifth: Fifths part. Defaults perfect fifth.
  ///   - sixth: Sixth part. Defaults nil.
  ///   - seventh: Seventh part. Defaults nil.
  ///   - suspended: Suspended part. Defaults nil.
  ///   - extensions: Extended chords part. Defaults nil. Could be add more than one extended chord.
  public init(third: ChordThirdType, fifth: ChordFifthType = .perfect, sixth: ChordSixthType? = nil, seventh: ChordSeventhType? = nil, suspended: ChordSuspendedType? = nil, extensions: [ChordExtensionType]? = nil) {
    self.third = third
    self.fifth = fifth
    self.sixth = sixth
    self.seventh = seventh
    self.suspended = suspended
    self.extensions = extensions

    if extensions?.count == 1 {
      self.extensions?[0].isMajor = seventh == .major
      self.extensions?[0].isAdded = seventh == nil
    }
  }

  /// Intervals of parts between root.
  public var intervals: [Interval] {
    var parts: [ChordPart?] = [sixth == nil ? third : nil, suspended, fifth, sixth, seventh]
    // FIXME: Check if extensions have other parts. If only has 13, check if also has 9 and 11.
    parts += extensions?.sorted(by: { $0.type.rawValue < $1.type.rawValue }).map({ $0 as? ChordPart }) ?? []
    return [.unison] + parts.flatMap({ $0?.interval })
  }

  /// Notation of the chord type.
  public var notation: String {
    var seventhNotation = seventh?.notation ?? ""
    let sixthNotation = sixth == nil ? "" : seventh == nil ? sixth!.notation : "\(sixth!.notation)/"
    let suspendedNotation = suspended?.notation ?? ""
    let safeExtensionsNotation = extensions?
      .sorted(by: { $0.type.rawValue < $1.type.rawValue })
      .flatMap({ $0.notation })
      .joined(separator: "/")
    let extensionsNotation = safeExtensionsNotation == nil ? "" : "(\(safeExtensionsNotation!))"

    if seventh != nil {
      // Don't show major seventh note if extended is a major as well
      if seventh == .major, extensions?.count == 1, extensions?[0].isMajor == true {
        seventhNotation = ""
      }
      // Show fifth note after seventh in parenthesis
      if fifth == .agumented || fifth == .diminished {
        return "\(third.notation)\(sixthNotation)\(seventhNotation)(\(fifth.notation))\(suspendedNotation)\(extensionsNotation)"
      }
    }

    return "\(third.notation)\(fifth.notation)\(sixthNotation)\(seventhNotation)\(suspendedNotation)\(extensionsNotation)"
  }

  /// Description of the chord type.
  public var description: String {
    let seventhNotation = seventh?.description ?? ""
    let sixthNotation = sixth?.description ?? ""
    let suspendedNotation = suspended?.description ?? ""
    let extensionsNotation = extensions?
      .sorted(by: { $0.type.rawValue < $1.type.rawValue })
      .flatMap({ $0.description })
      .joined(separator: ", ") ?? ""
    return "\(third.notation) \(fifth.notation) \(sixthNotation) \(seventhNotation) \(suspendedNotation) \(extensionsNotation)"
  }

  /// All possible chords could be generated.
  public static var all: [ChordType] {
    func combinations(_ elements: [ChordExtensionType], taking: Int = 1) -> [[ChordExtensionType]] {
      guard elements.count >= taking else { return [] }
      guard elements.count > 0 && taking > 0 else { return [[]] }

      if taking == 1 {
        return elements.map {[$0]}
      }

      var comb = [[ChordExtensionType]]()
      for (index, element) in elements.enumerated() {
        var reducedElements = elements
        reducedElements.removeFirst(index + 1)
        comb += combinations(reducedElements, taking: taking - 1).map {[element] + $0}
      }
      return comb
    }
    
    var all = [ChordType]()
    let allThird = ChordThirdType.all
    let allFifth = ChordFifthType.all
    let allSixth: [ChordSixthType?] = [ChordSixthType(), nil]
    let allSeventh: [ChordSeventhType?] = ChordSeventhType.all
    let allSus: [ChordSuspendedType?] = ChordSuspendedType.all
    let allExt = combinations(ChordExtensionType.all) + combinations(ChordExtensionType.all, taking: 2) + combinations(ChordExtensionType.all, taking: 3)
    for third in allThird {
      for fifth in allFifth {
        for sixth in allSixth {
          for seventh in 0...allSeventh.count {
            for sus in 0...allSus.count {
              for ext in 0...allExt.count {
                all.append(ChordType(
                  third: third,
                  fifth: fifth,
                  sixth: sixth,
                  seventh: seventh < allSeventh.count ? allSeventh[seventh] : nil,
                  suspended: sus < allSus.count ? allSus[sus] : nil,
                  extensions: ext < allExt.count ? allExt[ext] : nil))
              }
            }
          }
        }
      }
    }
    return all
  }
}

/// Defines a chord with a root note and type.
public struct Chord: ChordDescription {
  /// Root note of the chord.
  public private(set) var key: NoteType
  /// Type of the chord.
  public private(set) var type: ChordType

  /// Initilizes chord with root note and type.
  ///
  /// - Parameters:
  ///   - key: Root note of the chord.
  ///   - type: Tyoe of the chord.
  public init(key: NoteType, type: ChordType) {
    self.key = key
    self.type = type
  }

  /// Generates notes of the chord for octave.
  ///
  /// - Parameter octave: Octave of the root note for the build chord from.
  /// - Returns: Generates notes of the chord.
  public func notes(octave: Int) -> [Note] {
    return type.intervals.map({ Note(type: key, octave: octave) + $0 })
  }

  /// Generates notes of the chord for octave range.
  ///
  /// - Parameter octaves: Octaves of the root note to build chord from.
  /// - Returns: Generates notes of the chord.
  public func notes(octaves: [Int]) -> [Note] {
    return octaves.flatMap({ notes(octave: $0) }).sorted(by: { $0.midiNote < $1.midiNote })
  }

  /// Notation of the chord.
  public var notation: String {
    return "\(key)\(type.notation)"
  }

  /// Description of the chord.
  public var description: String {
    return "\(key) \(type)"
  }

  /// All possible chord values could be generated.
  public static var all: [Chord] {
    var all = [Chord]()
    for note in NoteType.all {
      for type in ChordType.all {
        all.append(Chord(key: note, type: type))
      }
    }
    return all
  }
}
