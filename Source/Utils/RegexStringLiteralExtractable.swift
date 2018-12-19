//
//  RegexStringLiteralExtractable.swift
//  MusicTheory
//
//  Created by Ben Lu on 12/10/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

import Foundation

public protocol RegexStringLiteralExtractable: ExpressibleByStringLiteral where StringLiteralType == String {
  static var pattern: String { get }
  init(regexMatches: [String])
}

public extension RegexStringLiteralExtractable {
  init(stringLiteral value: Self.StringLiteralType) {
    guard let regex = try? NSRegularExpression(pattern: Self.pattern, options: []),
      let match = regex.firstMatch(in: value, options: [], range: NSRange(0 ..< value.count)) else {
      fatalError("Fail to find a pattern")
    }

    let matches: [String] = (0 ..< match.numberOfRanges).compactMap { index in
      if let range = Range(match.range(at: index), in: value) {
        return String(value[range])
      } else {
        return nil
      }
    }
    self.init(regexMatches: matches)
  }
}
