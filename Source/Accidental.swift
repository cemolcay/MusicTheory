//
//  Enharmonics.swift
//  MusicTheory
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

/// Returns a new accidental by adding up two accidentals in the equation.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the sum of two accidentals.
public func + (lhs: Accidental, rhs: Accidental) -> Accidental {
  return Accidental(integerLiteral: lhs.rawValue + rhs.rawValue)
}

/// Returns a new accidental by substracting two accidentals in the equation.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the difference of two accidentals.
public func - (lhs: Accidental, rhs: Accidental) -> Accidental {
  return Accidental(integerLiteral: lhs.rawValue - rhs.rawValue)
}

/// Returns a new accidental by adding up an int to the accidental in the equation.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the sum of two accidentals.
public func + (lhs: Accidental, rhs: Int) -> Accidental {
  return Accidental(integerLiteral: lhs.rawValue + rhs)
}

/// Returns a new accidental by substracting an int from the accidental in the equation.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the difference of two accidentals.
public func - (lhs: Accidental, rhs: Int) -> Accidental {
  return Accidental(integerLiteral: lhs.rawValue - rhs)
}

/// Multiples an accidental with a multiplier.
///
/// - Parameters:
///   - lhs: Accidental you want to multiply.
///   - rhs: Multiplier.
/// - Returns: Returns a multiplied acceident.
public func * (lhs: Accidental, rhs: Int) -> Accidental {
  return Accidental(integerLiteral: lhs.rawValue * rhs)
}

/// Divides an accidental with a multiplier
///
/// - Parameters:
///   - lhs: Accidental you want to divide.
///   - rhs: Multiplier.
/// - Returns: Returns a divided accidental.
public func / (lhs: Accidental, rhs: Int) -> Accidental {
  return Accidental(integerLiteral: lhs.rawValue / rhs)
}

/// Checks if the two accidental is identical in terms of their halfstep values.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns true if two accidentalals is identical.
public func == (lhs: Accidental, rhs: Accidental) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

/// Checks if the two accidental is exactly identical.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns true if two accidentalals is identical.
public func === (lhs: Accidental, rhs: Accidental) -> Bool {
  switch (lhs, rhs) {
  case (.natural, .natural):
    return true
  case let (.sharps(a), .sharps(b)):
    return a == b
  case let (.flats(a), .flats(b)):
    return a == b
  default:
    return false
  }
}

/// The enum used for calculating values of the `Key`s and `Pitche`s.
public enum Accidental: Codable, Equatable, Hashable, RawRepresentable, ExpressibleByIntegerLiteral, ExpressibleByStringLiteral, CustomStringConvertible {
  /// No accidental.
  case natural
  /// Reduces the `Key` or `Pitch` value amount of halfsteps.
  case flats(amount: Int)
  /// Increases the `Key` or `Pitch` value amount of halfsteps.
  case sharps(amount: Int)

  /// Reduces the `Key` or `Pitch` value one halfstep below.
  public static let flat: Accidental = .flats(amount: 1)
  /// Increases the `Key` or `Pitch` value one halfstep above.
  public static let sharp: Accidental = .sharps(amount: 1)
  /// Reduces the `Key` or `Pitch` value amount two halfsteps below.
  public static let doubleFlat: Accidental = .flats(amount: 2)
  /// Increases the `Key` or `Pitch` value two halfsteps above.
  public static let doubleSharp: Accidental = .sharps(amount: 2)

  /// A flag for `description` function that determines if it should use double sharp and double flat symbols.
  /// It's useful to set it false where the fonts do not support that symbols. Defaults true.
  public static var shouldUseDoubleFlatAndDoubleSharpNotation = true

  // MARK: RawRepresentable

  public typealias RawValue = Int

  /// Value of the accidental in terms of halfsteps.
  public var rawValue: Int {
    switch self {
    case .natural:
      return 0
    case let .flats(amount):
      return -amount
    case let .sharps(amount):
      return amount
    }
  }

  /// Initilizes the accidental with an integer that represents the halfstep amount.
  ///
  /// - Parameter rawValue: Halfstep value of the accidental. Zero if natural, above zero if sharp, below zero if flat.
  public init?(rawValue: Accidental.RawValue) {
    if rawValue == 0 {
      self = .natural
    } else if rawValue > 0 {
      self = .sharps(amount: rawValue)
    } else {
      self = .flats(amount: -rawValue)
    }
  }

  // MARK: ExpressibleByIntegerLiteral

  public typealias IntegerLiteralType = Int

  /// Initilizes the accidental with an integer literal value.
  ///
  /// - Parameter value: Halfstep value of the accidental. Zero if natural, above zero if sharp, below zero if flat.
  public init(integerLiteral value: Accidental.IntegerLiteralType) {
    self = Accidental(rawValue: value) ?? .natural
  }

  // MARK: ExpressibleByStringLiteral

  public typealias StringLiteralType = String

  public init(stringLiteral value: Accidental.StringLiteralType) {
    var sum = 0
    for i in 0 ..< value.count {
      switch value[value.index(value.startIndex, offsetBy: i)] {
      case "#", "♯":
        sum += 1
      case "b", "♭":
        sum -= 1
      default:
        break
      }
    }
    self = Accidental(rawValue: sum) ?? .natural
  }

  // MARK: CustomStringConvertible

  /// Returns the notation string of the accidental.
  public var notation: String {
    if case .natural = self {
      return "♮"
    }
    return description
  }

  /// Returns the notation string of the accidental. Returns empty string if accidental is natural.
  public var description: String {
    switch self {
    case .natural:
      return ""
    case let .flats(amount):
      switch amount {
      case 0: return Accidental.natural.description
      case 1: return "♭"
      case 2 where Accidental.shouldUseDoubleFlatAndDoubleSharpNotation: return "𝄫"
      default: return amount > 0 ? (0 ..< amount).map({ _ in Accidental.flats(amount: 1).description }).joined() : ""
      }
    case let .sharps(amount):
      switch amount {
      case 0: return Accidental.natural.description
      case 1: return "♯"
      case 2 where Accidental.shouldUseDoubleFlatAndDoubleSharpNotation: return "𝄪"
      default: return amount > 0 ? (0 ..< amount).map({ _ in Accidental.sharps(amount: 1).description }).joined() : ""
      }
    }
  }
}
