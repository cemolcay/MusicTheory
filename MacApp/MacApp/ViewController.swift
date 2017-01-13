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
  let osc = AKOscillatorBank()

  var notes = [Note]() {
    didSet {
//      matchScale()
      matchChord()
    }
  }

  func matchScale() {
    print(notes.map{$0.type})
    guard notes.count > 2 else { return }

    let scaleTypes = ScaleType.all
    scales: for scaleType in scaleTypes {
      notes: for note in NoteType.all {
        let scale = Scale(type: scaleType, key: note)
        let noteTypes = scale.noteTypes

        for note in notes.map({ $0.type }) {
          if !noteTypes.contains(note) {
            continue notes
          }
        }

        print(scale)
      }
    }
  }

  func matchChord() {
    print(notes.map({ $0.type }))
    guard notes.count > 2 else { return }

    let chordTypes = ChordType.all
    chords: for chordType in chordTypes {
      notes: for note in NoteType.all {
        let chord = Chord(type: chordType, key: note)
        let noteTypes = chord.noteTypes
        guard noteTypes.count == notes.count else { continue notes }

        for note in notes.map({ $0.type }) {
          if !noteTypes.contains(note) {
            continue notes
          }
        }

        print(chord)
      }
    }
  }

  func startAK() {
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
    osc.play(noteNumber: noteNumber, velocity: velocity )
  }

  func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
    let note = Note(midiNote: noteNumber)
    if let index = notes.index(where: { $0 == note }) {
      notes.remove(at: index)
    }

    osc.stop(noteNumber: noteNumber)
  }
}
