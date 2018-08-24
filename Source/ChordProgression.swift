//
//  ChordProgression.swift
//  ChordBud
//
//  Created by Cem Olcay on 2.10.2017.
//  Copyright © 2017 cemolcay. All rights reserved.
//

import Foundation

/// A struct for storing custom progressions.
public struct CustomChordProgression: Codable {
  /// Name of the progression.
  public var name: String
  /// Chord progression with `ChordProgresion.custom` type.
  public var progression: ChordProgression
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
public enum ChordProgression: CustomStringConvertible, Codable {
  /// All nodes from first to seventh.
  case allNodes
  /// I - V - VI - IV progression.
  case i_v_vi_iv
  /// VI - V - IV - V progression.
  case vi_v_iv_v
  /// I - VI - IV - V progression.
  case i_vi_iv_v
  /// I - IV - VI - V progression.
  case i_iv_vi_v
  /// I - V - IV - V progression.
  case i_v_iv_v
  /// VI - II - V - I progression.
  case vi_ii_v_i
  /// I - VI - II - V progression.
  case i_vi_ii_v
  /// I - IV - II - V progression.
  case i_iv_ii_v
  /// VI - IV - I - V progression.
  case vi_iv_i_v
  /// I - VI - III - VII progression.
  case i_vi_iii_vii
  /// VI - V - IV - III progression.
  case vi_v_iv_iii
  /// I - V - VI - III - IV - I - IV - V progression.
  case i_v_vi_iii_iv_i_iv_v
  /// IV - I - V - IV progression.
  case iv_i_v_iv
  /// I - II - VI - IV progression.
  case i_ii_vi_iv
  /// I - III - VI - IV progression.
  case i_iii_vi_iv
  /// I - V - II - IV progression.
  case i_v_ii_iv
  /// II - IV - I - V progression.
  case ii_iv_i_v﻿
  /// Custom progression with any node sequence.
	case custom([ChordProgressionNode])

  /// Initilizes the chord progression with its nodes.
  ///
  /// - Parameter nodes: Nodes of the chord progression.
  public init(nodes: [ChordProgressionNode]) {
    if let progression = ChordProgression.all.filter({ $0.nodes == nodes }).first {
      self = progression
    } else {
      self = .custom(nodes)
    }
  }

  /// Returns all nodes of the progression.
	public var nodes: [ChordProgressionNode] {
		switch self {
    case .allNodes:
      return [.i, .ii, .iii, .iv, .v, .vi, .vii]
    case .i_v_vi_iv:
      return [.i, .v, .vi, .iv]
    case .vi_v_iv_v:
      return [.vi, .v, .iv, .v]
    case .i_vi_iv_v:
      return [.i, .vi, .iv, .v]
    case .i_iv_vi_v:
      return [.i, .iv, .vi, .v]
    case .i_v_iv_v:
      return [.i, .v, .iv, .v]
    case .vi_ii_v_i:
      return [.v, .ii, .v, .i]
    case .i_vi_ii_v:
      return [.i, .vi, .ii, .v]
    case .i_iv_ii_v:
      return [.i, .iv, .ii, .v]
    case .vi_iv_i_v:
      return [.vi, .iv, .i, .v]
    case .i_vi_iii_vii:
      return [.i, .vi, .iii, .vii]
    case .vi_v_iv_iii:
      return [.vi, .v, .vi, .iii]
    case .i_v_vi_iii_iv_i_iv_v:
      return [.i, .v, .vi, .iii, .iv, .i, .iv, .v]
    case .iv_i_v_iv:
      return [.iv, .i, .v, .iv]
    case .i_ii_vi_iv:
      return [.i, .ii, .vi, .iv]
    case .i_iii_vi_iv:
      return [.i, .iii, .vi, .iv]
    case .i_v_ii_iv:
      return [.i, .v, .ii, .iv]
    case .ii_iv_i_v﻿:
      return [.ii, .iv, .i, .v]
    case .custom(let nodes):
			return nodes
		}
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
      .ii_iv_i_v﻿,
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
    if case .allNodes = self {
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
}
