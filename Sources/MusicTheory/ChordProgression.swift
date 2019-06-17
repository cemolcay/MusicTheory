//
//  ChordProgression.swift
//  ChordBud
//
//  Created by Cem Olcay on 2.10.2017.
//  Copyright © 2017 cemolcay. All rights reserved.
//

import Foundation

/// A struct for storing custom progressions.
public struct CustomChordProgression: Codable, CustomStringConvertible {
  /// Name of the progression.
  public var name: String
  /// Chord progression with `ChordProgresion.custom` type.
  public var progression: ChordProgression

  // MARK: CustomStringConvertible

  public var description: String {
    return name
  }
}

/// A node of chord progression in intervals.
public enum ChordProgressionNode: Int, CustomStringConvertible, Codable {
  /// First-degree node
  case i
  /// Second-degree node
  case ii
  /// Third-degree node
  case iii
  /// Fourth-degree node
  case iv
  /// Fifth-degree node
  case v
  /// Sixth-degree node
  case vi
  /// Seventh-degree node
  case vii

  /// Meaningful next nodes, useful for a recommendation engine.
  public var next: [ChordProgressionNode] {
    switch self {
    case .i:
      return [.i, .ii, .iii, .iv, .v, .vi, .vii]
    case .ii:
      return [.v, .iii, .vi, .vii]
    case .iii:
      return [.ii, .iv, .vi]
    case .iv:
      return [.i, .iii, .v, .vii]
    case .v:
      return [.i]
    case .vi:
      return [.ii, .iv]
    case .vii:
      return [.vi]
    }
  }

  /// All nodes.
  public static let all: [ChordProgressionNode] = [.i, .ii, .iii, .iv, .v, .vi, .vii]

  // MARK: CustomStringConvertible

  /// Returns roman numeric string of the node.
  public var description: String {
    switch self {
    case .i: return "I"
    case .ii: return "II"
    case .iii: return "III"
    case .iv: return "IV"
    case .v: return "V"
    case .vi: return "VI"
    case .vii: return "VII"
    }
  }
}

/// Chord progression enum that you can create hard-coded and custom progressions.
public struct ChordProgression: CustomStringConvertible, Codable, Equatable {
  /// All nodes from first to seventh.
  public static let allNodes = ChordProgression(nodes: [.i, .ii, .iii, .iv, .v, .vi, .vii])
  /// I - V - VI - IV progression.
  public static let i_v_vi_iv = ChordProgression(nodes: [.i, .v, .vi, .iv])
  /// VI - V - IV - V progression.
  public static let vi_v_iv_v = ChordProgression(nodes: [.vi, .v, .iv, .v])
  /// I - VI - IV - V progression.
  public static let i_vi_iv_v = ChordProgression(nodes: [.i, .vi, .iv, .v])
  /// I - IV - VI - V progression.
  public static let i_iv_vi_v = ChordProgression(nodes: [.i, .iv, .vi, .v])
  /// I - V - IV - V progression.
  public static let i_v_iv_v = ChordProgression(nodes: [.i, .v, .iv, .v])
  /// VI - II - V - I progression.
  public static let vi_ii_v_i = ChordProgression(nodes: [.vi, .ii, .v, .i])
  /// I - VI - II - V progression.
  public static let i_vi_ii_v = ChordProgression(nodes: [.i, .vi, .ii, .v])
  /// I - IV - II - V progression.
  public static let i_iv_ii_v = ChordProgression(nodes: [.i, .iv, .ii, .v])
  /// VI - IV - I - V progression.
  public static let vi_iv_i_v = ChordProgression(nodes: [.vi, .iv, .i, .v])
  /// I - VI - III - VII progression.
  public static let i_vi_iii_vii = ChordProgression(nodes: [.i, .vi, .iii, .vii])
  /// VI - V - IV - III progression.
  public static let vi_v_iv_iii = ChordProgression(nodes: [.vi, .v, .iv, .iii])
  /// I - V - VI - III - IV - I - IV - V progression.
  public static let i_v_vi_iii_iv_i_iv_v = ChordProgression(nodes: [.i, .v, .vi, .iii, .iv, .i, .iv, .v])
  /// IV - I - V - IV progression.
  public static let iv_i_v_iv = ChordProgression(nodes: [.iv, .i, .v, .iv])
  /// I - II - VI - IV progression.
  public static let i_ii_vi_iv = ChordProgression(nodes: [.i, .ii, .vi, .iv])
  /// I - III - VI - IV progression.
  public static let i_iii_vi_iv = ChordProgression(nodes: [.i, .iii, .vi, .iv])
  /// I - V - II - IV progression.
  public static let i_v_ii_iv = ChordProgression(nodes: [.i, .v, .ii, .iv])
  /// II - IV - I - V progression.
  public static let ii_iv_i_v = ChordProgression(nodes: [.ii, .iv, .i, .v])

