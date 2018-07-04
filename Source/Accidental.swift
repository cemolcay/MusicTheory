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
public func +(lhs: Accidental, rhs: Accidental) -> Accidental {
  return Accidental(integerLiteral: lhs.rawValue + rhs.rawValue)
}

/// Returns a new accidental by substracting two accidentals in the equation.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the difference of two accidentals.
public func -(lhs: Accidental, rhs: Accidental) -> Accidental {
  return Accidental(integerLiteral: lhs.rawValue - rhs.rawValue)
}

/// Returns a new accidental by adding up an int to the accidental in the equation.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the sum of two accidentals.
public func +(lhs: Accidental, rhs: Int) -> Accidental {
  return Accidental(integerLiteral: lhs.rawValue + rhs)
}

/// Returns a new accidental by substracting an int from the accidental in the equation.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the difference of two accidentals.
public func -(lhs: Accidental, rhs: Int) -> Accidental {
  return Accidental(integerLiteral: lhs.rawValue - rhs)
}

/// Multiples an accidental with a multiplier.
///
/// - Parameters:
///   - lhs: Accidental you want to multiply.
///   - rhs: Multiplier.
/// - Returns: Returns a multiplied acceident.
public func *(lhs: Accidental, rhs: Int) -> Accidental {
  return Accidental(integerLiteral: lhs.rawValue * rhs)
}

/// Divides an accidental with a multiplier
///
/// - Parameters:
///   - lhs: Accidental you want to divide.
///   - rhs: Multiplier.
/// - Returns: Returns a divided accidental.
public func /(lhs: Accidental, rhs: Int) -> Accidental {
  return Accidental(integerLiteral: lhs.rawValue / rhs)
}

/// Checks if the two accidental is identical in terms of their halfstep values.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns true if two accidentalals is identical.
public func ==(lhs: Accidental, rhs: Accidental) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

/// Checks if the two accidental is exactly identical.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns true if two accidentalals is identical.
public func ===(lhs: Accidental, rhs: Accidental) -> Bool {
  switch (lhs, rhs) {
  case (.natural, .natural):
    return true
  case (.sharps(let a), .sharps(let b)):
    return a == b
  case (.flats(let a), .flats(let b)):
    return a == b
  default:
    return false
  }
}

/// The enum used for calculating values of the `Key`s and `Pitche`s.
public enum Accidental: Codable, Equatable, Hashable, RawRepresentable, ExpressibleByIntegerLiteral, CustomStringConvertible {
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

  // MARK: RawRepresentable

  public typealias RawValue = Int

  /// Value of the accidental in terms of halfsteps.
  public var rawValue: Int {
    switch self {
    case .natural:
      return 0
    case .flats(let amount):
      return -amount
    case .sharps(let amount):
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
    case .flats(let amount):
      switch amount {
      case 0: return Accidental.natural.description
      case 1: return "♭"
      case 2: return "𝄫"
      default: return amount > 0 ? (0..<amount).map({ _ in Accidental.flats(amount: 1).description }).joined() : ""
      }
    case .sharps(let amount):
      switch amount {
      case 0: return Accidental.natural.description
      case 1: return "♯"
      case 2: return "𝄪"
      default: return amount > 0 ? (0..<amount).map({ _ in Accidental.sharps(amount: 1).description }).joined() : ""
      }
    }
  }
}
