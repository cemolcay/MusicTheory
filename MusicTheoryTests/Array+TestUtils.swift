//
//  Array+TestUtils.swift
//  MusicTheoryTests
//
//  Created by Cem Olcay on 30/12/2016.
//  Copyright © 2016 prototapp. All rights reserved.
//

import MusicTheory
import XCTest

// MARK: - [Pitch] Extension

// A function for checking pitche arrays exactly equal in terms of their pitches keys and octaves.
func === (lhs: [Pitch], rhs: [Pitch]) -> Bool {
  guard lhs.count == rhs.count else { return false }
  for i in 0 ..< lhs.count {
    if lhs[i] === rhs[i] {
      continue
    } else {
      return false
    }
  }
  return true
}