  public let nodes: [ChordProgressionNode]

  /// Initilizes the chord progression with its nodes.
  ///
  /// - Parameter nodes: Nodes of the chord progression.
  public init(nodes: [ChordProgressionNode]) {
    self.nodes = nodes
  }

  /// All hard-coded chord progressions.
  public static var all: [ChordProgression] {
    return [
      .allNodes,
      .i_v_vi_iv,
      .vi_v_iv_v,
      .i_vi_iv_v,
      .i_iv_vi_v,
      .i_v_iv_v,
      .vi_ii_v_i,
      .i_vi_ii_v,
      .i_iv_ii_v,
      .vi_iv_i_v,
      .i_vi_iii_vii,
      .vi_v_iv_iii,
      .i_v_vi_iii_iv_i_iv_v,
      .iv_i_v_iv,
      .i_ii_vi_iv,
      .i_iii_vi_iv,
      .i_v_ii_iv,
      .ii_iv_i_v,
    ]
  }

  /// Generates chord progression for a `Scale` with `Scale.HarmonicField` and optionally inverted chords.
  ///
  /// - Parameters:
  ///   - scale: Scale of the chords going to be generated.
  ///   - harmonicField: Harmonic field of the chords going to be generated.
  ///   - inversion: Inversion of the chords going to be generated.
  /// - Returns: Returns all possible chords for a scale. Returns nil if the chord is not generated for particular `ChordProgressionNode`.
  public func chords(for scale: Scale, harmonicField: Scale.HarmonicField, inversion: Int = 0) -> [Chord?] {
    let indices = nodes.map({ $0.rawValue })
    let harmonics = scale.harmonicField(for: harmonicField, inversion: inversion)
    var chords = [Chord?]()
    for index in indices {
      if index < harmonics.count {
        chords.append(harmonics[index])
      }
    }
    return chords
  }

  // MARK: CustomStringConvertible

  /// Returns the chord progression name.
  public var description: String {
    if self == ChordProgression.allNodes {
      return "All"
    }
    return nodes.map({ "\($0)" }).joined(separator: " - ")
  }

  // MARK: Codable

  /// Codable protocol `CodingKey`s
  ///
  /// - nodes: Coding key for the nodes.
  private enum CodingKeys: String, CodingKey {
    case nodes
  }

  /// Initilizes chord progression with a `Decoder`.
  ///
  /// - Parameter decoder: The decoder.
  /// - Throws: Throws error if can not decodes.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let nodes = try values.decode([ChordProgressionNode].self, forKey: .nodes)
    self = ChordProgression(nodes: nodes)
  }

  /// Encodes the chord progression.
  ///
  /// - Parameter encoder: The encoder.
  /// - Throws: Throws error if can not encodes.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(nodes, forKey: .nodes)
  }

  // MARK: Equatable

  public static func == (lhs: ChordProgression, rhs: ChordProgression) -> Bool {
    return lhs.nodes == rhs.nodes
  }
}
