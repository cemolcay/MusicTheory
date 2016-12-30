import XCPlayground
import PlaygroundSupport
import AudioKit
import MusicTheory

let note = Note.c
let scale = Scale.major(key: note)
let notes = scale.notes
print(notes)

let bank = AKOscillatorBank()
AudioKit.output = bank
AudioKit.start()

class PlaygroundView: AKPlaygroundView, AKKeyboardDelegate {

  override func setup() {
    let keyboard = AKKeyboardView(width: 440, height: 100)
    keyboard.delegate = self
    addSubview(keyboard)

    keyboard.polyphonicMode = true
  }

  func noteOn(note: MIDINoteNumber) {
    bank.play(noteNumber: note, velocity: 20)
  }

  func noteOff(note: MIDINoteNumber) {
    bank.stop(noteNumber: note)
  }
}

PlaygroundPage.current.liveView = PlaygroundView()
PlaygroundPage.current.needsIndefiniteExecution = true
