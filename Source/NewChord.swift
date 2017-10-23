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

public func ==(lhs: NewChordTetradType?, rhs: NewChordTetradType?) -> Bool {
  switch (lhs, rhs) {
    case (.some(let left), .some(let right)):
      switch (left, right) {
        case (.sixth, .sixth):
          return true
        case (.seventh(.dominant), .seventh(.dominant)):
          return true
        case (.seventh(.major), .seventh(.major)):
          return true
        default:
          return false
      }
  case (.none, .none):
    return true
  default:
    return false
  }
}

public enum NewChordTetradType: ChordDescription {
  case sixth // triad and sixth note
  case seventh(NewChordSeventhType) // triad and seventh note

  public var notation: String {
    switch self {
    case .sixth: return "6"
    case .seventh(let type): return type.notation
    }
  }

  public var description: String {
    switch self {
    case .sixth: return "Sixth"
    case .seventh(let type): return type.description
    }
  }

  public static var all: [NewChordTetradType] {
    return [.sixth, .seventh(.major), .seventh(.dominant)]
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
    case .flat: return "Halfstep down"
    case .sharp: return "Halfstep up"
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
  public var tetrad: NewChordTetradType?
  public var suspended: NewChordSuspendedType?
  public var extensions: [NewChordExtension]?

  public init(third: NewChordThirdType, fifth: NewChordFifthType, tetrad: NewChordTetradType? = nil, suspended: NewChordSuspendedType? = nil, extensions: [NewChordExtension]? = nil) {
    self.third = third
    self.fifth = fifth
    self.tetrad = tetrad
    self.suspended = extensions == nil ? suspended : nil
    self.extensions = extensions

    if extensions?.count == 1 {
      self.extensions?[0].isMajor = tetrad == NewChordTetradType.seventh(.major)
      self.extensions?[0].isAdded = !(tetrad == NewChordTetradType.seventh(.dominant) || tetrad == NewChordTetradType.seventh(.major))
    }
  }

  public var notation: String {
    var tetradNotation = tetrad?.notation ?? ""
    let suspendedNotation = suspended?.notation ?? ""
    let safeExtensionsNotation = extensions?
      .sorted(by: { $0.type.rawValue < $1.type.rawValue })
      .flatMap({ $0.notation })
      .joined(separator: "/")
    let extensionsNotation = safeExtensionsNotation == nil ? "" : "(\(safeExtensionsNotation!))"

    if tetrad != nil {
      // Don't show major seventh note if extended is a major as well
      if tetrad == .seventh(.major), extensions?.count == 1, extensions?[0].isMajor == true {
        tetradNotation = ""
      }
      // Show fifth note after seventh in parenthesis
      if fifth == .agumented || fifth == .diminished {
        return "\(third.notation)\(tetradNotation)(\(fifth.notation))\(suspendedNotation)\(extensionsNotation)"
      }
    }

    return "\(third.notation)\(fifth.notation)\(tetradNotation)\(suspendedNotation)\(extensionsNotation)"
  }

  public var description: String {
    let tetradNotation = tetrad?.description ?? ""
    let suspendedNotation = suspended?.description ?? ""
    let extensionsNotation = extensions?
      .sorted(by: { $0.type.rawValue < $1.type.rawValue })
      .flatMap({ $0.description })
      .joined(separator: ", ") ?? ""
    return "\(third.notation) \(fifth.notation) \(tetradNotation) \(suspendedNotation) \(extensionsNotation)"
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
    let allTetrad: [NewChordTetradType?] = Array(NewChordTetradType.all)
    let allSus: [NewChordSuspendedType?] = Array(NewChordSuspendedType.all)
    let allExt = combinations(NewChordExtension.all) + combinations(NewChordExtension.all, taking: 2) + combinations(NewChordExtension.all, taking: 3)
    for third in allThird {
      for fifth in allFifth {
        for tetrad in 0...allTetrad.count {
          for sus in 0...allSus.count {
            for ext in 0...allExt.count {
              all.append(NewChordType(
                third: third,
                fifth: fifth,
                tetrad: tetrad < allTetrad.count ? allTetrad[tetrad] : nil,
                suspended: sus < allSus.count ? allSus[sus] : nil,
                extensions: ext < allExt.count ? allExt[ext] : nil))
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
