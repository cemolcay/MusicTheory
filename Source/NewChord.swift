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

public enum NewChordThirdType: ChordDescription {
  case major
  case minor

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

public enum NewChordFifthType: ChordDescription {
  case perfect
  case diminished
  case agumented

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

public struct NewChordSixth: ChordDescription {
  public var notation: String {
    return "6"
  }

  public var description: String {
    return "Sixth"
  }
}

public enum NewChordSeventhType: ChordDescription {
  case major // triad and seventh note
  case dominant // triad and halfstep down seventh note

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

public enum NewChordSuspendedType: ChordDescription {
  case sus2 // second note instead of third note
  case sus4 // fourth note instead of third note

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

public enum NewChordAccidentType: ChordDescription {
  case natural // no accident
  case flat // halfstep down
  case sharp // halfstep up

  public var notation: String {
    switch self {
    case .natural: return ""
    case .flat: return "♭"
    case .sharp: return "♯"
    }
  }

  public var description: String {
    switch self {
    case .natural: return "Natural"
    case .flat: return "Flat"
    case .sharp: return "Sharp"
    }
  }

  public static var all: [NewChordAccidentType] {
    return [.natural, .flat, .sharp]
  }
}

public enum NewChordExtensionType: Int, ChordDescription {
  case ninth = 9
  case eleventh = 11
  case thirteenth = 13

  public var notation: String {
    switch self {
    case .ninth: return "9"
    case .eleventh: return "11"
    case .thirteenth: return "13"
    }
  }

  public var description: String {
    switch self {
    case .ninth: return "9th"
    case .eleventh: return "11th"
    case .thirteenth: return "13th"
    }
  }

  public static var all: [NewChordExtensionType] {
    return [.ninth, .eleventh, .thirteenth]
  }
}

public struct NewChordExtension: ChordDescription {
  public var type: NewChordExtensionType
  public var accident: NewChordAccidentType
  public var isMajor: Bool
  public var isAdded: Bool

  public init(type: NewChordExtensionType, accident: NewChordAccidentType = .natural, isMajor: Bool = false, isAdded: Bool = false) {
    self.type = type
    self.accident = accident
    self.isMajor = isMajor
    self.isAdded = isAdded
  }

  public var notation: String {
    if isMajor {
      return "maj\(accident.notation)\(type.notation)"
    } else if isAdded {
      return "add\(accident.notation)\(type.notation)"
    } else {
      return "\(accident.notation)\(type.notation)"
    }
  }

  public var description: String {
    return "\(isAdded ? "Added " : "")\(accident) \(type)"
  }

  public static var all: [NewChordExtension] {
    var all = [NewChordExtension]()
    for type in NewChordExtensionType.all {
      for accident in NewChordAccidentType.all {
        all.append(NewChordExtension(type: type, accident: accident))
      }
    }
    return all
  }
}

public struct NewChordType: ChordDescription {
  public var third: NewChordThirdType
  public var fifth: NewChordFifthType
  public var sixth: NewChordSixth?
  public var seventh: NewChordSeventhType?
  public var suspended: NewChordSuspendedType?
  public var extensions: [NewChordExtension]?

  public init(third: NewChordThirdType, fifth: NewChordFifthType, sixth: NewChordSixth? = nil, seventh: NewChordSeventhType? = nil, suspended: NewChordSuspendedType? = nil, extensions: [NewChordExtension]? = nil) {
    self.third = third
    self.fifth = fifth
    self.sixth = sixth
    self.seventh = seventh
    self.suspended = extensions == nil ? suspended : nil
    self.extensions = extensions

    if extensions?.count == 1 {
      self.extensions?[0].isMajor = seventh == .major
      self.extensions?[0].isAdded = seventh == nil
    }
  }

  public var intervals: [Interval] {
    var intervals: [Interval] = [.unison]
    // Thirds
    switch third {
    case .major:
      intervals.append(.M3)
    case .minor:
      intervals.append(.m3)
    }
    // Fifths
    switch fifth {
    case .perfect:
      intervals.append(.P5)
    case .diminished:
      intervals.append(.d5)
    case .agumented:
      intervals.append(.m6)
    }
    // Sixths
    if case .some = sixth {
      intervals.append(.M6)
    }
    // Sevenths
    // Extensions
    return intervals
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
    func combinations(_ elements: [NewChordExtension], taking: Int = 1) -> [[NewChordExtension]] {
      guard elements.count >= taking else { return [] }
      guard elements.count > 0 && taking > 0 else { return [[]] }

      if taking == 1 {
        return elements.map {[$0]}
      }

      var comb = [[NewChordExtension]]()
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
    let allSixth: [NewChordSixth?] = [NewChordSixth(), nil]
    let allSeventh: [NewChordSeventhType?] = NewChordSeventhType.all
    let allSus: [NewChordSuspendedType?] = NewChordSuspendedType.all
    let allExt = combinations(NewChordExtension.all) + combinations(NewChordExtension.all, taking: 2) + combinations(NewChordExtension.all, taking: 3)
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
  public private(set) var inversion: Int

  public init(key: NoteType, type: NewChordType, inversion: Int = 0) {
    self.key = key
    self.type = type
    self.inversion = inversion
  }

  public var notation: String {
    return "\(key)\(type.notation)"
  }

  public var description: String {
    return "\(key) \(type)"
  }

  public static func from(notes: [Note]) -> [NewChord] {
    return []
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
