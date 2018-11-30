//
//  Clef.swift
//  MusicTheory
//
//  Created by Sihao Lu on 11/9/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

public struct Clef {
  public static let treble = Clef(middleCPosition: 0)
  public static let bass = Clef(middleCPosition: 12)
  public static let alto = Clef(middleCPosition: 6)
  public static let tenor = Clef.treble.clef(byMovingUpOctaves: -1)

  public let middleCPosition: Int

  /// Initialize a clef with a middle C position.
  ///
  /// - Parameter middleCPosition: The position of middle C (C4) for the clef. The bottom line with one ledger lines is position 0, corresponding to C4 on a treble clef.
  public init(middleCPosition: Int) {
    self.middleCPosition = middleCPosition
  }

  /// Returns a clef by moving the position of the current clef up by a provided amount.
  /// Use a negative number to move the position down.
  ///
  /// - Parameter positionDiff: The difference of middle C position between the new clef and the current clef.
  public func clef(byMovingUpPositionBy positionDiff: Int) -> Clef {
    return Clef(middleCPosition: middleCPosition + positionDiff)
  }

  /// Returns a clef by moving the position of the current clef up by a provided number of octaves.
  /// Use a negative number to move the position down by a provided number of octaves.
  ///
  /// - Parameter positionDiff: The difference in number of octaves between the new clef and the current clef.
  public func clef(byMovingUpOctaves octaves: Int) -> Clef {
    return Clef(middleCPosition: middleCPosition - octaves * 7)
  }

  public func isLine(forPitch pitch: Pitch) -> Bool {
    return position(forPitch: pitch) % 2 == 0
  }

  public func isSpace(forPitch pitch: Pitch) -> Bool {
    return !isLine(forPitch: pitch)
  }

  public func requiresLedgerLine(forPitch pitch: Pitch) -> Bool {
    return position(forPitch: pitch) < 1 || position(forPitch: pitch) > 11
  }

  /// Returns number of steps up from the place middle C (C4) appears to be on a treble clef for a given pitch.
  ///
  /// - Parameter pitch: The pitch.
  /// - Returns: number of steps up from the place middle C (C4) appears to be on a treble clef.
  public func position(forPitch pitch: Pitch) -> Int {
    return Key.KeyType.all.firstIndex(of: pitch.key.type)! + (pitch.octave - 4) * 7 + middleCPosition
  }
}
