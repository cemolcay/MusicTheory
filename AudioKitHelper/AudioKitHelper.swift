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
  public var output: AKOscillatorBank
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
    let randomNote = scale.notes.randomElement()
    return randomNote.midiKey(octave: octave)
  }

  public func playRandom() {
    super.play(midi: generateSound())
  }
}

public class MTChordOscillator {
  public var output: AKMixer?
  public var octave: Int = 4
  private var banks: [MTOscillator] = []
  private var chord: Chord? { didSet { chordDidChange() }}

  private func chordDidChange() {
    banks = chord?.notes.map({ _ in MTOscillator() }) ?? []
  }

  public func play(chord: Chord) {
    self.chord = chord
    for i in 0..<banks.count {
      banks[i].play(midi: chord.notes[i].midiKey(octave: octave))
    }
  }
}
