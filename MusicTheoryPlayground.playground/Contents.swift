import XCPlayground
import PlaygroundSupport
import AudioKit
import MusicTheory

let note = Note.e
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

  randomSound = notes.randomElement().midiKey(
    octave: Array(3..<6).randomElement())

  bank.play(
    noteNumber: randomSound!,
    velocity: 60)
})

PlaygroundPage.current.needsIndefiniteExecution = true
