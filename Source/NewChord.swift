//
//  NewChord.swift
//  MusicTheory
//
//  Created by Cem Olcay on 22.10.2017.
//  Copyright © 2017 prototapp. All rights reserved.
//

import Foundation

public protocol ChordDescription: CustomStringConvertible {
  var notation: String { get }
}

public protocol ChordPart: ChordDescription {
  var interval: Interval { get }
}

public enum NewChordThirdType: ChordPart {
  case major
  case minor

  public var interval: Interval {
    switch self {
    case .major:
      return .M3
    case .minor:
      return .m3
    }
  }

  public var notation: String {
    switch self {
    case .major: return ""
    case .minor: return "m"
    }
  }

  public var description: String {
    switch self {
    case .major: return "Major"
    case .minor: return "Minor"
    }
  }

  public static var all: [NewChordThirdType] {
    return [.major, .minor]
  }
}

public enum NewChordFifthType: ChordPart {
  case perfect
  case diminished
  case agumented

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

  public var notation: String {
    switch self {
    case .perfect: return ""
    case .agumented: return "♯5"
    case .diminished: return "♭5"
    }
  }

  public var description: String {
    switch self {
    case .perfect: return ""
    case .agumented: return "aug"
    case .diminished: return "dim"
    }
  }

  public static var all: [NewChordFifthType] {
    return [.perfect, .diminished, .agumented]
  }
}

public struct NewChordSixthType: ChordPart {
  public var interval: Interval {
    return .M6
  }

  public var notation: String {
    return "6"
  }

  public var description: String {
    return "Sixth"
  }
}

public enum NewChordSeventhType: ChordPart {
  case major // triad and seventh note
  case dominant // triad and halfstep down seventh note

  public var interval: Interval {
    switch self {
    case .dominant:
      return .m7
    case .major:
      return .M7
    }
  }

  public var notation: String {
    switch self {
    case .major: return "maj7"
    case .dominant: return "7"
    }
  }

  public var description: String {
    switch self {
    case .major: return "Major 7th"
    case .dominant: return "Dominant 7th"
    }
  }

  public static var all: [NewChordSeventhType] {
    return [.major, .dominant]
  }
}

public enum NewChordSuspendedType: ChordPart {
  case sus2 // second note instead of third note
  case sus4 // fourth note instead of third note

  public var interval: Interval {
    switch self {
    case .sus2:
      return .M2
    case .sus4:
      return .P4
    }
  }

  public var notation: String {
    switch self {
    case .sus2: return "(sus2)"
    case .sus4: return "(sus4)"
    }
  }

  public var description: String {
    switch self {
    case .sus2: return "Suspended 2nd"
    case .sus4: return "Suspended 4th"
    }
  }

  public static var all: [NewChordSuspendedType] {
    return [.sus2, .sus4]
  }
}

public struct NewChordExtensionType: ChordPart {

  public enum Accident {
    case natural
    case flat
    case sharp

    public static var all: [Accident] {
      return [.natural, .flat, .sharp]
    }
  }

  public enum ExtensionType: Int {
    case ninth = 9
    case eleventh = 11
    case thirteenth = 13

    public static var all: [ExtensionType] {
      return [.ninth, .eleventh, .thirteenth]
    }
  }

  public var type: ExtensionType
  public var accident: Accident
  public var isMajor: Bool
  public var isAdded: Bool

  public init(type: ExtensionType, accident: Accident = .natural) {
    self.type = type
    self.accident = accident
    self.isMajor = false
    self.isAdded = false
  }

  internal init(type: ExtensionType, accident: Accident = .natural, isMajor: Bool = false, isAdded: Bool = false) {
    self.type = type
    self.accident = accident
    self.isMajor = isMajor
    self.isAdded = isAdded
  }

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

  public static var all: [NewChordExtensionType] {
    var all = [NewChordExtensionType]()
    for type in ExtensionType.all {
      for accident in Accident.all {
        all.append(NewChordExtensionType(type: type, accident: accident))
      }
    }
    return all
  }
}

public struct NewChordType: ChordDescription {
  public var third: NewChordThirdType
  public var fifth: NewChordFifthType
  public var sixth: NewChordSixthType?
  public var seventh: NewChordSeventhType?
  public var suspended: NewChordSuspendedType?
  public var extensions: [NewChordExtensionType]? {
    didSet {
      if extensions?.count == 1 {
        extensions?[0].isMajor = seventh == .major
        extensions?[0].isAdded = seventh == nil
      }
    }
  }

  public init(third: NewChordThirdType, fifth: NewChordFifthType = .perfect, sixth: NewChordSixthType? = nil, seventh: NewChordSeventhType? = nil, suspended: NewChordSuspendedType? = nil, extensions: [NewChordExtensionType]? = nil) {
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

  public var intervals: [Interval] {
    var parts: [ChordPart?] = [sixth == nil ? third : nil, suspended, fifth, sixth, seventh]
    parts += extensions?.sorted(by: { $0.type.rawValue < $1.type.rawValue }).map({ $0 as? ChordPart }) ?? []
    return [.unison] + parts.flatMap({ $0?.interval })
  }

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

  public static var all: [NewChordType] {
    func combinations(_ elements: [NewChordExtensionType], taking: Int = 1) -> [[NewChordExtensionType]] {
      guard elements.count >= taking else { return [] }
      guard elements.count > 0 && taking > 0 else { return [[]] }

      if taking == 1 {
        return elements.map {[$0]}
      }

      var comb = [[NewChordExtensionType]]()
      for (index, element) in elements.enumerated() {
        var reducedElements = elements
        reducedElements.removeFirst(index + 1)
        comb += combinations(reducedElements, taking: taking - 1).map {[element] + $0}
      }
      return comb
    }
    
    var all = [NewChordType]()
    let allThird = NewChordThirdType.all
    let allFifth = NewChordFifthType.all
    let allSixth: [NewChordSixthType?] = [NewChordSixthType(), nil]
    let allSeventh: [NewChordSeventhType?] = NewChordSeventhType.all
    let allSus: [NewChordSuspendedType?] = NewChordSuspendedType.all
    let allExt = combinations(NewChordExtensionType.all) + combinations(NewChordExtensionType.all, taking: 2) + combinations(NewChordExtensionType.all, taking: 3)
    for third in allThird {
      for fifth in allFifth {
        for sixth in allSixth {
          for seventh in 0...allSeventh.count {
            for sus in 0...allSus.count {
              for ext in 0...allExt.count {
                all.append(NewChordType(
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

public struct NewChord: ChordDescription {
  public private(set) var key: NoteType
  public private(set) var type: NewChordType

  public init(key: NoteType, type: NewChordType) {
    self.key = key
    self.type = type
  }

  public func notes(octave: Int) -> [Note] {
    return type.intervals.map({ Note(type: key, octave: octave) + $0 })
  }

  public func notes(octaves: [Int]) -> [Note] {
    return octaves.flatMap({ notes(octave: $0) }).sorted(by: { $0.midiNote < $1.midiNote })
  }

  public var notation: String {
    return "\(key)\(type.notation)"
  }

  public var description: String {
    return "\(key) \(type)"
  }

  public static var all: [NewChord] {
    var all = [NewChord]()
    for note in NoteType.all {
      for type in NewChordType.all {
        all.append(NewChord(key: note, type: type))
      }
    }
    return all
  }
}
