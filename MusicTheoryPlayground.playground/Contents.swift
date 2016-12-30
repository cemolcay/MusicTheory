import XCPlayground
import PlaygroundSupport
import AudioKit
import MusicTheory

class OscillatorBankChannel {
  var bank: AKOscillatorBank
  var scale: Scale
  var octave: Int

  private var playinSound: Int?

  init(scale: Scale, octave: Int) {
    bank = AKOscillatorBank()
    self.scale = scale
    self.octave = octave
  }

  func generateSound() -> Int {
    let randomNote = scale.notes.randomElement()
    return randomNote.midiKey(octave: octave)
  }

  func playSound() {
    if let sound = playinSound {
      bank.stop(noteNumber: sound)
    }

    playinSound = generateSound()
    guard let sound = playinSound else { return }
    bank.play(noteNumber: sound, velocity: 60)
  }
}

let scale = Scale.major(key: .a)
let bassChannel = OscillatorBankChannel(scale: scale, octave: 3)
let melodyChannel = OscillatorBankChannel(scale: scale, octave: 4)

let mixer = AKMixer(bassChannel.bank, melodyChannel.bank)
AudioKit.output = mixer
AudioKit.start()

AKPlaygroundLoop(every: 0.2, handler: {
  bassChannel.playSound()
  melodyChannel.playSound()
})

PlaygroundPage.current.needsIndefiniteExecution = true
