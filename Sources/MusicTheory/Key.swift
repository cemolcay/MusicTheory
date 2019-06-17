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

/// Checks if two `Key` types are equal in terms of their int values.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the equation value.
public func == (lhs: Key, rhs: Key) -> Bool {
  let lhsMod = (lhs.type.rawValue + lhs.accidental.rawValue) % 12
  let normalizedLhs = lhsMod < 0 ? (12 + lhsMod) : lhsMod

  let rhsMod = (rhs.type.rawValue + rhs.accidental.rawValue) % 12
  let normalizedRhs = rhsMod < 0 ? (12 + rhsMod) : rhsMod

  return normalizedLhs == normalizedRhs
}

/// Checks if two `Key` types are equal in terms of their type and accidental values.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns the equation value.
public func === (lhs: Key, rhs: Key) -> Bool {
  return lhs.type == rhs.type && lhs.accidental == rhs.accidental
}

/// Represents the keys that notes and pitches are based on.
public struct Key: Codable, Equatable, Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
  /// Base pitch of the key without accidentals. Accidentals will take account in the parent struct, `Key`. Integer values are based on C = 0 on western chromatic scale.
  public enum KeyType: Int, Codable, Equatable, Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
    /// C key.
    case c = 0
    /// D key.
    case d = 2
    /// E key.
    case e = 4
    /// F key.
    case f = 5
    /// G key.
    case g = 7
    /// A key.
    case a = 9
    /// B key.
    case b = 11

    /// Returns all members of the `KeyType`.
    public static let all: [KeyType] = [.c, .d, .e, .f, .g, .a, .b]

    /// Returns neighbour `KeyType` at `distance` away. Works on both directions.
    /// Use negative distance value for going on left direction, positive distance value for going on right direction.
    /// This function iterates the `KeyType.all` array circullar to find the target KeyType.
    ///
    /// - Parameter distance: Target KeyType distance. Zero is self.
    /// - Returns: Returns the neighbouring KeyType distance away.
    public func key(at distance: Int) -> KeyType {
      guard let index = KeyType.all.firstIndex(of: self)
      else { return self }

      let normalizedDistance = (distance + index) % KeyType.all.count
      let keyIndex = normalizedDistance < 0 ? (KeyType.all.count + normalizedDistance) : normalizedDistance
      return KeyType.all[keyIndex]
    }

    /// Calculates the distance of two `KeyType`s.
    ///
    /// - Parameter keyType: Target `KeyType` you want to compare.
    /// - Returns: Returns the integer value of distance in terms of their array index values.
    public func distance(from keyType: KeyType) -> Int {
      guard let index = KeyType.all.firstIndex(of: self),
        let targetIndex = KeyType.all.firstIndex(of: keyType)
      else { return 0 }
      return targetIndex - index
    }

    /// Calculates the octave difference for a neighbouring `KeyType` at given interval away higher or lower.
    ///
    /// - Parameters:
    ///   - interval: Interval you want to calculate octave difference.
    ///   - isHigher: You want to calculate interval higher or lower from current key.
    /// - Returns: Returns the octave difference for a given interval higher or lower.
    public func octaveDiff(for interval: Interval, isHigher: Bool) -> Int {
      var diff = 0
      var currentKey = self
      for _ in 0 ..< (interval.degree - 1) {
        let next = currentKey.key(at: isHigher ? 1 : -1)

        if isHigher {
          if currentKey == .b, next == .c {
            diff += 1
          }
        } else {
          if currentKey == .c, next == .b {
            diff -= 1
          }
        }

        currentKey = next
      }
      return diff
    }

    // MARK: ExpressibleByStringLiteral

    public typealias StringLiteralType = String

    /// Initilizes with a string.
    ///
    /// - Parameter value: String representation of type.
    public init(stringLiteral value: KeyType.StringLiteralType) {
      switch value.lowercased() {
      case "a": self = .a
      case "b": self = .b
      case "c": self = .c
      case "d": self = .d
      case "e": self = .e
      case "f": self = .f
      case "g": self = .g
      default: self = .c
      }
    }

    // MARK: CustomStringConvertible

    /// Returns the key notation.
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

  /// Type of the key.
  public var type: KeyType

  /// Accidental of the key.
  public var accidental: Accidental

  /// All notes in an octave with sharp notes.
  public static let keysWithSharps = [
    Key(type: .c, accidental: .natural),
    Key(type: .c, accidental: .sharp),
    Key(type: .d, accidental: .natural),
    Key(type: .d, accidental: .sharp),
    Key(type: .e, accidental: .natural),
    Key(type: .f, accidental: .natural),
    Key(type: .f, accidental: .sharp),
    Key(type: .g, accidental: .natural),
    Key(type: .g, accidental: .sharp),
    Key(type: .a, accidental: .natural),
    Key(type: .a, accidental: .sharp),
    Key(type: .b, accidental: .natural),
  ]

  /// All notes in an octave with flat notes.
  public static let keysWithFlats = [
    Key(type: .c, accidental: .natural),
    Key(type: .d, accidental: .flat),
    Key(type: .d, accidental: .natural),
    Key(type: .e, accidental: .flat),
    Key(type: .e, accidental: .natural),
    Key(type: .f, accidental: .natural),
    Key(type: .g, accidental: .flat),
    Key(type: .g, accidental: .natural),
    Key(type: .a, accidental: .flat),
    Key(type: .a, accidental: .natural),
    Key(type: .b, accidental: .flat),
    Key(type: .b, accidental: .natural),
  ]

  /// Initilizes the key with its type and accidental.
  ///
  /// - Parameters:
  ///   - type: The type of the key.
  ///   - accidental: Accidental of the key. Defaults natural.
  public init(type: KeyType, accidental: Accidental = .natural) {
    self.type = type
    self.accidental = accidental
  }

  // MARK: ExpressibleByStringLiteral

  public typealias StringLiteralType = String

  /// Initilizes with a string.
  ///
  /// - Parameter value: String representation of type.
  public init(stringLiteral value: Key.StringLiteralType) {
    var keyType = KeyType.c
    var accidental = Accidental.natural
    let pattern = "([A-Ga-g])([#♯♭b]*)"
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    if let regex = regex,
      let match = regex.firstMatch(in: value, options: [], range: NSRange(0 ..< value.count)),
      let keyTypeRange = Range(match.range(at: 1), in: value),
      let accidentalRange = Range(match.range(at: 2), in: value),
      match.numberOfRanges == 3 {
      // Set key type
      keyType = KeyType(stringLiteral: String(value[keyTypeRange]))
      // Set accidental
      accidental = Accidental(stringLiteral: String(value[accidentalRange]))
    }

    self = Key(type: keyType, accidental: accidental)
  }

  // MARK: CustomStringConvertible

  /// Returns the key notation with its type and accidental, if has any.
  public var description: String {
    return "\(type)\(accidental)"
  }
}
