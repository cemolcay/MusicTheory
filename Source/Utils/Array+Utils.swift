//
//  Array+Utils.swift
//  MusicTheory
//
//  Created by Sihao Lu on 10/28/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

// MARK: - Extensions

extension Array {
  var shifted: Array {
    guard let firstElement = first else { return self }
    var arr = self
    arr.removeFirst()
    arr.append(firstElement)
    return arr
  }
}
