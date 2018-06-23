//
//  NewInterval.swift
//  MusicTheory
//
//  Created by Cem Olcay on 22.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//

import Foundation

public func +(lhs: Key, rhs: NewInterval) -> Key {
  switch rhs.type {
  case .perfect:
    return lhs
  case .major:
    return lhs
  case .minor:
    return lhs
  case .diminished:
    return lhs
  case .agumented:
    return lhs
  }
}

public func -(lhs: Key, rhs: NewInterval) -> Key {
  switch rhs.type {
  case .perfect:
    return lhs
  case .major:
    return lhs
  case .minor:
    return lhs
  case .diminished:
    return lhs
  case .agumented:
    return lhs
  }
}

public func ==(lhs: NewInterval, rhs: NewInterval) -> Bool {
  return lhs.type == rhs.type && lhs.degree == rhs.degree
}

public struct NewInterval: Codable, Equatable, CustomStringConvertible {

  public enum IntervalType: Int, Codable, Equatable, CustomStringConvertible {
    case diminished = -1
    case perfect = 0
    case minor = 1
    case major = 2
    case agumented = 3

    // MARK: CustomStringConvertible

    public var description: String {
      switch self {
      case .diminished: return "d"
      case .perfect: return "P"
      case .minor: return "m"
      case .major: return "M"
      case .agumented: return "A"
      }
    }
  }

  public var type: IntervalType
  public var degree: Int

  public init(type: IntervalType, degree: Int) {
    self.type = type
    self.degree = degree
  }

  public static let P1 = NewInterval(type: .perfect, degree: 1)
  public static let P4 = NewInterval(type: .perfect, degree: 4)
  public static let P5 = NewInterval(type: .perfect, degree: 5)
  public static let P8 = NewInterval(type: .perfect, degree: 8)

  public static let m2 = NewInterval(type: .minor, degree: 2)
  public static let m3 = NewInterval(type: .minor, degree: 3)
  public static let m6 = NewInterval(type: .minor, degree: 6)
  public static let m7 = NewInterval(type: .minor, degree: 7)

  public static let M2 = NewInterval(type: .major, degree: 2)
  public static let M3 = NewInterval(type: .major, degree: 3)
  public static let M6 = NewInterval(type: .major, degree: 6)
  public static let M7 = NewInterval(type: .major, degree: 7)

  public static let d2 = NewInterval(type: .diminished, degree: 2)
  public static let d3 = NewInterval(type: .diminished, degree: 3)
  public static let d4 = NewInterval(type: .diminished, degree: 4)
  public static let d5 = NewInterval(type: .diminished, degree: 5)
  public static let d6 = NewInterval(type: .diminished, degree: 6)
  public static let d7 = NewInterval(type: .diminished, degree: 7)
  public static let d8 = NewInterval(type: .diminished, degree: 8)

  public static let A2 = NewInterval(type: .agumented, degree: 2)
  public static let A3 = NewInterval(type: .agumented, degree: 3)
  public static let A4 = NewInterval(type: .agumented, degree: 4)
  public static let A5 = NewInterval(type: .agumented, degree: 5)
  public static let A6 = NewInterval(type: .agumented, degree: 6)
  public static let A7 = NewInterval(type: .agumented, degree: 7)
  public static let A8 = NewInterval(type: .agumented, degree: 8)

  // MARK: CustomStringConvertible

  public var description: String {
    return "\(type)\(degree)"
  }
}
