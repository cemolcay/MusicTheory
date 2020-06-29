//
//  HarmonicFunctions.swift
//  
//
//  Created by Cem Olcay on 29/06/2020.
//  Copyright © 2017 cemolcay. All rights reserved.
//

import Foundation

/// Represents harmonic functions in music theory.
public enum HarmonicFunctions: Int, Codable, CaseIterable {
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
  static let tonicProlongationFunctions: [HarmonicFunctions] = [.mediant, .submediant]

  /// Represents the pre dominant functions.
  static let predominantFunctions: [HarmonicFunctions] = [.submediant, .supertonic]

  /// Represents the dominant functions
  static let dominantFunctions: [HarmonicFunctions] = [.dominant, .leading]

  /// Represents the possible direction from any harmonic function.
  public var direction: [HarmonicFunctions] {
    switch self {
    case .tonic:
      return HarmonicFunctions.allCases
    case .supertonic:
      return HarmonicFunctions.dominantFunctions
    case .mediant:
      return HarmonicFunctions.predominantFunctions + [.submediant]
    case .subdominant:
      return [.supertonic] + HarmonicFunctions.dominantFunctions
    case .dominant:
      return [.tonic]
    case .submediant:
      return HarmonicFunctions.predominantFunctions
    case .leading:
      return [.tonic, .supertonic, .dominant]
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
