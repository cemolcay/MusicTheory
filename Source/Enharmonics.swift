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

/// Returns a new accident by adding up two accidents in the equation.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the sum of two accidents.
public func +(lhs: Accident, rhs: Accident) -> Accident {
  return Accident(integerLiteral: lhs.rawValue + rhs.rawValue)
}

/// Returns a new accident by substracting two accidents in the equation.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the difference of two accidents.
public func -(lhs: Accident, rhs: Accident) -> Accident {
  return Accident(integerLiteral: lhs.rawValue - rhs.rawValue)
}

/// Multiples an accident with a multiplier.
///
/// - Parameters:
///   - lhs: Accident you want to multiply.
///   - rhs: Multiplier.
/// - Returns: Returns a multiplied acceident.
public func *(lhs: Accident, rhs: Int) -> Accident {
  return Accident(integerLiteral: lhs.rawValue * rhs)
}

/// Divides an accident with a multiplier
///
/// - Parameters:
///   - lhs: Accident you want to divide.
///   - rhs: Multiplier.
/// - Returns: Returns a divided accident.
public func /(lhs: Accident, rhs: Int) -> Accident {
  return Accident(integerLiteral: lhs.rawValue / rhs)
}

/// Checks if the two accident is identical in terms of their halfstep values.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns true if two accidentals is identical.
public func ==(lhs: Accident, rhs: Accident) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

/// Adds an accident value to a pitch.
///
/// - Parameters:
///   - lhs: The pitch you want to add an accident value.
///   - rhs: Accident value you want to add to pitch.
/// - Returns: Returns the pitch value.
public func +(lhs: Pitch, rhs: Accident) -> Pitch {
  return lhs + rhs.rawValue
}

/// Substracts an accident value from a pitch.
///
/// - Parameters:
///   - lhs: Pitch you want to substract an accident value.
///   - rhs: Accident value you want to substact from the pitch.
/// - Returns: Returns the pitch value.
public func -(lhs: Pitch, rhs: Accident) -> Pitch {
  return lhs - rhs.rawValue
}

/// The enum used for calculating values of the `Key`s and `Pitche`s.
public enum Accident: Codable, Equatable, RawRepresentable, ExpressibleByIntegerLiteral, CustomStringConvertible {
  /// No accident.
  case natural
  /// Reduces the `Key` or `Pitch` value amount of halfsteps.
  case flats(amount: Int)
  /// Increases the `Key` or `Pitch` value amount of halfsteps.
  case sharps(amount: Int)

  /// Reduces the `Key` or `Pitch` value one halfstep below.
  public static let flat: Accident = .flats(amount: 1)
  /// Increases the `Key` or `Pitch` value one halfstep above.
  public static let sharp: Accident = .sharps(amount: 1)
  /// Reduces the `Key` or `Pitch` value amount two halfsteps below.
  public static let doubleFlat: Accident = .flats(amount: 2)
  /// Increases the `Key` or `Pitch` value two halfsteps above.
  public static let doubleSharp: Accident = .sharps(amount: 2)

  // MARK: RawRepresentable

  public typealias RawValue = Int

  /// Value of the accident in terms of halfsteps.
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

  /// Initilizes the accident with an integer that represents the halfstep amount.
  ///
  /// - Parameter rawValue: Halfstep value of the accident. Zero if natural, above zero if sharp, below zero if flat.
  public init?(rawValue: Accident.RawValue) {
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

  /// Initilizes the accident with an integer literal value.
  ///
  /// - Parameter value: Halfstep value of the accident. Zero if natural, above zero if sharp, below zero if flat.
  public init(integerLiteral value: Accident.IntegerLiteralType) {
    self = Accident(rawValue: value) ?? .natural
  }

  // MARK: CustomStringConvertible

  /// Returns the notation string of the accident.
  public var notation: String {
    if case .natural = self {
      return "♮"
    }
    return description
  }

  /// Returns the notation string of the accident. Returns empty string if accident is natural.
  public var description: String {
    switch self {
    case .natural:
      return ""
    case .flats(let amount):
      switch amount {
      case 0: return Accident.natural.description
      case 1: return "♭"
      case 2: return "𝄫"
      default: return amount > 0 ? (0..<amount).map({ _ in Accident.flats(amount: 1).description }).joined() : ""
      }
    case .sharps(let amount):
      switch amount {
      case 0: return Accident.natural.description
      case 1: return "♯"
      case 2: return "𝄪"
      default: return amount > 0 ? (0..<amount).map({ _ in Accident.sharps(amount: 1).description }).joined() : ""
      }
    }
  }
}
