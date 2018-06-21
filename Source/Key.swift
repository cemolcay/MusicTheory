//
//  Key.swift
//  MusicTheory iOS
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

public func +(lhs: Key, rhs: Key) -> Key {
  return Key(integerLiteral: lhs.rawValue + rhs.rawValue)
}

public func -(lhs: Key, rhs: Key) -> Key {
  return Key(integerLiteral: lhs.rawValue - rhs.rawValue)
}

public func *(lhs: Key, rhs: Int) -> Key {
  return Key(integerLiteral: lhs.rawValue * rhs)
}

public func /(lhs: Key, rhs: Int) -> Key {
  return Key(integerLiteral: lhs.rawValue / rhs)
}

public func ==(lhs: Key, rhs: Key) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

public func +(lhs: Pitch, rhs: Key) -> Pitch {
  return lhs + rhs.rawValue
}

public func -(lhs: Pitch, rhs: Key) -> Pitch {
  return lhs - rhs.rawValue
}

public func +(lhs: Key, rhs: Interval) -> Key {
  return Key(integerLiteral: lhs.rawValue + rhs.rawValue)
}

public func -(lhs: Key, rhs: Interval) -> Key {
  return Key(integerLiteral: lhs.rawValue - rhs.rawValue)
}

public func +(lhs: Key, rhs: Int) -> Key {
  return Key(integerLiteral: lhs.rawValue + rhs)
}

public func -(lhs: Key, rhs: Int) -> Key {
  return Key(integerLiteral: lhs.rawValue - rhs)
}

public struct Key: RawRepresentable, Codable, Equatable, ExpressibleByIntegerLiteral, CustomStringConvertible {

  public enum KeyType: Int, Codable, Equatable, CustomStringConvertible {
    case c = 0
    case d = 2
    case e = 4
    case f = 5
    case g = 7
    case a = 9
    case b = 11

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

  public var type: KeyType
  public var accident: Accident

  public init(type: KeyType, accident: Accident = .natural) {
    self.type = type
    self.accident = accident
  }

  public init?(midiNote: Int, isPreferredAccidentSharps: Bool = true) {
    let octave = (midiNote / 12) - 1
    let raw = midiNote - ((octave + 1) * 12)

    if let keyType = KeyType(rawValue: raw) { // Use natural
      self.type = keyType
      self.accident = .natural
    } else { // Use accidents
      if isPreferredAccidentSharps { // Use sharps
        if let keyType = KeyType(rawValue: raw - 1) { // Set sharp value
          self.type = keyType
          self.accident = .sharp
        } else {
          return nil
        }
      } else { // Use flats
        if let keyType = KeyType(rawValue: raw + 1) { // Set flat value
          self.type = keyType
          self.accident = .flat
        } else {
          return nil
        }
      }
    }
  }

  // MARK: RawRepresentable

  public typealias RawValue = Int

  public var rawValue: Int {
    return type.rawValue + accident.rawValue
  }

  public init?(rawValue: Key.RawValue) {
    guard let key = Key(midiNote: rawValue) else { return nil }
    self = key
  }

  // MARK: ExpressibleByIntegerLiteral

  public typealias IntegerLiteralType = Int

  public init(integerLiteral value: Key.IntegerLiteralType) {
    self = Key(rawValue: value) ?? Key(type: .c, accident: .natural)
  }

  // MARK: CustomStringConvertible

  public var description: String {
    return "\(type)\(accident)"
  }
}
