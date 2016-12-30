import XCPlayground
import PlaygroundSupport
import AudioKit
import MusicTheory

let note = Note.a
let scale = Scale.harmonicMinor(key: note)
let notes = scale.notes

let bank = AKOscillatorBank()
AudioKit.output = bank
AudioKit.start()

var randomSound: Int? = nil
AKPlaygroundLoop(every: 0.2, handler: {
  if let sound = randomSound {
    bank.stop(noteNumber: sound)
  }

  var randomNote = notes.randomElement()
  var randomOctave = Array(3..<6).randomElement()
  randomSound = randomNote.midiKey(octave: randomOctave)

  bank.play(
    noteNumber: randomSound!,
    velocity: 60)
})

PlaygroundPage.current.needsIndefiniteExecution = true
