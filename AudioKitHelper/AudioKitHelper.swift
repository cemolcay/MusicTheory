//
//  AudioKitHelper.swift
//  MusicTheory
//
//  Created by Cem Olcay on 30/12/2016.
//  Copyright © 2016 prototapp. All rights reserved.
//

import UIKit
import AudioKit
import MusicTheory

public class MTOscillator {
  public private(set) var output: AKOscillatorBank
  private var playinSound: Int?

  public init() {
    output = AKOscillatorBank()
  }

  public func play(midi: Int) {
    if let sound = playinSound {
      output.stop(noteNumber: sound)
    }

    playinSound = midi
    guard let sound = playinSound else { return }
    output.play(noteNumber: sound, velocity: 60)
  }
}

public class MTScaleOscillator: MTOscillator {
  public var scale: Scale
  public var octave: Int

  public init(scale: Scale, octave: Int) {
    self.scale = scale
    self.octave = octave
    super.init()
  }

  public func generateSound() -> Int {
    let notes = scale.notes(octave: octave)
    return notes.randomElement().midiNote
  }

  public func playRandom() {
    super.play(midi: generateSound())
  }
}

public class MTChordOscillator {
  public var octave: Int = 4
  public private(set) var banks: [MTOscillator] = []
  public private(set) var output: AKMixer = AKMixer()
  private var chord: Chord

  public init(chord: Chord) {
    self.chord = chord
    banks = chord.notes(octave: octave).map({ _ in MTOscillator() })
    output = AKMixer()
    banks.forEach({ output.connect($0.output) })
  }

  public func play() {
    let notes = chord.notes(octave: octave)
    for i in 0..<banks.count {
      banks[i].play(midi: notes[i].midiNote)
    }
  }
}
