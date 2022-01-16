//
//  HarmonicFunctions.swift
//  
//
//  Created by Cem Olcay on 29/06/2020.
//  Copyright © 2017 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//


import Foundation

/// Represents harmonic functions in music theory.
public enum HarmonicFunctionType: Int, Codable, CaseIterable {
  /// First interval/chord. I in roman numeral.
  case tonic
  /// Second interval/chord. II in roman numeral.
  case supertonic
  /// Third interval/chord. III in roman numeral.
  case mediant
  /// Fourth interval/chord. IV in roman numeral.
  case subdominant
  /// Fifth interval/chord. V in roman numeral.
  case dominant
  /// Sixth interval/chord. VI in roman numeral.
  case submediant
  /// Seventh interval/chord. VII in roman numeral.
  case leading

  /// Represents tonic prolongation functions.
  public static let tonicProlongationFunctions: [HarmonicFunctionType] = [.mediant, .submediant]

  /// Represents the pre dominant functions.
  public static let predominantFunctions: [HarmonicFunctionType] = [.supertonic, .submediant]

  /// Represents the dominant functions
  public static let dominantFunctions: [HarmonicFunctionType] = [.dominant, .leading]

  /// Represents the possible direction from any harmonic function.
  public var direction: [HarmonicFunctionType] {
    switch self {
    case .tonic:
      return HarmonicFunctionType.allCases
    case .supertonic:
      return HarmonicFunctionType.dominantFunctions
    case .mediant:
      return HarmonicFunctionType.predominantFunctions
    case .subdominant:
      return [.supertonic] + HarmonicFunctionType.dominantFunctions
    case .dominant:
      return [.tonic]
    case .submediant:
      return HarmonicFunctionType.predominantFunctions
    case .leading:
      return [.tonic, .dominant, .submediant]
    }
  }

  /// Returns the roman numeral string representation.
  public var romanNumeral: String {
    switch self {
    case .tonic: return "I"
    case .supertonic: return "II"
    case .mediant: return "III"
    case .subdominant: return "IV"
    case .dominant: return "V"
    case .submediant: return "VI"
    case .leading: return "VII"
    }
  }
}

/// A struct for creating harmonic functions from a `Scale`.
public struct HarmonicFunctions {
  /// Scale of the harmonic function.
  public let scale: Scale

  /// Initilize the harmonic functions for a scale.
  /// - Parameter scale: The scale you want to create harmonic functions from.
  public init(scale: Scale) {
    self.scale = scale
  }

  /// Returns the key of the scale's harmonic function.
  /// - Parameter type: The harmonic function you want to get from the scale.
  /// - Returns: Returns the key representing the harmonic function you want to get, if the scale has it.
  public func harmonicFunction(for type: HarmonicFunctionType) -> Key? {
    let keys = scale.keys
    guard keys.count >= type.rawValue else { return nil }
    return keys[type.rawValue]
  }
}
