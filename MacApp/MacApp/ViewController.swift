//
//  ViewController.swift
//  MacApp
//
//  Created by Cem Olcay on 12/01/2017.
//  Copyright © 2017 prototapp. All rights reserved.
//

import Cocoa
import AudioKit
import RainbowSwift
import MusicTheorySwift

class ViewController: NSViewController {
  let midi = AKMIDI()
  var notes = [Note]() {
    didSet {
      matchScale()
    }
  }

  func matchScale() {
    print(notes.map{$0.type})
    guard let first = notes.first else { return }
    let scaleTypes = ScaleType.all
    scales: for scaleType in scaleTypes {
      let scale = Scale(type: scaleType, key: first.type)
      let noteTypes = scale.noteTypes

      for note in notes.map({ $0.type }) {
        if noteTypes.contains(note) == false {
          continue scales
        }
      }

      print("scale match!")
      print(scale)
      break scales
    }
  }

  func startAK() {
    let osc = AKOscillator()
    AudioKit.output = osc
    AudioKit.start()

    midi.openInput()
    midi.addListener(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    startAK()
  }
}

extension ViewController: AKMIDIListener {

  func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
    let note = Note(midiNote: noteNumber)
    notes.append(note)
  }

  func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
    let note = Note(midiNote: noteNumber)
    if let index = notes.index(where: { $0 == note }) {
      notes.remove(at: index)
    }
  }
}
