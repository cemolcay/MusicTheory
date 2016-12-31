import XCPlayground
import MusicTheory
import AudioKit
import AudioKitHelper

let chordChannel = MTChordOscillator()
AudioKit.output = chordChannel
AudioKit.start()

AKPlaygroundLoop(every: 0.1, handler: {
  chordChannel.play(chord: .maj(key: .c))
})

PlaygroundPage.current.needsIndefiniteExecution = true
