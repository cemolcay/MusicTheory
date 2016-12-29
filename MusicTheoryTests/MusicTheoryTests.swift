//
//  MusicTheoryTests.swift
//  MusicTheoryTests
//
//  Created by Cem Olcay on 30/12/2016.
//  Copyright © 2016 prototapp. All rights reserved.
//

import XCTest

class MusicTheoryTests: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
}

extension MusicTheoryTests {

  func testHalfstep() {
    let note: Note = .c
    XCTAssert(note.nextHalf == Note.dFlat)
  }

  func testInterval() {
    let note: Note = .c
    XCTAssert(note.next(interval: .P8) == note)
    XCTAssert(note.next(interval: .M2) == .d)
    XCTAssert(note.next(interval: .m2) == .dFlat)
  }
}
